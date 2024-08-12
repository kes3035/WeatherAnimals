//
//  LaunchVC.swift
//  WeatherAnimals
//
//  Created by 김은상 on 3/4/24.
//

import UIKit
import CoreLocation
import CoreData

final class LaunchVC: UIViewController {
    //MARK: - Properties
    private lazy var titleLabel = UILabel().then {
        $0.text = "날씨보개"
        $0.font = UIFont.neoDeungeul(size: 48)
        $0.textColor = .white
        $0.textAlignment = .center
    }
    
    private let loadingLabel = UILabel().then {
        $0.text = ""
        $0.font = UIFont.neoDeungeul(size: 24)
        $0.textColor = UIColor.white
    }
    
    lazy var locationViewModel = LocationViewModel()
    
    lazy var myViewModel = MyViewModel()
        
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.animateLoadingLabel()
    }
}

extension LaunchVC {
    private func configureUI() {
        self.view.backgroundColor = Constants.greenColor
        self.view.addSubviews(self.titleLabel, self.loadingLabel)
        
        self.titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(150)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        self.loadingLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.view.snp.centerY).offset(30)
        }
    }
    
    private func animateLoadingLabel() {
        var charIndex = 0.0
        let titleText = "Loading..."
        loadingLabel.text = ""

        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.2 * charIndex, repeats: false) { timer in
                DispatchQueue.main.async {
                    self.loadingLabel.text?.append(letter)
                }
            }
            charIndex += 1
        }
    }
}
