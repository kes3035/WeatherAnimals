//
//  MyViewModel.swift
//  WeatherAnimals
//
//  Created by 김은상 on 6/27/24.
//

import UIKit
import WeatherKit
import CoreLocation

// 통합 뷰모델
final class MyViewModel {
    
    // 코어데이터 저장하는 변수
    private var myCoreDatas: [MyData]? {
        didSet {
            print("myCoreDatas: [MyData] count == \(myCoreDatas?.count)")
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
    
    // 사용자의 위치 권한 승인 여부를 저장하는 변수
    var locationAuthState: Bool?

    
    
    
    
    // 사용할 데이터(지역명, 위치)를 인덱스에 따라 배열로 생성하는 함수
    func makeMyDatas() {
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
    
    func getMyDatas() -> [[String: CLLocation]] {
        return myDatas
    }
    
    func getWeatherCellCount() -> Int {
        return myDatas.count
    }
    
    func getWeatherCellData(forRowAt indexPath: Int) -> [String: CLLocation] {
        return myDatas[indexPath]
    }
    
    func getCurrentWeather(location: CLLocation, completion: @escaping(CurrentWeather)->()) {
        Task {
            do {
                let currentWeather = try await WeatherService.shared.weather(for: location, including: .current)
                completion(currentWeather)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        
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
    
    func makeCoreDatas(with coreDatas: [MyData]?) {
        self.myCoreDatas = coreDatas
        makeMyDatas()
    }
    
    
    func makeUserLocation(with location: CLLocation?) {
        self.userLocation = location
    }
    
    
    
}
