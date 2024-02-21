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
            didChangeWeather?(self)
            didFetchedWeathers?()
        }
    }
    
    var dayWeather: DayWeather? {
        didSet {
            didChangeWeather?(self)
        }
    }
    
    var dayWeathers: [DayWeather]?
    
    var maxTempOfWeek: Double? {
        didSet {
            guard let maxTempOfWeek = self.maxTempOfWeek else { return }
        }
    }
    
    var minTempOfWeek: Double? {
        didSet {
            guard let minTempOfWeek = self.minTempOfWeek else { return }
        }
    }
    
    var hourWeather: HourWeather? {
        didSet {
            didChangeWeather?(self)
        }
    }
    
    var hourWeathers: [HourWeather]?
    
    //MARK: - Inputs
    
   
    //MARK: - Outputs
    
    var didChangeWeather: ((WeatherViewModel) -> Void)?

    var didFetchedWeathers: (() -> Void)?
    
    //MARK: - Logics
    //현재 날씨 정보를 가져오는 메서드
    func getMainVCWeather(location: CLLocation) {
        Task {
            do {
                let currentWeather = try await WeatherService.shared.weather(for: location, including: .current)
                self.currentWeather = currentWeather
            } catch let error { print(String(describing: error)) }
        }
    }
    
    func getDetailVCWeather(location: CLLocation) {
        Task {
            do {
                let weather = try await WeatherService.shared.weather(for: location, including: .current, .daily, .hourly)
                self.dayWeathers = weather.1.forecast
                self.hourWeathers = weather.2.forecast
                self.currentWeather = weather.0
            } catch let error { print(String(describing: error)) }
        }
    }
    
    func getCurrentWeather(location: CLLocation) {
        Task {
            do {
                let weather = try await WeatherService.shared.weather(for: location, including: .current)
                self.currentWeather = weather
            } catch let error { print(String(describing: error)) }
        }
    }
    
    func getHourWeather(location: CLLocation) {
        Task {
            do {
                let weather = try await WeatherService.shared.weather(for: location, including: .hourly)
                self.hourWeathers = weather.forecast
            } catch let error { print(String(describing: error)) }
        }
    }
    
    func getDayWeather(location: CLLocation) {
        Task {
            do {
                let weather = try await WeatherService.shared.weather(for: location, including: .daily)
                self.dayWeathers = weather.forecast
            } catch let error { print(String(describing: error)) }
        }
    }
    
    func getMaxMinTempOfWeek(_ dayWeahter: DayWeather) {
        guard let dayWeathers = self.dayWeathers else { return }
        let highTemps = dayWeathers.map { round($0.highTemperature.value) }
        let lowTemps = dayWeathers.map { round($0.lowTemperature.value) }
        self.maxTempOfWeek = highTemps.max()
        self.minTempOfWeek = lowTemps.min()
    }
    
    func getLeadingWidthOfTempView() -> (Double, Double) {
        guard let maxTempOfWeek = self.maxTempOfWeek,
              let minTempOfWeek = self.minTempOfWeek,
              let dayWeather = self.dayWeather else {
            return (0.0, 0.0)
        }
        
        let myLow = round(dayWeather.lowTemperature.value)
        let myHigh = round(dayWeather.highTemperature.value)
    
        let leading = (myLow-minTempOfWeek)/(maxTempOfWeek-minTempOfWeek)
        let width = (myHigh-myLow)/(maxTempOfWeek-minTempOfWeek)

        return (leading, width)
    }
   
    func getAirQualityCondition() -> (Int, String){
        guard let currentWeather = self.currentWeather else {
            return (0, "오류")
        }
        
        let airQualityValue = 0
        
        var airQualityDescription = ""
        
        
        return (airQualityValue, airQualityDescription)
        
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
