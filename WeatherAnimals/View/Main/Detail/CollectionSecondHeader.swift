//
//  CollectionSecondHeader.swift
//  WeatherAnimals
//
//  Created by 김은상 on 2/5/24.
//

import UIKit

class CollectionSecondHeader: UICollectionReusableView {
    static let identifier = "CollectionSecondHeader"
    //MARK: - Properties
   
    private lazy var leftBaseView = UIView().then {
        $0.backgroundColor = UIColor(named: "background")
    }
    
    private lazy var rightBaseView = UIView().then {
        $0.backgroundColor = UIColor(named: "background")
    }
    
    private lazy var leftTitleLabel = UILabel().then {
        $0.font = UIFont.neoDeungeul(size: 14)
        $0.textColor = .black
        $0.text = "테스트"
    }
    
    private lazy var leftTitleImageView = UIImageView().then {
        $0.backgroundColor = .clear
        $0.tintColor = .black
        $0.contentMode = .scaleAspectFill
    }
    
    private lazy var rightTitleLabel = UILabel().then {
        $0.font = UIFont.neoDeungeul(size: 14)
        $0.textColor = .black
        $0.text = "테스트"
    }
    
    private lazy var rightTitleImageView = UIImageView().then {
        $0.backgroundColor = .clear
        $0.tintColor = .black
        $0.contentMode = .scaleAspectFill
    }
    
    var section: Int? {
        didSet {
            guard let section = section else { return }
            self.configureTitle(section)
        }
    }
    
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
        
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.leftBaseView.layer.addBottomBorder(color: UIColor(named: "black") ?? .black, width: 2, spacing: 15)
        self.rightBaseView.layer.addBottomBorder(color: UIColor(named: "black") ?? .black, width: 2, spacing: 15)
    }
    
    //MARK: - Helpers
    private func configureUI() {
        self.backgroundColor = .white
        self.rightBaseView.addSubviews(rightTitleLabel, rightTitleImageView)
        self.leftBaseView.addSubviews(leftTitleLabel, leftTitleImageView)
        self.addSubviews(leftBaseView, rightBaseView)
        
        self.leftBaseView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalTo(self.snp.centerX).offset(-15)
            $0.top.bottom.equalToSuperview()
        }
        
        self.leftTitleImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.width.height.equalTo(15)
        }
        
        self.leftTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(leftTitleImageView.snp.trailing).offset(10)
        }
        
        self.rightBaseView.snp.makeConstraints {
            $0.leading.equalTo(self.snp.centerX).offset(15)
            $0.trailing.equalToSuperview().inset(10)
            $0.top.bottom.equalToSuperview()
        }
        
        self.rightTitleImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.width.height.equalTo(15)
        }
        
        self.rightTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(self.rightTitleImageView.snp.trailing).offset(10)
        }
    }
    
    private func configureTitle(_ section: Int) {
        switch section {
        case 3:
            DispatchQueue.main.async {
                self.leftTitleLabel.text = "자외선 지수"
                self.leftTitleImageView.image = UIImage(systemName: "sun.max")
                self.rightTitleLabel.text = "일출"
                self.rightTitleImageView.image = UIImage(systemName: "sunrise")
            }
        case 4:
            DispatchQueue.main.async {
                self.leftTitleLabel.text = "체감온도"
                self.leftTitleImageView.image = UIImage(systemName: "thermometer")
                self.rightTitleLabel.text = "강수량"
                self.rightTitleImageView.image = UIImage(systemName: "drop.fill")
            }
        default:
            return
        }
        
    }
    
    //MARK: - Actions
    
}

