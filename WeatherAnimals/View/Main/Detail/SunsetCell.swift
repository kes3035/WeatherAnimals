//
//  SunsetCell.swift
//  WeatherAnimals
//
//  Created by 김은상 on 1/24/24.
//

import UIKit

final class SunsetCell: UICollectionViewCell {
    static let identifier = "SunsetCell"
    //MARK: - Properties
    
    private lazy var baseView = UIView().then {
        $0.backgroundColor = UIColor(named: "background")
    }
    
    private lazy var sunsetLabel = UILabel().then {
        $0.text = "PM 6:23"
        $0.font = UIFont.neoDeungeul(size: 50)
        $0.textColor = .black
    }
    
    var weatherViewModel: WeatherViewModel! {
        didSet {
            self.configureUIWithData()
        }
    }
    
    lazy var myViewModel = MyViewModel() {
        didSet {
            self.configureUIWithData()
        }
    }
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureSunsetCellUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    //MARK: - Helpers
    private func configureSunsetCellUI() {
        
        self.backgroundColor = .white
        
        self.addSubview(baseView)
        
        self.baseView.addSubviews(sunsetLabel)
        
        self.baseView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.sunsetLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.height.equalTo(40)
        }
    }
    
    // Issue : 일몰시간 일출시간 현재 시각에 따라 조정하는 기능 만들기
    private func configureUIWithData() {
        guard let dayWeathers = self.weatherViewModel.dayWeathers else { return }
        let sunrise = dayWeathers[0].sun.sunrise
        let sunset = dayWeathers[0].sun.sunset
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a h:mm"
        
        let sunrisee = dateFormatter.string(from: dayWeathers[0].sun.sunrise ?? Date())
        
//        let sunsete = dateFormatter.string(from: dayWeathers[0].sun.sunset ?? Date())
        
        DispatchQueue.main.async {
            self.sunsetLabel.text = sunrisee
        }
    }
}
