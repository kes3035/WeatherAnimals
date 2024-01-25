//
//  TableHeaderView.swift
//  WeatherAnimals
//
//  Created by 김은상 on 1/25/24.
//

import UIKit

final class TableHeaderView: UIView {
    private lazy var baseView = UIView().then {
        $0.backgroundColor = .darkGray
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "타이틀 텍스트"
        $0.font = .neoDeungeul(size: 20)
        $0.textColor = .black
        $0.textAlignment = .left
    }
    
    
    
    

}
