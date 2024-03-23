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
        $0.text = "Loading..."
        $0.font = UIFont.neoDeungeul(size: 24)
        $0.textColor = UIColor.white
    }
    
    private lazy var loadingBar = UIView().then { $0.backgroundColor = .white }
    
    var locationViewModel: LocationViewModel! = LocationViewModel() {
        didSet {
            self.locationViewModel.fetchLocation { [weak self] (location, error) in
            self?.locationViewModel.loc = CLLocation(latitude: location?.latitude ?? 0.0, longitude: location?.longitude ?? 0.0)
            }
        }
    }
    
    var viewModel: WeatherViewModel!
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.locationViewModel = LocationViewModel()
        self.viewModel = WeatherViewModel()
        self.configureUI()
    }
    
    //MARK: - Helpers
    private func configureUI() {
        self.view.backgroundColor = Constants.greenColor
        self.view.addSubviews(titleLabel, loadingBar, loadingLabel)
        
        self.titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(150)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        self.loadingBar.snp.makeConstraints {
            $0.top.equalTo(self.view.snp.centerY).offset(30)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(self.view.frame.size.width*3/4)
            $0.height.equalTo(12)
        }
        
        self.loadingLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(self.loadingBar.snp.top).offset(-10)
        }
    }
    
    func configureLoadingBar() {
        
        DispatchQueue.main.async {
            self.loadingLabel.text = "34%..."
        }
    }
    
    func configureLoadingBar2() {
        
        DispatchQueue.main.async {
            self.loadingLabel.text = "68%..."
        }
    }
}
