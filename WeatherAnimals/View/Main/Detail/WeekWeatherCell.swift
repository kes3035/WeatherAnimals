//
//  TenDaysWeatherCell.swift
//  WeatherAnimals
//
//  Created by 김은상 on 1/6/24.
//

import UIKit
import WeatherKit


final class WeekWeatherCell: UITableViewCell {
    static let identifier = "WeekWeatherCell"
//MARK: - Properties
    lazy var weekdaysTitleLabel = UILabel().then {
        $0.text = "로딩중"
        $0.textAlignment = .center
        $0.font = UIFont.neoDeungeul(size: 14)
    }
    
    lazy var weatherImageView = UIImageView().then {
        $0.backgroundColor = .white
        $0.tintColor = .black
        $0.contentMode = .scaleAspectFit
    }
   
    
    lazy var highTempLabel = UILabel().then {
        $0.text = "20"
        $0.textAlignment = .center
        $0.font = UIFont.neoDeungeul(size: 14)
    }
    
    lazy var lowTempLabel = UILabel().then {
        $0.text = "-20"
        $0.textAlignment = .center
        $0.font = UIFont.neoDeungeul(size: 14)
    }
    
    lazy var tempColorView = UIView().then {
        $0.backgroundColor = Constants.greenColor
    }
    

//MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
//MARK: - Helpers
    private func configureUI() {
        self.contentView.addSubviews(weekdaysTitleLabel, weatherImageView, highTempLabel, lowTempLabel, tempColorView)
        
        weekdaysTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(30)
            $0.width.equalTo(30)
        }
        
        weatherImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(weekdaysTitleLabel.snp.trailing).offset(10)
            $0.height.width.equalTo(30)
        }
        
        lowTempLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(contentView.snp.centerX)
            $0.width.height.equalTo(40)
        }
        
        highTempLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(contentView.snp.trailing).inset(10)
            $0.width.height.equalTo(40)
        }
        
        tempColorView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(lowTempLabel.snp.trailing).offset(5)
            $0.trailing.equalTo(highTempLabel.snp.leading).offset(-5)
        }
    }
}



