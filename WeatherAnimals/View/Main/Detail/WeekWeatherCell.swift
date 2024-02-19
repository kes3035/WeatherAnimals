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
        $0.font = UIFont.neoDeungeul(size: 16)
    }
    
    lazy var weatherImageView = UIImageView().then {
        $0.backgroundColor = .clear
        $0.tintColor = .black
        $0.contentMode = .scaleAspectFit
    }
    
    lazy var highTempLabel = UILabel().then {
        $0.text = "20"
        $0.textAlignment = .right
        $0.font = UIFont.neoDeungeul(size: 16)
    }
    
    lazy var lowTempLabel = UILabel().then {
        $0.text = "-20"
        $0.textAlignment = .right
        $0.font = UIFont.neoDeungeul(size: 16)
    }
    
    lazy var tempColorView = UIView().then {
        $0.backgroundColor = UIColor(named: "black")
    }
    
    lazy var tempView = UIView().then {
        $0.backgroundColor = Constants.greenColor
    }
    
    lazy var customSeparator = UIView().then {
        $0.backgroundColor = UIColor(named: "black")
    }
    
    var weatherViewModel: WeatherViewModel! 
    
    var dayWeather: DayWeather? {
        didSet {
            self.configureUIWithData()
        }
    }
    
    //MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.weatherViewModel = WeatherViewModel()
        self.configureUI()
        
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    //MARK: - Helpers
    private func configureUI() {
        
        self.contentView.backgroundColor = UIColor(named: "background")
        
        self.contentView.addSubviews(weekdaysTitleLabel, weatherImageView, highTempLabel, lowTempLabel, tempColorView, customSeparator)
        
        self.tempColorView.addSubview(self.tempView)
        

        weekdaysTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(30)
            $0.width.equalTo(40)
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
            $0.height.equalTo(2)
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(lowTempLabel.snp.trailing).offset(5)
            $0.trailing.equalTo(highTempLabel.snp.leading).offset(-5)
        }
        
        tempView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        customSeparator.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(2)
        }
            
    }
    
    private func configureUIWithData() {
        guard let dayWeather = self.dayWeather else { return }

        self.weatherViewModel.dayWeather = dayWeather
        
        
        self.weatherViewModel.getMaxMinTempOfWeek(dayWeather)

        
        
        let leading = self.weatherViewModel.getLeadingWidth()
        
        let width = self.weatherViewModel.getWidth()
      
        
        DispatchQueue.main.async {
            
            self.highTempLabel.text = String(round(dayWeather.highTemperature.value)) + String(UnicodeScalar(0x00B0))
            self.lowTempLabel.text = String(round(dayWeather.lowTemperature.value)) + String(UnicodeScalar(0x00B0))
            self.weatherImageView.image = UIImage(named: dayWeather.symbolName)
            
            //여기에 온도에 따른 막대기 길이를 통해 tempColorView 위에 새로운 view 올리기
//            self.tempColorView.addSubview(self.tempView)
            
            
            
            self.tempView.snp.remakeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.leading.equalToSuperview().offset(leading*86.333333)
                $0.width.equalTo(width*86.333333)
                
            }
        }
    }
}



