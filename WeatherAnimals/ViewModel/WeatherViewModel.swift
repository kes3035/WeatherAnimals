import UIKit
import SnapKit
import Then
import WeatherKit
import CoreLocation


final class WeatherViewModel {
    //MARK: - Model
    
    let yongin = CLLocation(latitude: 37.32360894097521, longitude: 127.12394643315668)
    
    var location: CLLocation?
    
    let weatherService = WeatherService()

    var currentWeather: CurrentWeather? {
        didSet {
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
    
    var maxTempOfWeek: Double?
    
    var minTempOfWeek: Double? 
    
    var hourWeather: HourWeather? {
        didSet { didChangeWeather?(self) }
    }
    
    var hourWeathers: [HourWeather]?
    
    var airQuality: AirQuality?
    
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
   
    func getAirQualityCondition(location: CLLocation) {
        let lat = location.coordinate.latitude.magnitude
        let lng = location.coordinate.longitude.magnitude
        
        guard let url = URL(string: "https://api.waqi.info/feed/geo:\(lat);\(lng)/?token=\(APIKey.aqicn_key)")
        else { return }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error { 
                print(error.localizedDescription)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Invalid HTTP Response")
                return
            }

            guard let responseData = data else {
                print("No data received")
                return
            }
            
            do {
                let airQualityResponse = try JSONDecoder().decode(AirQualityResponse.self, from: responseData)
                let aqi = airQualityResponse.data
                // 여기서 필요한 정보를 사용하여 AirQuality 구조체를 생성하거나 다른 작업을 수행할 수 있습니다.
                let airQuality = AirQuality(aqi: aqi.aqi) // 여기서 최대, 최소 AQI 값은 API 응답에서 가져와야 합니다.
                self.airQuality = airQuality
                // 이후에 필요한 처리를 진행합니다.
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
            
        }
        task.resume()
        
        
    }
    
    
    func convertUVIndex(category: UVIndex.ExposureCategory) -> (String, UIColor) {
        switch category {
        case .extreme:
            return ("심각함", UIColor.purple)
        case .high:
            return ("높음", UIColor.systemOrange)
        case .low:
            return ("낮음", Constants.greenColor)
        case .moderate:
            return ("보통", UIColor(named: "black") ?? UIColor.black)
        case .veryHigh:
            return ("매우 높음", UIColor.systemRed)
        }
    }
    
    func convertAQIIndex(value: Int) -> (String, UIColor) {
        switch value {
        case 0...50:
            return ("좋음", Constants.greenColor)
        case 51...100:
            return ("보통", UIColor.yellow)
        case 101...150:
            return ("민감군영향", UIColor.orange)
        case 151...200:
            return ("나쁨", UIColor.systemRed)
        case 201...300:
            return ("매우 나쁨", UIColor.purple)
        case 301...:
            return ("위험", UIColor.darkGray)
        default:
            return ("로딩중", UIColor(named: "black") ?? UIColor.black)
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
