//
//  AirQuality.swift
//  WeatherAnimals
//
//  Created by 김은상 on 2/28/24.
//

import UIKit

struct AirQuality: Codable {
    let aqi: Int
//    let maxAQI: Int
//    let minAQI: Int
    
}

struct AirQualityResponse: Codable {
    let data: AirQuality
}
