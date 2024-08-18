//
//  MyViewModel.swift
//  WeatherAnimals
//
//  Created by 김은상 on 6/27/24.
//

import UIKit
import WeatherKit
import CoreLocation
import CoreData

typealias LocationByTitle = [String:CLLocation]

final class MyViewModel {

    private var myData: LocationByTitle?
    
    private var locationByTitle: [LocationByTitle]? 
    
    private var weathers: [MyWeather]?
    
    private var myDatas: [MyData]?
    
    private var userLocation: CLLocation? 
    
    private var timeZone: TimeZone?
    
    private var selectedIndex: Int?
    
    private var selectedLocation: CLLocation? {
        didSet {
            guard let selectedLocation = self.selectedLocation else { return }
            self.setTimeZone(for: selectedLocation)
        }
    }
    
    private var airQuality: AirQuality?
    
    var didFetchWeather: (()->())?
    
    var didFetchUserData: (()->())?
    
    var locationAuthState: Bool?
    
    //MARK: - Logics
    func appendMyDatas(with myData: [String: CLLocation]) {
        self.locationByTitle?.append(myData)
    }
    
    func fetchCoreDataLocationByTitle(_ myDatas: [MyData]) async throws -> [LocationByTitle] {
        guard !myDatas.isEmpty else { return [] }
        
        let temporaryArr: [[String: CLLocation]] = myDatas.map { myData in
            let longitude = myData.longitude
            let latitude = myData.latitude
            let location = CLLocation(latitude: latitude, longitude: longitude)
            let title = myData.title ?? "로딩중"
            
            return [title: location]
        }.sorted { (dict1, dict2) -> Bool in
            let index1 = Int(myDatas.first(where: { $0.title ?? "로딩중" == dict1.keys.first })?.index ?? 0)
            let index2 = Int(myDatas.first(where: { $0.title ?? "로딩중" == dict2.keys.first })?.index ?? 0)
            return index1 < index2
        }
        
        return temporaryArr
    }

    
    func convert2UTC(from date: Date) -> Date {
        guard let timeZone = self.getTimeZone() else { return Date() }
        var calendar = Calendar.current
        calendar.timeZone = timeZone
        
        let components = calendar.dateComponents(in: timeZone, from: date)
        let utcTimeZone = TimeZone(abbreviation: "UTC")!
        var utcCalendar = Calendar.current
        utcCalendar.timeZone = utcTimeZone
        
        return utcCalendar.date(from: components) ?? Date()
    }
    
