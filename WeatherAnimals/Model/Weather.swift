//
//  Weather.swift
//  WeatherAnimals
//
//  Created by 김은상 on 8/2/24.
//

import UIKit
import WeatherKit


struct Weather {
    var currentWeather: CurrentWeather?
    var hourlyWeathers: [HourWeather]?
    var dailyWeathers: [DayWeather]?
}
