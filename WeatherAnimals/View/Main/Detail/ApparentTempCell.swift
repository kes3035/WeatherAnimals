//
//  ApparentTempCell.swift
//  WeatherAnimals
//
//  Created by 김은상 on 1/24/24.
//

import UIKit

class ApparentTempCell: UICollectionViewCell {
    static let identifier = "ApparentTempCell"
    //MARK: - Properties
    
    private lazy var baseView = UIView().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray4.cgColor
        $0.layer.cornerRadius = 16
        $0.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        $0.backgroundColor = .clear
    }
    
    private lazy var airQualityValueLabel = UILabel().then {
        $0.text = "-13"
        $0.font = UIFont.neoDeungeul(size: 40)
        $0.textColor = .black
    }

    private lazy var airQualityLabel = UILabel().then {
        $0.text = "보통"
        $0.font = UIFont.neoDeungeul(size: 25)
        $0.textColor = .black
    }
   
    
    private lazy var airQualityDescriptionLabel = UILabel().then {
        $0.font = UIFont.neoDeungeul(size: 16)
        $0.numberOfLines = 0
        $0.text = "바람으로 인해 체감 온도가 실제 온도보다 더 낮게 느껴집니다."
    }
    
    var weatherViewModel: WeatherViewModel! {
        didSet {
            self.configureUIWithData(self.weatherViewModel)
        }
    }
    
    
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.weatherViewModel = WeatherViewModel()
        self.configureUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    //MARK: - Helpers
    private func configureUI() {
        self.backgroundColor = .white
        self.addSubview(baseView)
        self.baseView.addSubviews(airQualityValueLabel, airQualityLabel, airQualityDescriptionLabel)
        self.baseView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.bottom.equalToSuperview().inset(10)
        }
        
        self.airQualityValueLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.leading.equalToSuperview().offset(10)
            $0.height.equalTo(40)
        }
        
        self.airQualityLabel.snp.makeConstraints {
            $0.leading.equalTo(airQualityValueLabel.snp.leading)
            $0.top.equalTo(airQualityValueLabel.snp.bottom).offset(5)
        }
        
        self.airQualityDescriptionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(airQualityValueLabel.snp.bottom).offset(40)
        }
    }
    
    private func configureUIWithData(_ weatherViewModel: WeatherViewModel) {
        DispatchQueue.main.async {
            guard let currentWeather = weatherViewModel.currentWeather else { return }
            self.airQualityValueLabel.text = String(round(currentWeather.apparentTemperature.value)) + currentWeather.apparentTemperature.unit.symbol
//            self.airQualityDescriptionLabel.text = currentWeather.apparentTemperature.description
//            self.airQualityValueLabel.text = String(round(currentWeather.apparentTemperature.value))
        }
    }
}

