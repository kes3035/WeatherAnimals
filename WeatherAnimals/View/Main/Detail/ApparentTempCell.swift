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
        $0.backgroundColor = UIColor(named: "myBackground")
    }
    
    private lazy var apparentTempLabel = UILabel().then {
        $0.text = "-13도"
        $0.font = UIFont.neoDeungeul(size: 50)
        $0.textColor = .black
    }
    
    var myWeather: MyWeather? {
        didSet {
            self.configureUIWithData()
        }
    }

    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureApparentTempCellUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    //MARK: - Helpers
    private func configureUIWithData() {
        guard let myWeather = self.myWeather else { return }
        let currentWeather =  myWeather.currentWeather
        let apparentTemp = String(round(currentWeather.apparentTemperature.value))
        let apparentTempSymbol = currentWeather.apparentTemperature.unit.symbol
        
        DispatchQueue.main.async {
            self.apparentTempLabel.text = apparentTemp + apparentTempSymbol
        }
    }
}

extension ApparentTempCell {
    private func configureApparentTempCellUI() {
        
        self.backgroundColor = .white
        
        self.addSubview(baseView)
        
        self.baseView.addSubviews(self.apparentTempLabel)
        
        self.baseView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.apparentTempLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.height.equalTo(40)
        }
    }
}
