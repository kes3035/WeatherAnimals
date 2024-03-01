//
//  RainFallCell.swift
//  WeatherAnimals
//
//  Created by 김은상 on 1/24/24.
//

import UIKit

final class RainFallCell: UICollectionViewCell {
    static let identifier = "RainFallCell"
    //MARK: - Properties
    private lazy var baseView = UIView().then {
        $0.backgroundColor = UIColor(named: "background")
    }
    
    private lazy var rainFallLabel = UILabel().then {
        $0.text = "70mm"
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
        
        self.backgroundColor = .clear
        
        self.addSubview(baseView)
        
        self.baseView.addSubviews(rainFallLabel)
        
        self.baseView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        self.rainFallLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview().offset(5)
            $0.height.equalTo(60)
        }
    }

    private func configureUIWithData() {
        
        guard let currentWeather = self.weatherViewModel.currentWeather else { return }
        
        DispatchQueue.main.async {
            
            self.rainFallLabel.text = String(currentWeather.precipitationIntensity.value)
            
            
            
        }
        
    }
}
