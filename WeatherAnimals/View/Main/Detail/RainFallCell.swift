//
//  RainFallCell.swift
//  WeatherAnimals
//
//  Created by 김은상 on 1/24/24.
//

import UIKit

class RainFallCell: UICollectionViewCell {
    static let identifier = "RainFallCell"
    //MARK: - Properties
    
    private lazy var baseView = UIView().then {
        $0.backgroundColor = UIColor(named: "background")
    }
    
    private lazy var airQualityValueLabel = UILabel().then {
        $0.text = "0mm"
        $0.font = UIFont.neoDeungeul(size: 40)
        $0.textColor = .black
    }

    private lazy var airQualityLabel = UILabel().then {
        $0.text = "지난 24시간"
        $0.font = UIFont.neoDeungeul(size: 25)
        $0.textColor = .black
    }
    
   
    private lazy var airQualityDescriptionLabel = UILabel().then {
        $0.font = UIFont.neoDeungeul(size: 16)
        $0.numberOfLines = 0
        $0.text = "이후 2월 2일에 19mm의 비가 예상됩니다."
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
            $0.top.equalTo(airQualityLabel.snp.bottom).offset(15)
        }
        
        
    }
}
