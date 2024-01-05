//
//  DetailVC.swift
//  WeatherAnimals
//
//  Created by 김은상 on 1/4/24.
//

import UIKit

class DetailVC: UIViewController {
//MARK: - Properties
    private lazy var tempLabel = UILabel().then {
        $0.text = "24"
        $0.font = UIFont.neoDeungeul(size: 48)
        
    }
    
    private lazy var summaryLabel = UILabel().then {
        $0.text = "대체로 맑개"
        $0.font = UIFont.neoDeungeul(size: 20)

    }
    
    private lazy var highestTempLabel = UILabel().then {
        $0.text = "최고 : 123"
        $0.font = UIFont.neoDeungeul(size: 20)

    }
    
    private lazy var lowestTempLabel = UILabel().then {
        $0.text = "최저 : 123"
        $0.font = UIFont.neoDeungeul(size: 20)

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
    
    private lazy var currentDayTempView = UICollectionView().then {
        $0.delegate = self
        $0.dataSource = self
    }
    
    
//MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        settingNav()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.hidesBackButton = true
    }
//MARK: - Helpers
    private func configureUI() {
        self.view.backgroundColor = .white
        
        labelStack.addArrangedSubview(tempLabel)
        labelStack.addArrangedSubview(summaryLabel)
        labelStack.addArrangedSubview(highestTempLabel)
        labelStack.addArrangedSubview(lowestTempLabel)
        
        topStack.addArrangedSubview(animalImage)
        topStack.addArrangedSubview(labelStack)
        self.view.addSubview(topStack)
        
        topStack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(290)
            $0.height.equalTo(140)
        }
        
        
        
        
        
        
        
    }
    
    private func settingNav() {
//        self.navigationItem.backButtonTitle = "죽전동"
    }
//MARK: - Actions

}

extension DetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()
        return cell
    }
    
    
}
