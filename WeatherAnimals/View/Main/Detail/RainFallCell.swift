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
        $0.backgroundColor = UIColor(named: "myBackground")
    }
    
    private lazy var rainFallLabel = UILabel().then {
        $0.text = "70mm"
        $0.font = UIFont.neoDeungeul(size: 50)
        $0.textColor = .black
    }
    
    lazy var myViewModel = MyViewModel() {
        didSet {
            self.configureRainFallCellUIWithData()
        }
    }
    
    var myWeather: MyWeather?

    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureRainFallCellUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    //MARK: - Helpers
    private func configureRainFallCellUIWithData() {
        guard let myWeather = self.myWeather else { return }
    
        let currentWeather = myWeather.currentWeather
        let precipitationIntensity = String(round(currentWeather.precipitationIntensity.value))
        
        DispatchQueue.main.async {
            self.rainFallLabel.text = precipitationIntensity
        }
        
    }
}

extension RainFallCell {
    private func configureRainFallCellUI() {
        
        self.backgroundColor = .clear
        
        self.addSubview(self.baseView)
        
        self.baseView.addSubviews(self.rainFallLabel)
        
        self.baseView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        self.rainFallLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview().offset(5)
            $0.height.equalTo(60)
        }
    }
}
