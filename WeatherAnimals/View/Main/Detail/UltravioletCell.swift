//
//  UltravioletCell.swift
//  WeatherAnimals
//
//  Created by 김은상 on 1/24/24.
//

import UIKit
import WeatherKit

final class UltravioletCell: UICollectionViewCell {
    static let identifier = "UltravioletCell"
    //MARK: - Properties
    
    private lazy var baseView = UIView().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray4.cgColor
        $0.layer.cornerRadius = 16
        $0.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        $0.backgroundColor = .clear
    }
    
    private lazy var uvValueLabel = UILabel().then {
        $0.text = "55"
        $0.font = UIFont.neoDeungeul(size: 40)
        $0.textColor = .black
    }

    private lazy var uvLabel = UILabel().then {
        $0.text = "보통"
        $0.font = UIFont.neoDeungeul(size: 25)
        $0.textColor = .black
    }
    
    private lazy var uvView = UIView().then {
        $0.backgroundColor = Constants.greenColor
    }
    
    private lazy var uvDescriptionLabel = UILabel().then {
        $0.font = UIFont.neoDeungeul(size: 16)
        $0.numberOfLines = 0
        $0.text = "남은 하루 동안 자외선 지수가 낮겠습니다."
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
        self.baseView.addSubviews(uvValueLabel, uvLabel, uvDescriptionLabel, uvView)
        self.baseView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.bottom.equalToSuperview().inset(10)
        }
        
        self.uvValueLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.leading.equalToSuperview().offset(10)
            $0.height.equalTo(40)
        }
        
        self.uvLabel.snp.makeConstraints {
            $0.leading.equalTo(uvValueLabel.snp.leading)
            $0.top.equalTo(uvValueLabel.snp.bottom).offset(5)
        }
        
        self.uvView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(1)
            $0.top.equalTo(uvLabel.snp.bottom).offset(15)
        }
        
        self.uvDescriptionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(uvView.snp.bottom).offset(15)
        }
        
        
    }
    
    private func configureUIWithData(_ weather: CurrentWeather) {
        DispatchQueue.main.async {
            self.uvValueLabel.text = String(weather.uvIndex.value)
            self.uvLabel.text = weather.uvIndex.category.rawValue
            
        }
    }
}
