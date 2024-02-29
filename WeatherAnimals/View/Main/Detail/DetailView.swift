//
//  DetailView.swift
//  WeatherAnimals
//
//  Created by 김은상 on 1/22/24.
//

import UIKit

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
        self.configureUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    //MARK: - Helpers
    private func configureUI() {
        self.backgroundColor = .white
        self.addSubview(baseView)
        self.baseView.addSubviews(topStack)
        self.tempView.addSubview(tempLabel)
        self.labelStack.addArrangedSubviews(tempView, summaryLabel, highestTempLabel, lowestTempLabel)
        self.topStack.addArrangedSubviews(animalImage, labelStack)
        
        self.baseView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        animalImage.snp.makeConstraints { $0.height.width.equalTo(140) }
        
        tempView.snp.makeConstraints {
            $0.height.equalTo(50)
        }
      
        summaryLabel.snp.makeConstraints { $0.height.equalTo(20) }
        
        highestTempLabel.snp.makeConstraints { $0.height.equalTo(20) }
        
        topStack.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(290)
            $0.height.equalTo(140)
        }
        tempLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
//        celsiusLabel.snp.makeConstraints {
//            $0.top.equalTo(tempLabel.snp.top).offset(3)
//            $0.leading.equalTo(tempLabel.snp.trailing).inset(5)
//        }
    }
}
