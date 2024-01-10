import UIKit
import SnapKit
import Then
import WeatherKit
import CoreLocation


class WeatherViewModel {
    //MARK: - Model
    let yongin = CLLocation(latitude: 37.33229036093, longitude: 127.13131714737)
    let weatherService = WeatherService()

    var currentWeather: CurrentWeather? {
        didSet {
            
        }
    }
    
    var minuteForecast: Forecast<MinuteWeather>?
    var dailyForecast: Forecast<DayWeather>?
    var weatherAlert: WeatherAlert?
    
    //MARK: - Inputs
    
    
    
    //MARK: - Outputs
    
    func weatherClosure(_ wea: @escaping (CurrentWeather) -> ()) {
        
    }
    
    //MARK: - Logics
    func getWeather(location: CLLocation, completion: @escaping (Weather)->()) {
        Task {
            do {
                let weather = try await WeatherService.shared.weather(for: location)
                completion(weather)
                
            } catch let error {
                print(String(describing: error))
            }
        }
    }
    
    
    func getCurrentWeather(for location: CLLocation) {
        Task {
            do {
                let weather = try await weatherService.weather(for: location)
                let currentWeather = weather.currentWeather
                self.currentWeather = currentWeather
                
            } catch let error {
                print(String(describing: error))
            }
        }
    }
    func getMinuteForecast(for location: CLLocation) {
        Task {
            do {
                let weather = try await weatherService.weather(for: location)
                let minuteForecast = weather.minuteForecast
                self.minuteForecast = minuteForecast
                
            } catch let error {
                print(String(describing: error))
            }
        }
    }
    func getDailyForecast(for location: CLLocation) {
        Task {
            do {
                let weather = try await weatherService.weather(for: location)
                let dailyForecast = weather.dailyForecast
                self.dailyForecast = dailyForecast
                
            } catch let error {
                print(String(describing: error))
            }
        }
    }
}
