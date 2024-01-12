import UIKit
import SnapKit
import Then
import WeatherKit
import CoreLocation


class WeatherViewModel {
    //MARK: - Model
    
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
    
    
    func getWeather(location: CLLocation, current: Bool? = false, daily: Bool? = false ,completion: @escaping (Weather?, Forecast<DayWeather>?)->()) {
        //@escaping 부분은 받아올 데이터가 많아질 경우를 대비하여 typealias로 최상단에 정의 할 필요있음
        // 옵셔널 바인딩을 통해 값이 nil인지 확인 기본값으로 false를 주어 사용하지 않을 데이터 거르기
        guard let current = current,
              let daily = daily else { return }
        
        Task {
            do {
                //받을 데이터의 T/F여부에 따라 WeatherService의 함수로 날씨정보를 선택적으로 받아오기
                //ex) weather만 받고 Forecast<DayWeather>는 안받고 싶음
                //    아래와 같이 사용
                //
                //    getWeather(location: myLocation, current: true) { completion in
                //        guard let weather = completion else { return }
                //        날씨정보 사용 가능
                //    }
                if current {
                    let weather = try await WeatherService.shared.weather(for: location)
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
