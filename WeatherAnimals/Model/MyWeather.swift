//
//  MyWeather.swift
//  WeatherAnimals
//
//  Created by 김은상 on 8/15/24.
//

import UIKit
import WeatherKit

struct MyWeather {
    let currentWeather: CurrentWeather
    let dailyWeathers: [DayWeather]
    let hourlyWeathers: [HourWeather]
}
