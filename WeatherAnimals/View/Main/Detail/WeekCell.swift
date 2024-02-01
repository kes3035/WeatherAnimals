import UIKit
import WeatherKit

/*
 오늘 날씨에 대한 정보가 들어있는 셀
 수평으로 스크롤 가능한 콜렉션뷰로 이루어짐
 */
final class WeekCell: UICollectionViewCell {
    static let identifier = "WeekCell"
    //MARK: - Properties
    private lazy var tenDaysTempView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.isScrollEnabled = false
        $0.register(WeekWeatherCell.self, forCellReuseIdentifier: WeekWeatherCell.identifier)
        $0.layer.cornerRadius = 16
        $0.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]

        $0.backgroundColor = .white
        $0.layer.borderColor = UIColor.systemGray4.cgColor
        $0.layer.borderWidth = 1
        $0.rowHeight = 60
    }
    
    var weatherViewModel: WeatherViewModel! {
        didSet {
//            DispatchQueue.main.async {
//                self.tenDaysTempView.reloadData()
//            }
        }
    }
    
    var dayWeathers: [DayWeather]? {
        didSet {
            DispatchQueue.main.async {
                self.tenDaysTempView.reloadData()
            }
        }
    }
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.weatherViewModel = WeatherViewModel()
        self.configureUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    //MARK: - Helpers
    
    private func configureUI() {
        self.backgroundColor = .white
        self.contentView.addSubview(tenDaysTempView)
        self.tenDaysTempView.snp.makeConstraints { 
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.bottom.equalToSuperview().inset(10)
            $0.top.equalToSuperview()
        }
    }
    
    //MARK: - Actions
    
    
}

extension WeekCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeekWeatherCell.identifier, for: indexPath) as! WeekWeatherCell
        guard let dayWeathers = self.dayWeathers else { return cell }
        cell.dayWeather = dayWeathers[indexPath.row]
        if indexPath.row == 0 {
            cell.weekdaysTitleLabel.text = "오늘"
        } else {
            cell.weekdaysTitleLabel.text = self.weatherViewModel.getDayOfWeeks(from: Date())[indexPath.row]
        }
        return cell
    }
}
