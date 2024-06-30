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
    private var myCoreDatas: [MyData]?
    
    private var myDatas: [[String: CLLocation]]?
    
    // 사용자의 위치를 저장하는 변수
    private var userLocation: CLLocation?
    
    // 사용자의 위치 권한 승인 여부를 저장하는 변수
    var locationAuthState: Bool?

    
    
    
    
    
    // 사용할 데이터(지역명, 위치)를 인덱스에 따라 배열로 생성하는 함수
    func makeMyDatas() {
        guard let myCoreDatas = self.myCoreDatas else { return }
        
        self.myDatas = Array(repeating: [:], count: myCoreDatas.count)
        
        for data in myCoreDatas {
            let longitude = data.longitude
            let latitude = data.latitude
            let title = data.title ?? ""
            let index = Int(data.index)
            let location = CLLocation(latitude: latitude, longitude: longitude)
            self.myDatas?[index] = [title:location]
        }
    }
    
    func getWeatherCellCount() -> Int {
        guard let myDatas = self.myDatas else { return 0 }
        return myDatas.count + 1
    }
    
    func getWeatherCellData(forRowAt indexPath: Int) -> [String: CLLocation] {
        guard let myDatas = self.myDatas else { return ["":CLLocation()] }
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
    
    func makeCoreDatas(with coreDatas: [MyData]?) {
        self.myCoreDatas = coreDatas
        makeMyDatas()
    }
    
    
    func makeUserLocation(with location: CLLocation?) {
        self.userLocation = location
    }
    
    func configureWeatherCell(with: MyData) {
        
        
    }
    
}
