//
//  LaunchVC.swift
//  WeatherAnimals
//
//  Created by 김은상 on 3/4/24.
//

import UIKit

final class LaunchVC: UIViewController {
    //MARK: - Properties
    private lazy var titleLabel = UILabel().then {
        $0.text = "날씨보개"
        $0.font = UIFont.neoDeungeul(size: 48)
        $0.textColor = .white
        $0.textAlignment = .center
    }
    
    private let loadingLabel = UILabel().then {
        $0.text = "Loading..."
        $0.font = UIFont.neoDeungeul(size: 24)
        $0.textColor = UIColor.white
    }
    
    private lazy var loadingBar = UIView().then {
        $0.backgroundColor = .white
    }
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        // Do any additional setup after loading the view.
    }
    //MARK: - Helpers
    private func configureUI() {
        self.view.backgroundColor = Constants.greenColor
        self.view.addSubviews(titleLabel, loadingBar, loadingLabel)
        
        self.titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(150)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        self.loadingBar.snp.makeConstraints {
            $0.top.equalTo(self.view.snp.centerY).offset(30)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(self.view.frame.size.width*3/4)
            $0.height.equalTo(12)
        }
        
        self.loadingLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(self.loadingBar.snp.top).offset(-10)
        }
    }
}
