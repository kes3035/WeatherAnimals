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
    let weatherViewModel = WeatherViewModel()
    weatherViewModel.getDayWeather(location: weatherViewModel.yongin) { weather in
        weather.forEach { weather in
            
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

    
    
    //MARK: - Inputs
    
   
    //MARK: - Outputs
    
    
    //MARK: - Logics
    //현재 날씨 정보를 가져오는 메서드
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
    func getHourlyWeather(location: CLLocation, completion: @escaping (Forecast<HourWeather>)->()) {
        Task {
            do {
                let weather = try await WeatherService.shared.weather(for: location, including: .hourly)
                completion(weather)
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
        
        
        return ""
    }
    
//    func getDayOfWeek(date: Date = Date()) -> [String] {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "EEEEEE"
//        formatter.locale = Locale(identifier:"ko_KR")
//        let convertStr = formatter.string(from: date)
//        var dayOfWeek: [String] = []
//        
//        return [""]
//    }
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
