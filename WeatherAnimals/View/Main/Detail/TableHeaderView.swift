//
//  TableHeaderView.swift
//  WeatherAnimals
//
//  Created by 김은상 on 1/25/24.
//

import UIKit

final class TableHeaderView: UIView {
    //MARK: - Properties
    
    private lazy var baseView = UIView().then { $0.backgroundColor  = .clear }

    lazy var titleLabel = UILabel().then {
        $0.text = "타이틀 텍스트"
        $0.font = .neoDeungeul(size: 25)
        $0.textColor = .black
        $0.textAlignment = .left
    }
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    //MARK: - Helpers
    private func configureUI() {
        
        self.addSubview(baseView)
        self.baseView.addSubview(titleLabel)

        
        self.baseView.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.leading.top.trailing.equalToSuperview()
        }
        
        self.titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.bottom.trailing.equalToSuperview()
        }
    }
    

}
