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
        $0.backgroundColor = UIColor(named: "background")
    }
    
    private lazy var airQualityValueLabel = UILabel().then {
        $0.text = "PM 6:23"
        $0.font = UIFont.neoDeungeul(size: 50)
        $0.textColor = .black
    }
    
    var weatherViewModel: WeatherViewModel! {
        didSet {
            self.configureUIWithData(self.weatherViewModel)
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
        
        self.baseView.addSubviews(airQualityValueLabel)
        
        self.baseView.snp.makeConstraints {
//            $0.top.equalToSuperview()
//            $0.leading.equalToSuperview().offset(10)
//            $0.trailing.bottom.equalToSuperview().inset(10)
            $0.edges.equalToSuperview()

        }
        
        self.airQualityValueLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.height.equalTo(40)
        }
    }
    
    private func configureUIWithData(_ weatherViewModel: WeatherViewModel) {
        guard let dayWeathers = weatherViewModel.dayWeathers else { return }
        let sunrise = dayWeathers[0].sun.sunrise
        let sunset = dayWeathers[0].sun.sunset
    }
}
