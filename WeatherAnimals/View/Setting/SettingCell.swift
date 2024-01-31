//
//  SettingCell.swift
//  WeatherAnimals
//
//  Created by 김은상 on 1/16/24.
//

import UIKit

final class SettingCell: UITableViewCell {
    //MARK: - Properties
    
    private lazy var baseView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
        
    }
    
    lazy var titleLabel = UILabel().then {
        $0.text = "타이틀"
        $0.font = .neoDeungeul(size: 16)
        $0.textColor = .black
    }
    
    
    
    //MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.configureUI()
        
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    
    //MARK: - Helpers
    
    private func configureUI() {
        self.backgroundColor = .systemGray5.withAlphaComponent(0.8)
        self.contentView.backgroundColor = .systemGray5.withAlphaComponent(0.8)
        self.baseView.addSubviews(titleLabel)
        self.contentView.addSubview(baseView)
        
        self.contentView.snp.makeConstraints {
            $0.leading.top.equalToSuperview().offset(10)
            $0.bottom.trailing.equalToSuperview().inset(10)

        }
        
        self.baseView.snp.makeConstraints {
//            $0.top.leading.equalToSuperview().offset(10)
//            $0.bottom.trailing.equalToSuperview().inset(10)
            $0.edges.equalToSuperview()
        }
        
        self.titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
        }
        
        
        
    }
}
