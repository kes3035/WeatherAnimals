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
        $0.textColor = UIColor(named: "black")
    }
    
    var weatherViewModel: WeatherViewModel! {
        didSet {
            self.configureUIWithData()
        }
    }
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.weatherViewModel = WeatherViewModel()
        self.configureUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    //MARK: - Helpers
    private func configureUI() {
        
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
    
    private func configureUIWithData() {
        guard let currentWeather = self.weatherViewModel.currentWeather else { return }
        DispatchQueue.main.async {
            self.humidityLabel.text = String(round(currentWeather.humidity)) + "%"
        }
    }
    
}
