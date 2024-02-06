//
//  AirQualityCell.swift
//  WeatherAnimals
//
//  Created by 김은상 on 1/22/24.
//

import UIKit
import WeatherKit

final class AirQualityCell: UICollectionViewCell {
    static let identifier = "AirQualityCell"
    //MARK: - Properties
    
    private lazy var baseView = UIView().then {
        $0.backgroundColor = UIColor(named: "background")
    }
    
    private lazy var airQualityValueLabel = UILabel().then {
        $0.text = "55"
        $0.font = UIFont.neoDeungeul(size: 60)
        $0.textColor = .black
    }

    private lazy var airQualityLabel = UILabel().then {
        $0.text = "보통"
        $0.font = UIFont.neoDeungeul(size: 25)
        $0.textColor = .black
    }
 
    var weather: CurrentWeather? {
        didSet {
            guard let weather = self.weather else { return }
            self.configureUIWithData(weather)
        }
    }
    
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    //MARK: - Helpers
    private func configureUI() {
        self.backgroundColor = .white
        self.addSubview(baseView)
        self.baseView.addSubviews(airQualityValueLabel, airQualityLabel)
        self.baseView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.bottom.equalToSuperview().inset(10)
        }
        
        self.airQualityValueLabel.snp.makeConstraints {
//            $0.top.equalToSuperview().offset(10)
            $0.centerX.centerY.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        self.airQualityLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(airQualityValueLabel.snp.bottom).offset(5)
        }
        
        
    }
    
    private func configureUIWithData(_ weather: CurrentWeather) {
        DispatchQueue.main.async {
//            self.airQualityValueLabel.text = weather.
        }
    }
    
}
