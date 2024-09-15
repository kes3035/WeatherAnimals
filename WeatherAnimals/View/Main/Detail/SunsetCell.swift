//
//  SunsetCell.swift
//  WeatherAnimals
//
//  Created by 김은상 on 1/24/24.
//

import UIKit

final class SunsetCell: UICollectionViewCell {
    static let identifier = "SunsetCell"
    //MARK: - Properties
    
    private lazy var baseView = UIView().then {
        $0.backgroundColor = UIColor(named: "myBackground")
    }
    
    private lazy var sunsetLabel = UILabel().then {
        $0.text = "PM 6:23"
        $0.font = UIFont.neoDeungeul(size: 50)
        $0.textColor = .black
    }
    
    lazy var myViewModel = MyViewModel() {
        didSet {
            self.configureSunsetCellUIWithData()
        }
    }
    
    var myWeather: MyWeather?

    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureSunsetCellUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    //MARK: - Helpers
    private func configureSunsetCellUIWithData() {
        guard let weathers = self.myViewModel.getWeathers(),
              let selectedIndex = self.myViewModel.getSelectedIndex() else { return }
        
        let weather = weathers[selectedIndex]
        
        let dailyWeather = weather.dailyWeathers
        
        guard let sunrise = dailyWeather[0].sun.sunrise,
              let sunset = dailyWeather[0].sun.sunset else { return }
      
        
        let sunsetLabelText = self.compareTime(sunrise: sunrise, sunset: sunset)

        DispatchQueue.main.async {
            self.sunsetLabel.text = sunsetLabelText
            
        }
    }
    
    private func compareTime(sunrise: Date, sunset: Date) -> String {
        guard let selectedLocation = self.myViewModel.getSelectedLocation(),
              let timeZone = self.myViewModel.getTimeZone() else { return "" }
        
        var calendar = Calendar.current
        calendar.timeZone = timeZone
        
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = calendar
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = "a h:mm"
        
        let sunriseStr = dateFormatter.string(from: sunrise)
        let sunsetStr = dateFormatter.string(from: sunset)
        let currentDateStr = dateFormatter.string(from: Date())
        
        if currentDateStr < sunriseStr {
            return sunriseStr
        } else if currentDateStr >= sunriseStr && currentDateStr < sunsetStr {
            return sunsetStr
        } else {
            return sunsetStr
        }
    }
}

extension SunsetCell {
    private func configureSunsetCellUI() {
        
        self.backgroundColor = .white
        
        self.addSubview(baseView)
        
        self.baseView.addSubviews(sunsetLabel)
        
        self.baseView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.sunsetLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.height.equalTo(40)
        }
    }
}
