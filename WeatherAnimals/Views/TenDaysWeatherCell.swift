//
//  TenDaysWeatherCell.swift
//  WeatherAnimals
//
//  Created by 김은상 on 1/6/24.
//

import UIKit

final class TenDaysWeatherCell: UITableViewCell {
//MARK: - Properties
    private lazy var weekdaysTitleLabel = UILabel().then {
        $0.text = "오늘"
    }
    
    private lazy var weatherImageView = UIImageView().then {
        $0.backgroundColor = .gray
    }
    
    private lazy var tempLabel = UILabel().then {
        $0.text = "20도"
    }
    
//MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
//MARK: - Helpers
    private func configureUI() {
        self.contentView.addSubViews(weekdaysTitleLabel, weatherImageView, tempLabel)
        
        weekdaysTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(5)
            $0.width.equalTo(50)
        }
        
        weatherImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(weekdaysTitleLabel.snp.trailing).offset(10)
            $0.height.width.equalTo(30)
        }
        
        tempLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(10)
        }
        
        
    }
    
//MARK: - Actions
    
}


//MARK: - 
