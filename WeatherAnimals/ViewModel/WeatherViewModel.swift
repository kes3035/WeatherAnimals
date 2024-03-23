import UIKit
import SnapKit
import Then
import WeatherKit
import CoreLocation
import CoreData

final class WeatherViewModel {
    //MARK: - Model
    
    let yongin = CLLocation(latitude: 37.32360894097521, longitude: 127.12394643315668)
    
    var myLocation: CLLocation?
    
    var myLocationTitle: String?
    
    var location: CLLocation?
    
    var locations: [CLLocation]?
    
    var title: String?
    
    var titles: [String]?
    
    let weatherService = WeatherService()

    var currentWeather: CurrentWeather?
    
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
    
    var myDatas: [MyData]?
    
    //MARK: - Inputs
    
   
    //MARK: - Outputs
    
    var didChangeWeather: ((WeatherViewModel) -> Void)?

    var didFetchedWeathers: (() -> Void)?
    
    //MARK: - Logics
    //현재 날씨 정보를 가져오는 메서드
    func getMainVCWeather(location: CLLocation, completion: @escaping( () -> () ) ) {
        Task {
            do {
                let currentWeather = try await WeatherService.shared.weather(for: location, including: .current)
                self.currentWeather = currentWeather
                completion()
            } catch let error { print(String(describing: error)) }
        }
    }
    
    func configureWeatherCell(with datas: [MyData], cellForRowAt index: Int, completion: @escaping(((CurrentWeather, String))->())) {
        Task {
            do {
                if index == 0 {
                    
                    let currentWeather = try await WeatherService.shared.weather(for: self.myLocation ?? CLLocation(latitude: 0.0, longitude: 0.0), including: .current)
                    self.currentWeather = currentWeather
                    self.getMyLocationTitle(location: self.myLocation ?? CLLocation(latitude: 0.0, longitude: 0.0)) { myTitle in
                        completion((currentWeather, myTitle))
                    }
//                    completion((currentWeather, ""))
                } else {
                    let location = CLLocation(latitude: datas[index - 1].latitude, longitude: datas[index - 1].longitude)
                    guard let locationTitle = datas[index - 1].title else { return }
                    let currentWeather = try await WeatherService.shared.weather(for: location, including: .current)
                    self.currentWeather = currentWeather
                    completion((currentWeather, locationTitle))
                }
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
    
    func getDetailVCWeather(location: CLLocation, completion: @escaping ((WeatherViewModel) -> ())) {
        Task {
            do {
                let weather = try await WeatherService.shared.weather(for: location, including: .current, .daily, .hourly)
                self.dayWeathers = weather.1.forecast
                self.hourWeathers = weather.2.forecast
                self.currentWeather = weather.0
                completion(self)
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
    
    func configureTopView() -> (String, String, String) {
        guard let dayWeathers = self.dayWeathers,
              let current = self.currentWeather else { return ("", "", "") }
        let currentTemp = String(round(current.temperature.value)) +  "°"
        let highestTemp = "최고 : " + String(round(dayWeathers[0].highTemperature.value)) +  "°"
        let lowestTemp = "최저 : " + String(round(dayWeathers[0].lowTemperature.value)) +  "°"
        return (currentTemp, highestTemp, lowestTemp)
    }
    
    
    
    func getMaxMinTempOfWeek() -> [Double] {
        guard let dayWeathers = self.dayWeathers else { return [0.0, 0.0] }
        let highTemps = dayWeathers.map { round($0.highTemperature.value) }
        let lowTemps = dayWeathers.map { round($0.lowTemperature.value) }
        return getLeadingWidthOfTempView(max: highTemps.max() ?? 0.0, min: lowTemps.min() ?? 0.0)
    }
    
    func getLeadingWidthOfTempView(max: Double, min: Double) -> [Double] {
        guard let maxTempOfWeek = self.maxTempOfWeek,
              let minTempOfWeek = self.minTempOfWeek,
              let dayWeather = self.dayWeather else {
            return [0.0, 0.0]
        }
        
        let myLow = round(dayWeather.lowTemperature.value)
        let myHigh = round(dayWeather.highTemperature.value)
    
        let leading = (myLow-minTempOfWeek)/(maxTempOfWeek-minTempOfWeek)
        let width = (myHigh-myLow)/(maxTempOfWeek-minTempOfWeek)

        return [leading, width]
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
   
    
    func setValue(_ viewModel: WeatherViewModel) {
        DispatchQueue.main.async {
            guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
            
            let context = sceneDelegate.persistentContainer.viewContext
            
            let entity = NSEntityDescription.entity(forEntityName: "MyData", in: context)
            
            if let entity = entity {
                guard let title = viewModel.title else { return }
                let myData = NSManagedObject(entity: entity, insertInto: context)
                myData.setValue(viewModel.location?.coordinate.latitude, forKey: "latitude")
                myData.setValue(viewModel.location?.coordinate.longitude, forKey: "longitude")
                myData.setValue(title, forKey: "title")
                do {
                    try context.save()
                } catch {
                    print(error.localizedDescription)
                }
                
            }
        }
    }
    
    func fetchMyData() {
        DispatchQueue.main.async {
            let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
            let context = sceneDelegate.persistentContainer.viewContext
            
            do {
                guard let myData = try context.fetch(MyData.fetchRequest()) as? [MyData] else { return }
                self.myDatas = myData
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func creatLocation(cellForRowAt row: Int) -> CLLocation {
        guard let myDatas = self.myDatas else { return CLLocation(latitude: 0, longitude: 0)}
        let location = CLLocation(latitude: myDatas[row].latitude, longitude: myDatas[row].longitude)
        self.location = location
        return location
    }
    
    func creatLocation() {
        guard let myDatas = self.myDatas else { return }
         
        myDatas.forEach {
            self.locations?.append( CLLocation(latitude: $0.latitude, longitude: $0.longitude))
        }
        
    }
    
    func getMyLocationTitle(location: CLLocation, completion: @escaping((String) -> ())) {
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
            
        geocoder.reverseGeocodeLocation(location, preferredLocale: locale, completionHandler: {(placemarks, error) in
            if let address: [CLPlacemark] = placemarks {
                var myAdd: String = ""
                if let area: String = address.last?.locality{
                    myAdd += area
                }
                if let country: String = address.last?.country {
                    myAdd += ", "
                    myAdd += country
                }
                completion(myAdd)
            }
        })
    }
    
//    //MARK: - initialize
//    init(with models: [MyData]?) {
//        self.myDatas = models
//    }
    
}
