//
//  SunsetCell.swift
//  WeatherAnimals
//
//  Created by 김은상 on 1/24/24.
//

import UIKit

final class SunsetCell: UICollectionViewCell {
    static let identifier = "SunsetCell"
    //MARK: - Properties
    
    private lazy var baseView = UIView().then {
        $0.backgroundColor = UIColor(named: "background")
    }
    
    private lazy var sunsetLabel = UILabel().then {
        $0.text = "PM 6:23"
        $0.font = UIFont.neoDeungeul(size: 50)
        $0.textColor = .black
    }
    
    var weatherViewModel: WeatherViewModel! {
        didSet {
            self.configureSunsetCellUIWithData()
        }
    }
    
    lazy var myViewModel = MyViewModel() {
        didSet {
            self.configureSunsetCellUIWithData()
        }
    }
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureSunsetCellUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    //MARK: - Helpers
    private func configureSunsetCellUI() {
        
        self.backgroundColor = .white
        
        self.addSubview(baseView)
        
        self.baseView.addSubviews(sunsetLabel)
        
        self.baseView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.sunsetLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.height.equalTo(40)
        }
    }
    
    // Issue : 일몰시간 일출시간 현재 시각에 따라 조정하는 기능 만들기
    private func configureSunsetCellUIWithData() {
        guard let dayWeathers = self.myViewModel.getDailyWeathers() else { return }
        
        let sunrise = dayWeathers[0].sun.sunrise
        let sunset = dayWeathers[0].sun.sunset
        
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a h:mm"
        
        let sunrisee = dateFormatter.string(from: dayWeathers[0].sun.sunset ?? Date())
        
/*
24시 이후
일출 전            : 일출시간
일출 후 - 일몰 전    : 일몰시간
일몰 후            :
 */
        
        
        if isAfterSunrise() {
            // 일출 시간보다 지난 시간이면 일몰 시간을 화면에 띄움
        } else {
            // 일출 시간 전이면 일출 시간을 화면에 띄움
        }
        
        DispatchQueue.main.async {
            self.sunsetLabel.text = sunrisee
        }
    }
    
    private func isAfterSunrise() -> Bool {
        guard let dayWeathers = self.myViewModel.getDailyWeathers(),
              let sunrise = dayWeathers[0].sun.sunrise,
              let sunset = dayWeathers[0].sun.sunset else { return false }

        print(sunrise)
        print(sunset)
        print(Date())
        
        let result = sunset.compare(Date())
            switch result {
            case .orderedAscending:
                // 테스트1
                print("현재 시각이 비교대상보다 느립니다.")
                break
            case .orderedDescending:
                // 테스트2
                print("현재 시각이 비교대상보다 이릅니다.")
                break
            case .orderedSame:
                // 테스트3
                print("Debug: 동일한 시간")
                break
            default:
                // 테스트4
                print("Debug: Test4")
                break
            }
            return true
        }
}

extension SunsetCell {
    
}
