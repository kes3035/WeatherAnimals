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
    
    private var userLocationByLocationTitle: LocationByTitle?
    
    private var coreDataLocationByLocationTitle: [LocationByTitle]?
    
    private var locationByLocationTitle: [LocationByTitle]?
    
    private var myDatas: [MyData]? {
        didSet {
            self.appendMyDatasMadeWithCoreDatas()
        }
    }
    
    private var userLocation: CLLocation? {
        didSet {
            self.setUserLocationByLocationTitle(with: self.userLocation)
        }
    }
    
    private var timeZone: TimeZone?
    
    private var indexOfSelectedCell: Int?
    
    private var selectedLocation: CLLocation? {
        didSet {
            guard let selectedLocation = self.selectedLocation else { return }
            self.setTimeZone(for: selectedLocation)
        }
    }
    
    private var weather: Weather?
    
    private var currentWeather: CurrentWeather?
    
    private var currentWeathers: [CurrentWeather]?
    
    private var dayWeathers: [DayWeather]?
    
    private var hourlyWeathers: [HourWeather]?
    
    private var airQuality: AirQuality?
    
    var didFetchWeather: (()->())?
    
    var didFetchUserData: (()->())?
    
    var locationAuthState: Bool?
    
    //MARK: - Logics
    func appendMyDatas(with myData: [String: CLLocation]) {
        self.locationByLocationTitle?.append(myData)
    }
    
    func appendMyDatasMadeWithCoreDatas() {
        guard let myDatas = self.myDatas,
            !myDatas.isEmpty else { return }
        // 코어데이터에서 받아온 데이터로 [지역명:위치] 베열 형태로 저장하는거부터 다시
        var temporaryArr = Array(repeating: ["" : CLLocation()], count: myDatas.count)
        
        for myData in myDatas {
            let longitude = myData.longitude
            let latitude = myData.latitude
            let location = CLLocation(latitude: latitude, longitude: longitude)
            
            let title = myData.title ?? "로딩중"
            let index = Int(myData.index) - 1
            
            temporaryArr[index] = [title:location]
        }
        
        var myUsableDatas = self.getMyDatas()
        myUsableDatas += temporaryArr
        self.setMyDatas(with: myUsableDatas)
    }
    
    func makeLocationByTitleArr() {
        
    }
    
    //MARK: - Getter
    func getMyDatas() -> [[String: CLLocation]] {
        guard let myUsableDatas = self.locationByLocationTitle else {
            print("Failed to Unwrapping myUsableDatas")
            return []
        }
        return myUsableDatas
    }
    
    func getWeather() -> Weather? {
        return self.weather
    }
    
    func getWeatherCellCount() -> Int {
        guard let myDatas = self.locationByLocationTitle else { return 0 }
        return myDatas.count
    }
    
    func getWeatherCellData(forRowAt indexPath: Int) -> [String: CLLocation] {
        guard let myDatas = self.locationByLocationTitle else { return [:] }
        return myDatas[indexPath]
    }
    
    func getCurrentWeather() -> CurrentWeather? {
        return self.currentWeather
    }
    
    func getHourlyWeathers() -> [HourWeather]? {
        return self.hourlyWeathers
    }
    
    func getDailyWeathers() -> [DayWeather]? {
        return self.dayWeathers
    }
    
    func getDataForDetailVCTopView(completionHandler: @escaping((String, String, String)->())) {
        guard let dayWeathers = self.dayWeathers,
              let current = self.currentWeather else { completionHandler("", "", ""); return }
        let currentTemp = String(round(current.temperature.value)) +  "°"
        let highestTemp = "최고 : " + String(round(dayWeathers[0].highTemperature.value)) +  "°"
        let lowestTemp = "최저 : " + String(round(dayWeathers[0].lowTemperature.value)) +  "°"
        completionHandler(currentTemp, highestTemp, lowestTemp)
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
    
    
    func setCoreDatas(with myDatas: [MyData]) {
        self.myDatas = myDatas
    }
    
    func setUserLocationByLocationTitle(with userLocation: CLLocation?) {
        guard let userLocation = userLocation else { return }
        Task {
            do {
                let title = try await self.getLocationTitle(for: userLocation)
                self.userLocationByLocationTitle = [title: userLocation]
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func setMyDatas(with myDatas: [[String:CLLocation]]?) {
        self.locationByLocationTitle = myDatas
    }
    
    func setSelectedCellIndex(cellForRowAt indexPath: IndexPath) {
        self.indexOfSelectedCell = indexPath.row
    }
    
    func setSelectedLocation(cellForRowAt indexPath: IndexPath) {
        self.selectedLocation = self.locationByLocationTitle?[indexPath.row].values.first!
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
                
                let weather = Weather(currentWeather: currentWeather, hourlyWeathers: hourlyWeathers, dailyWeathers: dailyWeathers)
                self.weather = weather
                self.didFetchWeather?()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func setWeatherDataForDetailVC() {
        guard let selectedLocation = self.selectedLocation else { return }
        Task {
            do {
                guard let timeZone = self.getTimeZone() else { return }
                var calendar = Calendar.current
                calendar.timeZone = timeZone
                
                let currentDate = Date()

                guard let tenDaysLater = calendar.date(byAdding: .day, value: 10, to: currentDate),
                      let tenHoursLater = calendar.date(byAdding: .hour, value: 10, to: currentDate) else { return }
                
                let currentWeather = try await WeatherService.shared.weather(for: selectedLocation, including: .current)
                let dayWeathers = try await WeatherService.shared.weather(for: selectedLocation, including: .daily(startDate: currentDate, endDate: tenDaysLater)).forecast
                let hourlyWeathers = try await WeatherService.shared.weather(for: selectedLocation, including: .hourly(startDate: currentDate, endDate: tenHoursLater)).forecast
                self.currentWeather = currentWeather
                self.dayWeathers = dayWeathers
                self.hourlyWeathers = hourlyWeathers
                print("Debug: will run DidFetchWeather")
                self.didFetchWeather?()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func setWeatherDataForDetailVC(for location: CLLocation) {
        let selectedLocation = location
        Task {
            do {
                let weatherDataForDetailVC = try await WeatherService.shared.weather(for: selectedLocation, including: .current, .daily, .hourly)
                self.currentWeather = weatherDataForDetailVC.0
                self.dayWeathers = weatherDataForDetailVC.1.forecast
                self.hourlyWeathers = weatherDataForDetailVC.2.forecast
                self.didFetchWeather?()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }

    
    func setCurrentWeather(location: CLLocation) {
        Task {
            do {
                let currentWeather = try await WeatherService.shared.weather(for: location, including: .current)
                self.currentWeather = currentWeather
                self.didFetchWeather?()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    
    func setDayWeathers(location: CLLocation) {
        Task {
            do {
                guard let timeZone = self.getTimeZone() else { return }
                var calendar = Calendar.current
                calendar.timeZone = timeZone
                
                let currentDate = Date()
                guard let tenDaysLater = calendar.date(byAdding: .day, value: 10, to: currentDate) else { return }
                
                let dayWeathers = try await WeatherService.shared.weather(for: location, including: .daily(startDate: currentDate, endDate: tenDaysLater)).forecast
                self.dayWeathers = dayWeathers
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func setHourlyWeathers(location: CLLocation) {
        Task {
            do {
                guard let timeZone = self.getTimeZone() else { return }
                var calendar = Calendar.current
                calendar.timeZone = timeZone
                
                let currentDate = Date()
                guard let tenHoursLater = calendar.date(byAdding: .hour, value: 10, to: currentDate) else { return }
                
                let hourlyWeathers = try await WeatherService.shared.weather(for: location, including: .hourly(startDate: currentDate, endDate: tenHoursLater)).forecast
                
                self.hourlyWeathers = hourlyWeathers
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
                  let myNewData = self.myData else { return }
            let myDatas = self.getMyDatas()
            
            let indexOfNewModel = myDatas.endIndex
            

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
