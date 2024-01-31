import UIKit
import SnapKit
import Then
import WeatherKit
import CoreLocation


final class WeatherViewModel {
    //MARK: - Model
    
    let yongin = CLLocation(latitude: 37.33229036093, longitude: 127.13131714737)
    
    var location: CLLocation?
    
    let weatherService = WeatherService()

    var currentWeather: CurrentWeather? {
        didSet {
            print("디버깅: WeatherViewModel's CurrentWeather Changed")
            didChangeCurrentWeather?(self)
        }
    }
    
    var dayWeather: [DayWeather]?
    
    var hourWeather: [HourWeather]?
    
    var countOfHourWeathers: Int?
    //MARK: - Inputs
    
   
    //MARK: - Outputs
    
    var didChangeCurrentWeather: ((WeatherViewModel) -> Void)?
    
    
    func hourCount() -> Int {
        guard let countOfHourWeathers = self.countOfHourWeathers else { return 0 }
        return countOfHourWeathers
    }
    
    func headerImage(name: String) -> UIImage? {
        
        
        
        return UIImage(named: name)
    }
    
    
    //MARK: - Logics
    //현재 날씨 정보를 가져오는 메서드
    func getMainVCWeather(location: CLLocation, completion: @escaping (CurrentWeather) -> ()) {
        Task {
            do {
                let weather = try await WeatherService.shared.weather(for: location, including: .current)
                completion(weather)
            } catch let error { print(String(describing: error)) }
        }
    }
    
    func getMainVCWeather(location: CLLocation) {
        Task {
            do {
                let currentWeather = try await WeatherService.shared.weather(for: location, including: .current)
                self.currentWeather = currentWeather
            } catch let error { print(String(describing: error)) }
        }
    }
    
    func getDetailVCWeather(location: CLLocation, completion: @escaping (CurrentWeather, [DayWeather], [HourWeather]) -> ()) {
        Task {
            do {
                let weather = try await WeatherService.shared.weather(for: location, including: .current, .daily, .hourly)
                completion(weather.0, weather.1.forecast, weather.2.forecast)
            } catch let error { print(String(describing: error)) }
        }
    }
    
    func getDetailVCWeather(location: CLLocation) {
        Task {
            do {
                let weather = try await WeatherService.shared.weather(for: location, including: .current, .daily, .hourly)
                self.currentWeather = weather.0
                self.dayWeather = weather.1.forecast
                self.hourWeather = weather.2.forecast
                print("디버깅: getDetailVCWeather실행, 데이터 받기 완료")
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
    //일일 날씨 정보를 가져오는 메서드 (10일간의 데이터)
    func getDayWeather(location: CLLocation, completion: @escaping (Forecast<DayWeather>) -> ()) {
        Task {
            do {
                let weather = try await WeatherService.shared.weather(for: location, including: .daily)
                completion(weather)
            } catch let error { print(String(describing: error)) }
        }
    }
    
    //날씨 경보 정보를 가져오는 메서드 (10일간의 데이터)
    func getWeatherAlert(location: CLLocation, completion: @escaping ([WeatherAlert])->()) {
        Task {
            do {
                let weather = try await WeatherService.shared.weather(for: location, including: .alerts)
                guard let alerts = weather else { return }
                completion(alerts)
            } catch let error { print(String(describing: error)) }
        }
    }
    
    //날씨 가용성 정보를 가져오는 메서드
    func getWeatherAvailability(location: CLLocation, completion: @escaping (WeatherAvailability)->()) {
        Task {
            do {
                let weather = try await WeatherService.shared.weather(for: location, including: .availability)
                completion(weather)
            } catch let error { print(String(describing: error)) }
        }
    }
    
    //시간별 날씨 정보를 가져오는 메서드
    func getHourlyWeather(location: CLLocation) {
        Task {
            do {
                let weather = try await WeatherService.shared.weather(for: location, including: .hourly)
                self.hourWeather = weather.forecast
                self.countOfHourWeathers = weather.forecast.count
            } catch let error { print(String(describing: error)) }
        }
    }
    
    //분단위 날씨 정보를 가져오는 메서드
    func getMinuteWeather(location: CLLocation, completion: @escaping (Forecast<MinuteWeather>)->()) {
        Task {
            do {
                let weather = try await WeatherService.shared.weather(for: location, including: .minute)
                guard let minWeather = weather else { return }
                completion(minWeather)
            } catch let error { print(String(describing: error)) }
        }
    }
    
    func convertWeatherCondition(condition: WeatherCondition) -> String {
        switch condition {
        case .blizzard:
            return "눈보라다 멍"
        case .blowingDust:
            return "모래바람이다 멍"
        case .blowingSnow:
            return "눈바람이다 멍"
        case .breezy:
            return "산들바람이다 멍"
        case .clear:
            return "맑다 멍"
        case .cloudy:
            return "구름있다 멍"
        case .drizzle:
            return ""
        case .flurries:
            return ""
        case .foggy:
            return ""
        case .freezingDrizzle:
            return ""
        case .freezingRain:
            return ""
        case .frigid:
            return ""
        case .hail:
            return ""
        case .haze:
            return ""
        case .heavyRain:
            return ""
        case .heavySnow:
            return ""
        case .hot:
            return ""
        case .hurricane:
            return ""
        case .isolatedThunderstorms:
            return ""
        case .mostlyClear:
            return ""
        case .mostlyCloudy:
            return ""
        case .partlyCloudy:
            return ""
        case .rain:
            return ""
        case .scatteredThunderstorms:
            return ""
        case .sleet:
            return ""
        case .smoky:
            return ""
        case .snow:
            return ""
        case .strongStorms:
            return ""
        case .sunFlurries:
            return ""
        case .sunShowers:
            return ""
        case .thunderstorms:
            return ""
        case .tropicalStorm:
            return ""
        case .windy:
            return ""
        case .wintryMix:
            return ""
        @unknown default:
            return ""
        }
    }

    //오늘로부터 10일뒤까지의 요일 반환하는 메서드
    func getDayOfWeeks(from startDate: Date = Date(), to endDate: Date? = nil) -> [String] {
        let calendar = Calendar.current
        var currentDate = startDate
        var dayOfWeeks: [String] = []
        
        while currentDate <= (endDate ?? calendar.date(byAdding: .day, value: 9, to: startDate)!) {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEEEE"
            formatter.locale = Locale(identifier: "ko_KR")
            let dayOfWeek = formatter.string(from: currentDate)
            dayOfWeeks.append(dayOfWeek)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return dayOfWeeks
    }
   
    
}
