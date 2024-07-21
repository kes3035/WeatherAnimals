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
    
    // 코어데이터 저장하는 변수
    private var myCoreDatas: [MyData]? {
        didSet {
            print("myCoreDatas: [MyData] count == \(String(describing: myCoreDatas?.count))")
        }
    }
    
    private lazy var myDatas: [[String: CLLocation]] = [] {
        didSet {
            print("myDatas: [[String: CLLocation]] count == \(myDatas.count)")
        }
    }
    
    // 사용자의 위치를 저장하는 변수
    private var userLocation: CLLocation? {
        didSet {
            guard let userLocation = self.userLocation else {
                print("Debug : Failed to unwrap userLocation ")
                return
            }
            self.getMyLocationTitle(location: userLocation) { title in
                let userData = [title: userLocation]
                self.myDatas.append(userData)
            }
        }
    }
    
    private var indexOfSelectedCell: Int?
    
    private var selectedLocation: CLLocation? {
        didSet {
            
        }
    }
    
    private var currentWeather: CurrentWeather? {
        didSet {
            print("Debug: CurrentWeather Changed")
        }
    }
    
    private var dayWeathers: [DayWeather]? {
        didSet {
            print("Debug: DayWeathers Changed")
        }
    }
    
    private var hourlyWeathers: [HourWeather]? {
        didSet {
            print("Debug: HourlyWeathers Changed")
        }
    }
    
    
    var didFetchCurrentWeather: (()->())?
    
    // 날씨에 대한 데이터를 받아오는 것이 완료되면 실행되는 클로져
    var didFetchWeather: (()->())?
    
    // 사용자의 위치 권한 승인 여부를 저장하는 변수
    var locationAuthState: Bool?
    
    //MARK: - Logics
    
    
    //MARK: - Getter
    func getMyDatas() -> [[String: CLLocation]] {
        return myDatas
    }
    
    func getWeatherCellCount() -> Int {
        return myDatas.count
    }
    
    func getWeatherCellData(forRowAt indexPath: Int) -> [String: CLLocation] {
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
    
    //MARK: - Setter
    // 사용할 데이터(지역명, 위치)를 인덱스에 따라 배열로 생성하는 함수
    func setMyDatas() {
        guard let myCoreDatas = self.myCoreDatas else { return }
        
        let emptyArr: [[String: CLLocation]] = Array(repeating: ["":CLLocation()], count: myCoreDatas.count)
        
        self.myDatas += emptyArr
        
        for data in myCoreDatas {
            let longitude = data.longitude
            let latitude = data.latitude
            let title = data.title ?? ""
            let index = Int(data.index)
            let location = CLLocation(latitude: latitude, longitude: longitude)
            self.myDatas[index] = [title:location]
        }
    }
    
    func setSelectedCellIndex(cellForRowAt indexPath: IndexPath) {
        self.indexOfSelectedCell = indexPath.row
    }
    
    func setSelectedLocation(cellForRowAt indexPath: IndexPath) {
        self.selectedLocation = self.myDatas[indexPath.row].values.first!
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
    
    
    func addWeatherModelIntoLocal() {
        DispatchQueue.main.async {
            guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
            let context = sceneDelegate.persistentContainer.viewContext
            guard let entity = NSEntityDescription.entity(forEntityName: "MyData", in: context),
                  let indexOfSelectedCell = self.indexOfSelectedCell,
                  let locationTitle = self.myDatas[indexOfSelectedCell].keys.first,
                  let location = self.myDatas[indexOfSelectedCell].values.first else { return }
            
            let myData = NSManagedObject(entity: entity, insertInto: context)
            myData.setValue(location.coordinate.latitude, forKey: "latitude")
            myData.setValue(location.coordinate.longitude, forKey: "longitude")
            myData.setValue(locationTitle, forKey: "title")
            myData.setValue(Int16(indexOfSelectedCell), forKey: "index")
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
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
        setMyDatas()
    }
    
    
    func makeUserLocation(with location: CLLocation?) {
        self.userLocation = location
    }
    
    
}
