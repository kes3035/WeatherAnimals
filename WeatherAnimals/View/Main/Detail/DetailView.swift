//
//  DetailView.swift
//  WeatherAnimals
//
//  Created by 김은상 on 1/22/24.
//

import UIKit
import WeatherKit

final class DetailView: UIView {
    //MARK: - Properties
    private lazy var baseView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    lazy var tempLabel = UILabel().then {
        $0.text = "24"
        $0.font = UIFont.neoDeungeul(size: 48)
    }
    
    private lazy var celsiusLabel = UILabel().then {
        $0.text = String(UnicodeScalar(0x00B0))
        $0.font = UIFont.neoDeungeul(size: 50)
    }
    
    lazy var summaryLabel = UILabel().then {
        $0.text = "대체로 맑개"
        $0.font = UIFont.neoDeungeul(size: 20)
    }
    
    lazy var highestTempLabel = UILabel().then {
        $0.text = "최고 : 123"
        $0.font = UIFont.neoDeungeul(size: 20)
    }
    
    lazy var lowestTempLabel = UILabel().then {
        $0.text = "최저 : 123"
        $0.font = UIFont.neoDeungeul(size: 20)
    }
    
    private lazy var tempView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var labelStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
        $0.distribution = .fill
    }
    
    private lazy var animalImage = UIImageView().then {
        $0.backgroundColor = .systemBlue
    }
    
    private lazy var topStack = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 14
    }

    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureDetailViewUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}


extension DetailView {
    private func configureDetailViewUI() {
        self.backgroundColor = .white
        self.addSubview(self.baseView)
        self.baseView.addSubviews(self.topStack)
        self.tempView.addSubview(self.tempLabel)
        self.labelStack.addArrangedSubviews(self.tempView,
                                            self.summaryLabel,
                                            self.highestTempLabel,
                                            self.lowestTempLabel)
        self.topStack.addArrangedSubviews(self.animalImage, self.labelStack)
        
        self.baseView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.animalImage.snp.makeConstraints { $0.height.width.equalTo(140) }
        
        self.tempView.snp.makeConstraints { $0.height.equalTo(50) }
      
        self.summaryLabel.snp.makeConstraints { $0.height.equalTo(20) }
        
        self.highestTempLabel.snp.makeConstraints { $0.height.equalTo(20) }
        
        self.topStack.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(290)
            $0.height.equalTo(140)
        }
        
        self.tempLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
