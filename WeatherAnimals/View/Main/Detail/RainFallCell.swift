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
    
    private lazy var airQualityValueLabel = UILabel().then {
        $0.text = "70mm"
        $0.font = UIFont.neoDeungeul(size: 50)
        $0.textColor = .black
    }
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    //MARK: - Helpers
    private func configureUI() {
        
        self.backgroundColor = .clear
        
        self.addSubview(baseView)
        
        self.baseView.addSubviews(airQualityValueLabel)
        
        self.baseView.snp.makeConstraints {
//            $0.top.equalToSuperview()
//            $0.leading.equalToSuperview().offset(10)
//            $0.trailing.bottom.equalToSuperview().inset(10)
            $0.edges.equalToSuperview()

        }
        
        self.airQualityValueLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview().offset(5)
            $0.height.equalTo(60)
        }
    }
}
