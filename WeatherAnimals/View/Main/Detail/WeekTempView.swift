//
//  WeekTempView.swift
//  WeatherAnimals
//
//  Created by 김은상 on 2/14/24.
//

import UIKit

final class WeekTempView: UIView {
    //MARK: - Properties
    var sepCoeff: Double? 
    var lowTemp: Double?
    var highTemp: Double?
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    override func draw(_ rect: CGRect) {
        // 전체 영역을 파란색으로 채웁니다.
        UIColor(named: "black")?.setFill()
        UIRectFill(rect)
        
        
        guard let sepCoeff = self.sepCoeff else { return }
        // 왼쪽 2만큼을 검은색으로 채웁니다.
        let blackRect = CGRect(x: 0, y: 0, width: 2, height: rect.height)
        UIColor.black.setFill()
        UIRectFill(blackRect)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
}
