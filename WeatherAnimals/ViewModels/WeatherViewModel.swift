import UIKit
import SnapKit
import Then
import WeatherKit
import CoreLocation


/*
 1. Weather
 Weather.currentWeather.temperature.value = 현재 온도 : Double
 Weather.currentWeather.apparentTemperature.value = 체감 온도 : Double
 Weather.currentWeather.humidity = 습도 : Double
 Weather.currentWeather.symbolName = "wind" : String
 
 2. DayWeather
 DayWeather.forecast = [DayWeather] 오늘을 포함한 10일 동안의 날씨 데이터
 cell.dayWeather에 indexPath.row 를 넘겨주면 didSet을 통해 UI수정
 var dayWeather: DayWeather? {
    didSet {
        DisPatchQueue.main.async {
            guard let dayWeather = self.dayWeather else { return }
            dayWeather.highTemperature = 최고기온
            dayWeather.lowTemperature = 최저기온
            dayWeather.condition.description = 날씨에 대한 설명 ex. 맑음, 거의 맑음, 눈, 구름, ...
 
        }
    }
 }
 
 
 
 */


func test() {
    let vm = WeatherViewModel()
    vm.getDayWeather(location: vm.yongin) { dayWeather in
        dayWeather.forecast.forEach { forecast in
            print()
        }
    }
}

final class WeatherViewModel {
    //MARK: - Model
    
    typealias WEATHER_DATA = (Weather, CurrentWeather?,
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
            } catch let error { print(String(describing: error)) }
        }
    }
    
    func getCurrentWeather(location: CLLocation, completion: @escaping (CurrentWeather) -> ()) {
        Task {
            do {
                let weather = try await WeatherService.shared.weather(for: location, including: .current)
                completion(weather)
            } catch let error { print(String(describing: error)) }
        }
    }
    
    func getDayWeather(location: CLLocation, completion: @escaping (Forecast<DayWeather>) -> ()) {
        Task {
            do {
                let weather = try await WeatherService.shared.weather(for: location, including: .daily)
                completion(weather)
            } catch let error { print(String(describing: error)) }
        }
    }
    
    func getWeatherAlert(location: CLLocation, completion: @escaping ([WeatherAlert])->()) {
        Task {
            do {
                let weather = try await WeatherService.shared.weather(for: location, including: .alerts)
                guard let alerts = weather else { return }
                completion(alerts)
            } catch let error { print(String(describing: error)) }
        }
    }
    
    func getWeatherAvailability(location: CLLocation, completion: @escaping (WeatherAvailability)->()) {
        Task {
            do {
                let weather = try await WeatherService.shared.weather(for: location, including: .availability)
                completion(weather)
            } catch let error { print(String(describing: error)) }
        }
    }
    
    func getHourlyWeather(location: CLLocation, completion: @escaping (Forecast<HourWeather>)->()) {
        Task {
            do {
                let weather = try await WeatherService.shared.weather(for: location, including: .hourly)
                completion(weather)
            } catch let error { print(String(describing: error)) }
        }
    }
    
    func getMinuteWeather(location: CLLocation, completion: @escaping (Forecast<MinuteWeather>)->()) {
        Task {
            do {
                let weather = try await WeatherService.shared.weather(for: location, including: .minute)
                guard let minWeather = weather else { return }
                completion(minWeather)
            } catch let error { print(String(describing: error)) }
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
