//
//  HumidityCell.swift
//  WeatherAnimals
//
//  Created by 김은상 on 2/6/24.
//

import UIKit

final class HumidityCell: UICollectionViewCell {
    static let identifier = "HumidityCell"
    //MARK: - Properties
    private lazy var baseView = UIView()
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    //MARK: - Helpers
    
    private func configureUI() {
        self.backgroundColor = .clear
        self.baseView.backgroundColor = UIColor(named: "background")
        
    }
    
}
