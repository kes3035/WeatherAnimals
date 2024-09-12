//
//  MyWeather.swift
//  WeatherAnimals
//
//  Created by 김은상 on 8/15/24.
//

import UIKit
import WeatherKit
import CoreLocation

struct MyWeather {
    var location: CLLocation?
    var title: String?
    var currentWeather: CurrentWeather
    var dailyWeathers: [DayWeather]
    var hourlyWeathers: [HourWeather]
}
