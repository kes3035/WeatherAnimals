//
//  MyViewModel.swift
//  WeatherAnimals
//
//  Created by 김은상 on 6/27/24.
//

import UIKit
import CoreLocation

// 통합 뷰모델
final class MyViewModel {
    
    // 코어데이터 저장하는 변수
    private var myCoreDatas: [MyData]?
    
    private var myDatas: [String: CLLocation]?
    
    // 사용자의 위치를 저장하는 변수
    private var userLocation: CLLocation?
    
    // 사용자의 위치 권한 승인 여부를 저장하는 변수
    var locationAuthState: Bool?

    
    func makeMyDatas() {
        
        
    }
    
    
    func makeCoreDatas(with coreDatas: [MyData]?) {
        self.myCoreDatas = coreDatas
    }
    
    
    func makeUserLocation(with location: CLLocation?) {
        self.userLocation = location
    }
    
}
