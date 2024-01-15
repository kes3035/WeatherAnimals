import UIKit
import WeatherKit
import SnapKit
import Then
import CoreLocation


final class MainVC: UIViewController {
//MARK: - Properties
    private lazy var tableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
    }
    
    private lazy var locationTitle = UILabel().then {
        $0.text = "대한민국 용인시"
    }
    
    private lazy var currentTemp = UILabel().then {
        $0.text = "17"
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    
    private lazy var plusImage = UIImageView().then {
        let image = UIImage(systemName: "plus.circle.fill")?.withRenderingMode(.alwaysTemplate)
        $0.image = image
        $0.tintColor = Constants.greenColor
        $0.isUserInteractionEnabled = true
        $0.contentMode = .scaleAspectFit
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(plusButtonTapped(_:))))
    }
    
    var weatherViewModel = WeatherViewModel()
    
    var locationViewModel = LocationViewModel()
//MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        settingNav()
        settingTV()
        settingLocation()
    }
    
    
    
//MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(self.view.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func settingNav() {
        let attributes = [
            NSAttributedString.Key.font: UIFont(name: "NeoDunggeunmoPro-Regular", size: 34.0)!]
        let attributedString = NSAttributedString(string: "날씨보개", attributes: attributes)
        let titleLabel = UILabel()
        titleLabel.textAlignment = .left
        titleLabel.attributedText = attributedString
        titleLabel.sizeToFit()
        let leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        plusImage.frame = CGRect(x: 0, y: 0, width: 26, height: 26)
        let rightBarButtonItem = UIBarButtonItem(customView: plusImage)
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    
    private func settingTV() {
        tableView.register(WeatherCell.self, forCellReuseIdentifier: WeatherCell.identifier)
        tableView.rowHeight = self.view.frame.height/7
    }
    
    
    private func settingLocation() {
        locationViewModel.fetchLocation { [weak self] (location, error) in
            self?.locationViewModel.loc = CLLocation(latitude: location?.latitude ?? 0.0, longitude: location?.longitude ?? 0.0)
            
        }
        
    }
    
    
    
    
//MARK: - Actions
    @objc func plusButtonTapped(_ sender: UIButton) {
        let addVC = AddVC()
        addVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(addVC, animated: true)
    }


}

//MARK: - Extensions
extension MainVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 기본 화면에서 보여질 정보들
        /*
         1. 현재 기온
         2. 주소
         3. 날씨 아이콘
         4. 동물 아이콘
         5. 최고, 최저 기온(미정)
         */
        
        // 셀 생성 및 기본 설정
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherCell.identifier, for: indexPath) as! WeatherCell
        cell.selectionStyle = .none
        
       
//        self.weatherViewModel.getDayWeather(location: self.weatherViewModel.yongin) { forecasts in
//            cell.dayWeather = forecasts[indexPath.row]
//        }
        // 셀에 데이터 전달
        self.weatherViewModel.getCurrentWeather(location: self.weatherViewModel.yongin) { weather in
            cell.weather = weather
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 셀이 선택되었을 때 넘어가야 할 정보
        /*
         1. 현재 기온
         2. 최고, 최저 기온
         3. 10일간의 날씨정보
         4. 현재 날씨 간단한 코멘트 (ex - 맑음)
         5. 대기질
         6. 강수량
         7. 습도
         .
         .
         아이폰 기본 날씨앱에서 들어가면 나오는 모든 정보들
         */
        
        let detailVC = DetailVC()
        
        
        
        self.weatherViewModel.getCurrentWeather(location: self.weatherViewModel.yongin) { weather in
            detailVC.weather = weather
        }
        
        self.weatherViewModel.getDayWeather(location: self.weatherViewModel.yongin) { dayWeather in
            detailVC.dayWeather = dayWeather.forecast
        }
        
        self.weatherViewModel.getHourlyWeather(location: self.weatherViewModel.yongin) { hourWeather in
            detailVC.hourWeather = hourWeather.forecast
        }
        
        detailVC.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
}
