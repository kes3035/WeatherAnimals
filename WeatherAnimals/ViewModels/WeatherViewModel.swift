import UIKit
import SnapKit
import Then
import WeatherKit
import CoreLocation


final class WeatherViewModel {
    //MARK: - Model
    
    typealias WEATHER_DATA = (Weather?, CurrentWeather?,
                              Forecast<DayWeather>?,
                              WeatherAlert?,
                              WeatherAvailability?,
                              Forecast<HourWeather>?,
                              Forecast<MinuteWeather>?) -> ()
    
    let yongin = CLLocation(latitude: 37.33229036093, longitude: 127.13131714737)
    
    var location: CLLocation?
    
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
    
    func getWeather(location: CLLocation, completion: @escaping (Weather, Forecast<DayWeather>)->()) {
        Task {
            do {
                let weather = try await WeatherService.shared.weather(for: location)
                let dayWeather = try await WeatherService.shared.weather(for: location, including: .daily)
                completion(weather, dayWeather)
            } catch let error {
                print(String(describing: error))
            }
        }
    }
    
    
    
    
    func getWeather(location: CLLocation,
                    current: Bool? = false,
                    daily: Bool? = false ,
                    alert: Bool? = false,
                    availability: Bool? = false,
                    hourly: Bool? = false,
                    minute: Bool? = false,
                    completion: @escaping WEATHER_DATA) {

        guard let current = current,
              let daily = daily,
              let alert = alert,
              let availability = availability,
              let hourly = hourly,
              let minute = minute else { return }
        Task {
            do {
                
                
                if current {
                    let weather = try await WeatherService.shared.weather(for: location, including: .hourly)
                    completion(weather, nil)
                } else if current && daily {
                    let weather = try await WeatherService.shared.weather(for: location)
                    let dayWeather = try await WeatherService.shared.weather(for: location, including: .daily)
                    completion(weather, dayWeather)
                } else {
                    let dayWeather = try await WeatherService.shared.weather(for: location, including: .daily)
                    completion(nil, dayWeather)
                }
                
                
                
            } catch let error {
                print(String(describing: error))
            }
        }
    }
    
    
  
    
    func getWeather(location: CLLocation, completion: @escaping (Forecast<DayWeather>) -> ()) {
        Task {
            do {
                // 현재 날짜 얻기
                let currentDate = Date()
                
                // 10일 후의 날짜 계산
                if let endDate = Calendar.current.date(byAdding: .day, value: 10, to: currentDate) {
                    let weather = try await WeatherService.shared.weather(for: location, including: .daily(startDate: currentDate, endDate: endDate))
                    completion(weather)
                } else {
                    print("날짜 계산 실패")
                }
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
