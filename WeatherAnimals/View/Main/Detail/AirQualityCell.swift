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
 
    
    lazy var myViewModel = MyViewModel() {
        didSet {
            self.configureAirQualityCellUIWithData()
            
        }
    }
    
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureAirQualityCellUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    //MARK: - Helpers
    private func configureAirQualityCellUIWithData() {
        guard let selectedLocation = self.myViewModel.getSelectedLocation() else { return }
        
        self.myViewModel.setAirQualityCondition(location: selectedLocation)
        
        guard let aqi = self.myViewModel.getAirQualityCondition() else { return }
        
        let (text, color) = self.convertAQIIndex(value: aqi.aqi)
        DispatchQueue.main.async {
            self.airQualityValueLabel.text = String(aqi.aqi)
            self.airQualityLabel.text = text
            self.airQualityLabel.textColor = color
            self.airQualityValueLabel.textColor = color
        }
    }
    
    private func convertAQIIndex(value: Int) -> (String, UIColor) {
        switch value {
        case 0...50:
            return ("좋음", Constants.greenColor)
        case 51...100:
            return ("보통", UIColor.yellow)
        case 101...150:
            return ("민감군영향", UIColor.orange)
        case 151...200:
            return ("나쁨", UIColor.systemRed)
        case 201...300:
            return ("매우 나쁨", UIColor.purple)
        case 301...:
            return ("위험", UIColor.darkGray)
        default:
            return ("로딩중", UIColor(named: "black") ?? UIColor.black)
        }
    }
}

extension AirQualityCell {
    private func configureAirQualityCellUI() {
        
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
}
