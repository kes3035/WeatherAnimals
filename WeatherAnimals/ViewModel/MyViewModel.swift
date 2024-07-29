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


// 통합 뷰모델
final class MyViewModel {
    // 새롭게 저장할 데이터 저장하는 변수
    private var myData: [String: CLLocation]?
    
    // 코어데이터 저장하는 변수
    private var myCoreDatas: [MyData]? {
        didSet {
            self.setMyDatas()
        }
    }
    
    private var myDatas: [[String: CLLocation]]?
    
    // 사용자의 위치를 저장하는 변수
    private var userLocation: CLLocation? {
        didSet {
            guard let userLocation = self.userLocation else { return }
            self.getMyLocationTitle(location: userLocation) { title in
                let userData = [[title: userLocation]]
                self.myDatas = userData
            }
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
    
    private var currentWeather: CurrentWeather?
    
    private var dayWeathers: [DayWeather]?
    
    private var hourlyWeathers: [HourWeather]?
    
    private var airQuality: AirQuality?
    
    
    var didFetchCurrentWeather: (()->())?
    
    // 날씨에 대한 데이터를 받아오는 것이 완료되면 실행되는 클로져
    var didFetchWeather: (()->())?
    
    // 사용자의 위치 권한 승인 여부를 저장하는 변수
    var locationAuthState: Bool?
    
    //MARK: - Logics
    func appendMyDatas(with myData: [String: CLLocation]) {
        self.myDatas?.append(myData)
    }
    
    
    //MARK: - Getter
    func getMyDatas() -> [[String: CLLocation]] {
        guard let myDatas = self.myDatas else { return [] }
        return myDatas
    }
    
    func getWeatherCellCount() -> Int {
        guard let myDatas = self.myDatas else { return 0 }
        return myDatas.count
    }
    
    func getWeatherCellData(forRowAt indexPath: Int) -> [String: CLLocation] {
        guard let myDatas = self.myDatas else { return [:] }
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
    
    func setMyData(with data: [String:CLLocation]) {
        self.myData = data
    }
    
    // 사용할 데이터(지역명, 위치)를 인덱스에 따라 배열로 생성하는 함수
    func setMyDatas() {
        guard let myCoreDatas = self.myCoreDatas else { return }
        var temporaryArr: [[String : CLLocation]] = Array(repeating: ["" : CLLocation()], count: myCoreDatas.count)
        for data in myCoreDatas {
            let longitude = data.longitude
            let latitude = data.latitude
            let title = data.title ?? ""
            let index = Int(data.index)
            let location = CLLocation(latitude: latitude, longitude: longitude)
            
            temporaryArr[index-1] = [title:location]
            
        }
        self.myDatas? += temporaryArr
    }
    
    func setSelectedCellIndex(cellForRowAt indexPath: IndexPath) {
        self.indexOfSelectedCell = indexPath.row
    }
    
    func setSelectedLocation(cellForRowAt indexPath: IndexPath) {
        self.selectedLocation = self.myDatas?[indexPath.row].values.first!
    }
    
    func setWeatherDataForDetailVC() {
        guard let selectedLocation = self.selectedLocation else { 
            print("Failed: setWeatherDataForDetailVC, Failed to unwrap selectedLocation")
            return
        }
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
    
    func setCurrentWeather(location: CLLocation, completion: @escaping(CurrentWeather)->()) {
        Task {
            do {
                let currentWeather = try await WeatherService.shared.weather(for: location, including: .current)
                self.currentWeather = currentWeather
                completion(currentWeather)
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
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func setDayWeathers(location: CLLocation) {
        Task {
            do {
                let dayWeathers = try await WeatherService.shared.weather(for: location, including: .daily).forecast
                self.dayWeathers = dayWeathers
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func setHourlyWeathers(location: CLLocation) {
        Task {
            do {
                let hourlyWeathers = try await WeatherService.shared.weather(for: location, including: .hourly).forecast
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
            self.myDatas?.append(myNewData)
            let indexOfNewModel = self.myDatas?.endIndex ?? 0

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
//    
    
    
    
    
    
    func makeCoreDatas(with coreDatas: [MyData]?) {
        self.myCoreDatas = coreDatas
    }
    
    
    func makeUserLocation(with location: CLLocation?) {
        self.userLocation = location
    }
    
    
}
