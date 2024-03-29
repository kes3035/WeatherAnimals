//
//  ApparentTempCell.swift
//  WeatherAnimals
//
//  Created by 김은상 on 1/24/24.
//

import UIKit

final class ApparentTempCell: UICollectionViewCell {
    static let identifier = "ApparentTempCell"
    //MARK: - Properties
    
    private lazy var baseView = UIView().then {
        $0.backgroundColor = UIColor(named: "background")
    }
    
    private lazy var apparentTempLabel = UILabel().then {
        $0.text = "-13도"
        $0.font = UIFont.neoDeungeul(size: 50)
        $0.textColor = .black
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
        
        self.backgroundColor = .white
        
        self.addSubview(baseView)
        
        self.baseView.addSubviews(apparentTempLabel)
        
        self.baseView.snp.makeConstraints {
//            $0.top.equalToSuperview()
//            $0.leading.equalToSuperview().offset(10)
//            $0.trailing.bottom.equalToSuperview().inset(10)
            $0.edges.equalToSuperview()

        }
        
        self.apparentTempLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.height.equalTo(40)
        }
    }
    
    private func configureUIWithData() {
        guard let currentWeather = self.weatherViewModel.currentWeather else { return }

        DispatchQueue.main.async {
            self.apparentTempLabel.text = String(round(currentWeather.apparentTemperature.value)) + currentWeather.apparentTemperature.unit.symbol

            
        }
    }
}

