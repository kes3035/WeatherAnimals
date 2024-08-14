//
//  HumidityCell.swift
//  WeatherAnimals
//
//  Created by 김은상 on 2/6/24.
//

import UIKit
import SnapKit
import Then

final class HumidityCell: UICollectionViewCell {
    static let identifier = "HumidityCell"
    //MARK: - Properties
    private lazy var baseView = UIView()
    
    private lazy var humidityLabel = UILabel().then {
        $0.font = UIFont.neoDeungeul(size: 50)
        $0.text = "23%"
        $0.textColor = UIColor(named: "myBlack")
    }
    
    lazy var myViewModel = MyViewModel() {
        didSet {
            self.configureHumidityCellUIWithData()
        }
    }
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureHumidityCellUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    //MARK: - Helpers
    private func configureHumidityCellUIWithData() {
        guard let weathers = self.myViewModel.getWeathers(),
              let selectedIndex = self.myViewModel.getSelectedIndex() else { return }
        
        let weather = weathers[selectedIndex]
        
        let currentWeather = weather.currentWeather
        let humidity = String(round(currentWeather.humidity))
        
        DispatchQueue.main.async {
            self.humidityLabel.text = humidity + "%"
        }
    }
}

extension HumidityCell {
    private func configureHumidityCellUI() {
        
        self.backgroundColor = .clear
        
        self.baseView.backgroundColor = UIColor(named: "background")
        
        self.baseView.addSubview(self.humidityLabel)
        
        self.addSubview(self.baseView)
        
        self.baseView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.humidityLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.height.equalTo(60)
        }
    }
}
