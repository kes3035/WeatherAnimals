//
//  ItemsReusableView.swift
//  WeatherAnimals
//
//  Created by 김은상 on 1/24/24.
//

import UIKit

class ItemsReusableView: UICollectionReusableView {
    static let identifier = "ItemsReusableView"
    //MARK: - Properties
   
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    private func configureUI() {
        self.backgroundColor = .green
    }
    
    
    //MARK: - Actions
    
}
