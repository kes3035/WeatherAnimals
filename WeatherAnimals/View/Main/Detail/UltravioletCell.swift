//
//  UltravioletCell.swift
//  WeatherAnimals
//
//  Created by 김은상 on 1/24/24.
//

import UIKit
import WeatherKit
import Then
import SnapKit

final class UltravioletCell: UICollectionViewCell {
    static let identifier = "UltravioletCell"
    //MARK: - Properties
    
    private lazy var baseView = UIView().then {
        $0.backgroundColor = UIColor(named: "background")
    }
    
    private lazy var uvValueLabel = UILabel().then {
        $0.text = "55"
        $0.font = UIFont.neoDeungeul(size: 50)
        $0.textColor = UIColor(named: "black")
    }

    private lazy var uvDescriptionLabel = UILabel().then {
        $0.text = "보통"
        $0.font = UIFont.neoDeungeul(size: 25)
        $0.textColor = UIColor(named: "black")
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
        
        self.backgroundColor = .clear
        
        self.addSubview(baseView)
        
        self.baseView.addSubviews(uvValueLabel, uvDescriptionLabel)
        
        self.baseView.snp.makeConstraints {
//            $0.top.equalToSuperview()
//            $0.leading.equalToSuperview().offset(10)
//            $0.trailing.bottom.equalToSuperview().inset(10)
            $0.edges.equalToSuperview()
        }
        
        self.uvValueLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(self.baseView.snp.centerY).offset(-30)
            $0.height.equalTo(60)
        }
        
        self.uvDescriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(uvValueLabel.snp.bottom).offset(5)
        }
    }
    
    private func configureUIWithData(_ weather: CurrentWeather) {
        DispatchQueue.main.async {
            self.uvValueLabel.text = String(weather.uvIndex.value)
            self.uvDescriptionLabel.text = weather.uvIndex.category.rawValue
            
        }
    }
}
