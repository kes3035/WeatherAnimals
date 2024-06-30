//
//  LaunchVC.swift
//  WeatherAnimals
//
//  Created by 김은상 on 3/4/24.
//

/*
 
 런치스크린 로직 우선순위
 
 1. 사용자의 위치 설정이 되어 있는지 확인
  1.1 설정이 안되어있는 경우 설정에서 위치 설정할 수 있도록 화면 전환
  1.2 권한 설정이 되어있는 경우 2번으로
 2. CoreData로부터 사용자가 설정해놓은 지역 받아오기
 3. MainVC에 띄우기 위한 CurrentWeather 데이터 받아오기
 
 */

import UIKit
import CoreLocation
import CoreData

final class LaunchVC: UIViewController {
    //MARK: - Properties
    private lazy var titleLabel = UILabel().then {
        $0.text = "날씨보개"
        $0.font = UIFont.neoDeungeul(size: 48)
        $0.textColor = .white
        $0.textAlignment = .center
    }
    
    private let loadingLabel = UILabel().then {
        $0.text = ""
        $0.font = UIFont.neoDeungeul(size: 24)
        $0.textColor = UIColor.white
    }
    
    var locationViewModel = LocationViewModel() {
        didSet {
            // 앱 시작과 동시에 사용자 위치 받아오기
            self.locationViewModel.fetchLocation { [weak self] (location, error) in
                guard let location = location else { return }
                
                // 받아온 위치를 마이 뷰보델에 저장
                self?.myViewModel.makeUserLocation(with: location)
                
                // 받아온 위치를 로케이션 뷰모델에 저장
                self?.locationViewModel.makeUserLocation(with: location)
                
                
            }
        }
    }
    
    lazy var myViewModel = MyViewModel()
    
    lazy var viewModel = WeatherViewModel()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.animateLoadingLabel()
    }
    
    //MARK: - Helpers
    
}

extension LaunchVC {
    private func configureUI() {
        self.view.backgroundColor = Constants.greenColor
        self.view.addSubviews(titleLabel, loadingLabel)
        
        self.titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(150)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        self.loadingLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.view.snp.centerY).offset(30)
        }
    }
    
    private func animateLoadingLabel() {
        loadingLabel.text = ""
        var charIndex = 0.0
        let titleText = "Loading..."
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.2 * charIndex, repeats: false) { timer in
                DispatchQueue.main.async {
                    self.loadingLabel.text?.append(letter)
                }
            }
            charIndex += 1
        }
    }
}
