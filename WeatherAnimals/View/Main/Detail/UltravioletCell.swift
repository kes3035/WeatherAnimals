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
        $0.backgroundColor = UIColor(named: "myBackground")
    }
    
    private lazy var uvValueLabel = UILabel().then {
        $0.text = "55"
        $0.font = UIFont.neoDeungeul(size: 50)
        $0.textColor = UIColor(named: "myBlack")
    }

    private lazy var uvDescriptionLabel = UILabel().then {
        $0.text = "보통"
        $0.font = UIFont.neoDeungeul(size: 25)
        $0.textColor = UIColor(named: "myBlack")
    }

    
    lazy var myViewModel = MyViewModel() {
        didSet {
            configureUltravioletCellUIWithData()
        }
    }
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUltravioletCellUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    //MARK: - Helpers
    private func convertUVIndex(category: UVIndex.ExposureCategory) -> (String, UIColor) {
        switch category {
        case .extreme:
            return ("심각함", UIColor.purple)
        case .high:
            return ("높음", UIColor.systemOrange)
        case .low:
            return ("낮음", Constants.greenColor)
        case .moderate:
            return ("보통", UIColor(named: "myBlack") ?? UIColor.black)
        case .veryHigh:
            return ("매우 높음", UIColor.systemRed)
        }
    }

    private func configureUltravioletCellUIWithData() {
        guard let weathers = self.myViewModel.getWeathers(),
        let selectedIndex = self.myViewModel.getSelectedIndex() else { return }
        
        let weather = weathers[selectedIndex]
        let currentWeather = weather.currentWeather
        
        let uvCategory = currentWeather.uvIndex.category
        
        let uvIndex = currentWeather.uvIndex.value
        
        let (category, color) = self.convertUVIndex(category: uvCategory)
        
        DispatchQueue.main.async {
            self.uvValueLabel.text = String(uvIndex)
            self.uvValueLabel.textColor = color
            
            self.uvDescriptionLabel.text = category
            self.uvDescriptionLabel.textColor = color
            
        }
    }
}

extension UltravioletCell {
    private func configureUltravioletCellUI() {
        
        self.backgroundColor = .clear
        
        self.addSubview(baseView)
        
        self.baseView.addSubviews(self.uvValueLabel, self.uvDescriptionLabel)
        
        self.baseView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.uvValueLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(self.baseView.snp.centerY).offset(-30)
            $0.height.equalTo(60)
        }
        
        self.uvDescriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.uvValueLabel.snp.bottom).offset(5)
        }
    }
}
