//
//  AirQualityCell.swift
//  WeatherAnimals
//
//  Created by 김은상 on 1/22/24.
//

import UIKit
import WeatherKit
import SnapKit
import Then

final class AirQualityCell: UICollectionViewCell {
    static let identifier = "AirQualityCell"
    //MARK: - Properties
    
    private lazy var baseView = UIView().then {
        $0.backgroundColor = UIColor(named: "background")
    }
    
    private lazy var airQualityValueLabel = UILabel().then {
        $0.text = "55"
        $0.font = UIFont.neoDeungeul(size: 50)
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
        }
    }
    
    var weatherViewModel: WeatherViewModel! {
        didSet {
            self.configureUIWithData()
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
        
        self.backgroundColor = .clear
        
        self.addSubview(baseView)
        
        self.baseView.addSubviews(airQualityValueLabel, airQualityLabel)
        
        self.baseView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.airQualityValueLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(self.baseView.snp.centerY).offset(-30)
            $0.height.equalTo(60)
        }
        
        self.airQualityLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(airQualityValueLabel.snp.bottom).offset(5)
        }
    }
    
    private func configureUIWithData() {
        DispatchQueue.main.async {
            guard let currentWeather = self.weatherViewModel.currentWeather else { return }
            

        }
    }
    
}
