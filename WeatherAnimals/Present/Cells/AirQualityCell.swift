//
//  AirQualityCell.swift
//  WeatherAnimals
//
//  Created by 김은상 on 1/22/24.
//

import UIKit

final class AirQualityCell: UICollectionViewCell {
    static let identifier = "AirQualityCell"
    //MARK: - Properties
    
    private lazy var baseView = UIView().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray4.cgColor
        $0.layer.cornerRadius = 16
        $0.backgroundColor = .clear
    }
    
    private lazy var airQualityValueLabel = UILabel().then {
        $0.text = "55"
        $0.font = UIFont.neoDeungeul(size: 40)
        $0.textColor = .black
    }

    private lazy var airQualityLabel = UILabel().then {
        $0.text = "보통"
        $0.font = UIFont.neoDeungeul(size: 25)
        $0.textColor = .black
    }
    
    private lazy var airQualityView = UIView().then {
        $0.backgroundColor = Constants.greenColor
    }
    
    private lazy var airQualityDescriptionLabel = UILabel().then {
        $0.font = UIFont.neoDeungeul(size: 16)
        $0.numberOfLines = 0
        $0.text = "현재의 대기질 지수는 55수준으로, 어제 이 시간과 비슷합니다."
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
        self.baseView.addSubviews(airQualityValueLabel, airQualityLabel, airQualityDescriptionLabel, airQualityView)
        self.baseView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(10)
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
        
        self.airQualityView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(1)
            $0.top.equalTo(airQualityLabel.snp.bottom).offset(15)
        }
        
        self.airQualityDescriptionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(airQualityView.snp.bottom).offset(15)
        }
        
        
    }
    
    
}