    func addWeatherModelIntoLocal() {
        DispatchQueue.main.async {
            guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
            let context = sceneDelegate.persistentContainer.viewContext
            guard let entity = NSEntityDescription.entity(forEntityName: "MyData",
                                                          in: context),
                  let myNewData = self.myData,
            let locationByTitle = self.getLocationByTitle() else { return }
           
            
            let indexOfNewModel = locationByTitle.endIndex
            

            let myData = NSManagedObject(entity: entity, insertInto: context)
            

            myData.setValue(myNewData.values.first!.coordinate.latitude, forKey: "latitude")
            myData.setValue(myNewData.values.first!.coordinate.longitude, forKey: "longitude")
            myData.setValue(myNewData.keys.first!, forKey: "title")
            myData.setValue(Int16(indexOfNewModel), forKey: "index")

            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    //MARK: - Fetcher
    
    func fetchWeather(for location: CLLocation) async throws -> MyWeather {
        let currentDate = Date()
        let calendar = Calendar.current
        
        guard let tenHoursLater = calendar.date(byAdding: .hour, value: 10, to: currentDate) else {
            throw NSError(domain: "DateCalculationError", code: 0, userInfo: nil)
        }
        do {
            let currentWeather = try await WeatherService.shared.weather(for: location, including: .current)
            let dailyWeathers = try await WeatherService.shared.weather(for: location, including: .daily).forecast
            let hourlyForecasts = try await WeatherService.shared.weather(for: location, including: .hourly(startDate: currentDate, endDate: tenHoursLater))
            let hourlyWeathers = hourlyForecasts.forecast
            guard !dailyWeathers.isEmpty, !hourlyWeathers.isEmpty else {
                throw NSError(domain: "WeatherDataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No weather data available"])
            }
            
            let myWeather = MyWeather(currentWeather: currentWeather, dailyWeathers: dailyWeathers, hourlyWeathers: hourlyWeathers)
            return myWeather
            
        } catch {
            print("Failed to fetch weather: \(error.localizedDescription)")
            throw error
        }
    }
    
    func fetchWeathers(for locations: [CLLocation]) async throws -> [MyWeather] {
        var weathers: [MyWeather] = []
        
        for location in locations {
            let weather = try await fetchWeather(for: location)
            weathers.append(weather)
        }
        return weathers
    }
    
    func fetchMyLocationTitle(location: CLLocation, completion: @escaping((String) -> ())) {
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        DispatchQueue.global().async {
            geocoder.reverseGeocodeLocation(location, preferredLocale: locale, completionHandler: {(placemarks, error) in
                if let address: [CLPlacemark] = placemarks {
                    var myAdd: String = ""
                    if let area: String = address.last?.locality{
                        myAdd += area
                    }
                    if let country: String = address.last?.country {
                        myAdd += ", "
                        myAdd += country
                    }
                    completion(myAdd)
                }
            })
        }
    }
    
    func fetchLocationTitle(for location: CLLocation) async throws -> String {
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        
        return try await withCheckedThrowingContinuation { continuation in
            geocoder.reverseGeocodeLocation(location, preferredLocale: locale) { placemarks, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let placemarks = placemarks, let address = placemarks.last else {
                    continuation.resume(returning: "Unknown location")
                    return
                }
                
                var myAdd = ""
                if let area = address.locality {
                    myAdd += area
                }
                if let country = address.country {
                    myAdd += ", "
                    myAdd += country
                }
                
                continuation.resume(returning: myAdd)
            }
        }
    }
    
    func fetchTimeZone(for location: CLLocation) async throws -> TimeZone {
        return try await withCheckedThrowingContinuation { continuation in
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                if let placemark = placemarks?.first, let timeZone = placemark.timeZone {
                    continuation.resume(returning: timeZone)
                } else {
                    continuation.resume(throwing: NSError(domain: "NoTimeZoneFound", code: 0, userInfo: nil))
                }
            }
        }
    }
    
    
    //MARK: - Getter
    func getLocationByTitle() -> [LocationByTitle]? {
        return self.locationByTitle
    }
    
    func getWeathers() -> [MyWeather]? {
        return self.weathers
    }
    
    
    func getWeathers(cellForRowAt indexPath: Int) -> MyWeather? {
        return self.weathers?[indexPath]
    }
    
    func getWeatherCellCount() -> Int {
        guard let locationByTitle = self.locationByTitle else { return 0 }
        return locationByTitle.count
    }
    
    func getHourlyWeathers() -> [HourWeather] {
        guard let weathers = self.weathers,
              let selectedIndex = self.selectedIndex else { return [] }
        
        return weathers[selectedIndex].hourlyWeathers
    }
    
    func getDailyWeathers() -> [DayWeather] {
        guard let weathers = self.weathers,
              let selectedIndex = self.selectedIndex else { return [] }
        
        return weathers[selectedIndex].dailyWeathers
    }
    
    func getAirQualityCondition() -> AirQuality? {
        return self.airQuality
    }
    
    func getSelectedLocation() -> CLLocation? {
        return self.selectedLocation
    }
    
    func getSelectedIndex() -> Int? {
        return self.selectedIndex
    }
    
    func getTimeZone() -> TimeZone? {
        return self.timeZone
    }
    
    //MARK: - Setter
    func setUserLocation(with userLocation: CLLocation?) {
        self.userLocation = userLocation
    }
    
    func setMyData(with myData: [String:CLLocation]?) {
        self.myData = myData
    }
    
