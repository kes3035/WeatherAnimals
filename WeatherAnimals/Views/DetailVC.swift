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
    
    private let flowLayout = UICollectionViewFlowLayout()
    
    private lazy var currentDayTempView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .green
        $0.layer.cornerRadius = 18
        $0.clipsToBounds = true
        $0.showsHorizontalScrollIndicator = false
        $0.register(CurrentWeatherCell.self, forCellWithReuseIdentifier: "CurrentWeatherCell")
    }
    
    
//MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        settingCVFlowLayout()
        settingNav()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.hidesBackButton = true
    }
//MARK: - Helpers
    private func configureUI() {
        self.view.backgroundColor = .white
        
        //Label끼리의 스택뷰에 뷰들 올리기
        self.labelStack.addArrangedSubviews(tempLabel, summaryLabel, highestTempLabel, lowestTempLabel)
        self.topStack.addArrangedSubviews(animalImage, labelStack)
        self.view.addSubViews(topStack, currentDayTempView)
        
        animalImage.snp.makeConstraints {
            $0.height.width.equalTo(140)
        }
        
        tempLabel.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        
        summaryLabel.snp.makeConstraints {
            $0.height.equalTo(20)
        }
        
        highestTempLabel.snp.makeConstraints {
            $0.height.equalTo(20)
        }
        
        topStack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(290)
            $0.height.equalTo(140)
        }
        
        currentDayTempView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().inset(15)
            $0.top.equalTo(topStack.snp.bottom).offset(20)
            $0.height.equalTo(100)
        }
        
    }
    
    private func settingNav() {
//        self.navigationItem.backButtonTitle = "죽전동"
    }
    
    private func settingCVFlowLayout() {
        flowLayout.scrollDirection = .horizontal
    }
//MARK: - Actions

}

extension DetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CurrentWeatherCell", for: indexPath) as! CurrentWeatherCell
        
        return cell
    }
}

extension DetailVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 100)
    }
}
