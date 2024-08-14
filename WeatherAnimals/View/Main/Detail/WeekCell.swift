import UIKit
import WeatherKit

/*
 오늘 날씨에 대한 정보가 들어있는 셀
 수평으로 스크롤 가능한 콜렉션뷰로 이루어짐
 */
final class WeekCell: UICollectionViewCell {
    static let identifier = "WeekCell"
    //MARK: - Properties
    lazy var tenDaysTempView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.isScrollEnabled = false
        $0.register(WeekWeatherCell.self, forCellReuseIdentifier: WeekWeatherCell.identifier)
        $0.backgroundColor = UIColor(named: "myBackground")
        $0.separatorStyle = .none
    }
    
    lazy var myViewModel = MyViewModel() {
        didSet {
            DispatchQueue.main.async {
                self.tenDaysTempView.reloadData()
            }
        }
    }

    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureWeekCellUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    //MARK: - Helpers
    

    
    private func getTempViewConstraints(dayWeathers: [DayWeather], index: Int) -> (Double, Double) {
        let maxTemp = dayWeathers.map { round($0.highTemperature.value) }.max() ?? 0.0
        let minTemp = dayWeathers.map { round($0.lowTemperature.value) }.min() ?? 0.0
        
        let myLow = round(dayWeathers[index].lowTemperature.value)
        let myHigh = round(dayWeathers[index].highTemperature.value)

        let leading = (myLow-minTemp)/(maxTemp-minTemp)
        let width = (myHigh-myLow)/(maxTemp-minTemp)
        
        return (leading, width)
    }
    
    private func getDayOfWeeks(from startDate: Date = Date(), to endDate: Date? = nil) -> [String] {
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


//MARK: - UITableViewDelegate, UITableViewDataSource
extension WeekCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeekWeatherCell.identifier, for: indexPath) as! WeekWeatherCell
        guard let weathers = self.myViewModel.getWeathers(),
              let selectedIndex = self.myViewModel.getSelectedIndex(),
              let timeZone = self.myViewModel.getTimeZone() else { return cell }
        
        let weather = weathers[selectedIndex]
        let dailyWeather = weather.dailyWeathers
        
        
        cell.tempViewConstraints = self.getTempViewConstraints(dayWeathers: dailyWeather, index: indexPath.row)
        cell.timeZone = timeZone
        cell.dayWeather = dailyWeather[indexPath.row]

        if indexPath.row == 0 {
            cell.weekdaysTitleLabel.text = "오늘"
        } else {
            cell.weekdaysTitleLabel.text = self.getDayOfWeeks(from: Date())[indexPath.row]
        }
        
        return cell
    }
}

extension WeekCell {
    private func configureWeekCellUI() {
        self.backgroundColor = .white
        self.contentView.addSubview(self.tenDaysTempView)
        self.tenDaysTempView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.bottom.equalToSuperview()
            $0.top.equalToSuperview()
        }
    }
}