    func setLocationByTitle(_ locationByTitle: [LocationByTitle]) {
        self.locationByTitle = locationByTitle
    }
    
    func setCoreDatas(with myDatas: [MyData]) {
        self.myDatas = myDatas
    }
    
    func setMyDatas(with myDatas: [[String:CLLocation]]?) {
        self.locationByTitle = myDatas
    }

    
    func setWeathers(with weathers: [MyWeather]) {
        self.weathers = weathers
    }
    
    
    func setSelectedCellIndex(cellForRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
    }
    
    func setSelectedLocation(cellForRowAt indexPath: IndexPath) {
        self.selectedLocation = self.locationByTitle?[indexPath.row].values.first!
    }

    
    func setAirQualityCondition(location: CLLocation) {
        let lat = location.coordinate.latitude.magnitude
        let lng = location.coordinate.longitude.magnitude
        
        guard let url = URL(string: "https://api.waqi.info/feed/geo:\(lat);\(lng)/?token=\(APIKey.aqicn_key)")
        else { return }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Invalid HTTP Response")
                return
            }

            guard let responseData = data else {
                print("No data received")
                return
            }
            
            do {
                let airQualityResponse = try JSONDecoder().decode(AirQualityResponse.self, from: responseData)
                let aqi = airQualityResponse.data
                // 여기서 필요한 정보를 사용하여 AirQuality 구조체를 생성하거나 다른 작업을 수행할 수 있습니다.
                let airQuality = AirQuality(aqi: aqi.aqi) // 여기서 최대, 최소 AQI 값은 API 응답에서 가져와야 합니다.
                
                self.airQuality = airQuality
                // 이후에 필요한 처리를 진행합니다.
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
            
        }
        task.resume()
    }

    
    
    func setTimeZone(for location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Geocoder failed with error: \(error.localizedDescription)")
                return
            }
            
            if let placemark = placemarks?.first, let timeZone = placemark.timeZone {
                self.timeZone = timeZone
            }
        }
    }
    
    func setTimeZone(with timeZone: TimeZone) {
        self.timeZone = timeZone
    }
}

extension MyViewModel {
    func testDateForWeather(location: CLLocation) async throws {
        let weather = try await WeatherService.shared.weather(for: location)
        
        print("Current Date = \(Date())")
        
        print("weather.currentWeather.date = \(weather.currentWeather.date)")
        print("weather.dailyForecast.forecast.count = \(weather.dailyForecast.forecast.count)")
        print("weather.dailyForecast.forecast.first?.date = \(String(describing: weather.dailyForecast.forecast.first?.date))")
        print("weather.dailyForecast.forecast.last?.date = \(String(describing: weather.dailyForecast.forecast.last?.date))")
        print("weather.hourlyForecast.forecast.count = \(weather.hourlyForecast.forecast.count)")
        print("weather.hourlyForecast.forecast.first?.date = \(String(describing: weather.hourlyForecast.forecast.first?.date))")
        print("weather.hourlyForecast.forecast.last?.date = \(String(describing: weather.hourlyForecast.forecast.last?.date))")
        
        let currentDate = Date()
        let calendar = Calendar.current
        
        guard let tenHoursLater = calendar.date(byAdding: .hour, value: 10, to: currentDate) else {
            throw NSError(domain: "DateCalculationError", code: 0, userInfo: nil)
        }
        
        print("------------------------------------------------------------------------------------")
                
        let currentWeather = weather.currentWeather
        let hourlyWeathers = try await WeatherService.shared.weather(for: location, including: .hourly(startDate: currentDate, endDate: tenHoursLater))
        print("currentWeather.date = \(currentWeather.date)")
        print("hourlyWeathers.count = \(hourlyWeathers.count)")
        print("hourlyWeathers.first?.date = \(String(describing: hourlyWeathers.first?.date))")
        print("hourlyWeathers.last?.date = \(String(describing: hourlyWeathers.last?.date))")
        
    }
}
