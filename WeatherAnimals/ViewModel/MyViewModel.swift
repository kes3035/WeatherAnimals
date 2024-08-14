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

// 통합 뷰모델
final class MyViewModel {

    private var myData: LocationByTitle?
    
    private var locationByTitle: [LocationByTitle]? 
    
    private var weathers: [Weather]?
    
    private var myDatas: [MyData]?
    
    private var userLocation: CLLocation? 
    
    private var timeZone: TimeZone?
    
    private var indexOfSelectedCell: Int?
    
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
    
    func getCoreDataLocationByTitle(_ myDatas: [MyData]) async throws -> [LocationByTitle] {
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
    
    
    
    //MARK: - Getter
    func getLocationByTitle() -> [LocationByTitle]? {
        return self.locationByTitle
    }
    
    func getWeathers() -> [Weather]? {
        return self.weathers
    }
    
    func getWeather(for location: CLLocation) async throws -> Weather {
        let currentWeather = try await WeatherService.shared.weather(for: location, including: .current)
        let dailyWeathers = try await WeatherService.shared.weather(for: location, including: .daily).forecast
        let hourlyWeathers = try await WeatherService.shared.weather(for: location, including: .hourly).forecast

        return Weather(currentWeather: currentWeather, hourlyWeathers: hourlyWeathers, dailyWeathers: dailyWeathers)
    }
    
    func getWeathers(for locations: [CLLocation]) async throws -> [Weather] {
        var weathers: [Weather] = []
        
        for location in locations {
            let weather = try await getWeather(for: location)
            weathers.append(weather)
        }
        return weathers
    }
    
    func getWeathers(cellForRowAt indexPath: Int) -> Weather? {
        return self.weathers?[indexPath]
    }
   
    func getWeather(for location: CLLocation, completionHandler: @escaping((Weather)->())) {
        Task {
            do {
                guard let timeZone = self.getTimeZone() else { return }
                var calendar = Calendar.current
                calendar.timeZone = timeZone
                
                let currentDate = Date()

                guard let tenDaysLater = calendar.date(byAdding: .day, value: 10, to: currentDate),
                      let tenHoursLater = calendar.date(byAdding: .hour, value: 10, to: currentDate) else { return }
                
                print(tenDaysLater)
                print(tenHoursLater)
                let currentWeather = try await WeatherService.shared.weather(for: location, including: .current)
                let dailyWeathers = try await WeatherService.shared.weather(for: location, including: .daily(startDate: currentDate, endDate: tenDaysLater)).forecast
                let hourlyWeathers = try await WeatherService.shared.weather(for: location, including: .hourly(startDate: currentDate, endDate: tenHoursLater)).forecast
                
                let weather = Weather(currentWeather: currentWeather, hourlyWeathers: hourlyWeathers, dailyWeathers: dailyWeathers)
                completionHandler(weather)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    
    func getWeatherCellCount() -> Int {
        guard let locationByTitle = self.locationByTitle else { return 0 }
        return locationByTitle.count
    }
    
    func getWeatherCellData(forRowAt indexPath: Int) -> [String: CLLocation] {
        guard let locationByTitle = self.locationByTitle else { return [:] }
        return locationByTitle[indexPath]
    }

    
    func getMyLocationTitle(location: CLLocation, completion: @escaping((String) -> ())) {
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
    
    func getLocationTitle(for location: CLLocation) async throws -> String {
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
    
    
    
    func getAirQualityCondition() -> AirQuality? {
        return self.airQuality
    }
    
    func getSelectedLocation() -> CLLocation? {
        return self.selectedLocation
    }
    
    func getSelectedIndex() -> Int? {
        return self.indexOfSelectedCell
    }
    
    func getTimeZone() -> TimeZone? {
        return self.timeZone
    }
    
    func getTimeZone(for location: CLLocation) async throws -> TimeZone {
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
    
//    func setWeathers(with locationByTitle: [LocationByTitle]) async {
//        var weathers: [Weather] = []
//
//        for locByTitle in locationByTitle {
//            guard let location = locByTitle.values.first else { continue }
//
//            let weather = await getWeather(for: location)
//            weathers.append(weather)
//        }
//
//        self.weathers = weathers
//    }
    
    func setWeathers(with weathers: [Weather]) {
        self.weathers = weathers
    }
    
    func setWeathers(with locationByTitle: [LocationByTitle]) {
        var weathers: [Weather] = []
        for locByTitle in locationByTitle {
            
            guard let location = locByTitle.values.first else { continue }
            
            self.getWeather(for: location) { weather in
                print(weather)
                weathers.append(weather)
            }
        }
        self.weathers = weathers
    }
    
    func setSelectedCellIndex(cellForRowAt indexPath: IndexPath) {
        self.indexOfSelectedCell = indexPath.row
    }
    
    func setSelectedLocation(cellForRowAt indexPath: IndexPath) {
        self.selectedLocation = self.locationByTitle?[indexPath.row].values.first!
    }
    
    func setWeather(for location: CLLocation) {
        Task {
            do {
                guard let timeZone = self.getTimeZone() else { return }
                var calendar = Calendar.current
                calendar.timeZone = timeZone
                
                let currentDate = Date()

                guard let tenDaysLater = calendar.date(byAdding: .day, value: 10, to: currentDate),
                      let tenHoursLater = calendar.date(byAdding: .hour, value: 10, to: currentDate) else { return }
                
                let currentWeather = try await WeatherService.shared.weather(for: location, including: .current)
                let dailyWeathers = try await WeatherService.shared.weather(for: location, including: .daily(startDate: currentDate, endDate: tenDaysLater)).forecast
                let hourlyWeathers = try await WeatherService.shared.weather(for: location, including: .hourly(startDate: currentDate, endDate: tenHoursLater)).forecast

                self.didFetchWeather?()
            } catch let error {
                print(error.localizedDescription)
            }
        }
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
    
    
    // Issue: AddCoreData Logic should modify
    /*
     현재 내가 가진 myDatas의 endIndex를 새롭게 저장할 데이터의 인덱스로 저장해야 함
     */
    
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
//            self.myDatas?.append(myNewData)

            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
            
            
        }
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
    
//
//    func getHourlyWeather(location: CLLocation, completion: @escaping(([HourWeather])->())) {
//        do {
//            let hourWeathers = try await WeatherService.shared.weather(for: location, including: .hourly)
//            completion(hourWeathers.forecast)
//        } catch let error {
//            print(error.localizedDescription)
//        }
//    }

}
