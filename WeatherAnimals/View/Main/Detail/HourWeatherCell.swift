import UIKit
import WeatherKit
import CoreLocation

final class HourWeatherCell: UICollectionViewCell {
    static let identifier = "HourWeatherCell"
    //MARK: - Properties
    private lazy var topLabel = UILabel().then {
        $0.text = "로딩중"
        $0.font = UIFont.neoDeungeul(size: 12)
    }
    
    private lazy var tempImageView = UIImageView().then {
        $0.backgroundColor = .clear
        $0.tintColor = .black
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var tempLabel = UILabel().then {
        $0.text = "로딩중"
        $0.font = UIFont.neoDeungeul(size: 12)
    }
    
    var timeZone: TimeZone?

    var hourWeather: HourWeather? {
        didSet {
            self.configureUIWithData()
        }
    }

    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureHourWeatherCellUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    //MARK: - Helpers

    private func configureUIWithData() {
        guard let hourWeather = self.hourWeather,
        let timeZone = self.timeZone else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a h:mm"
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = Locale(identifier:"ko_KR")
        print(hourWeather.date)
        let dateString = dateFormatter.string(from: hourWeather.date)
        print(dateString)
        DispatchQueue.main.async {
            self.topLabel.text = dateString
            self.tempLabel.text = round(hourWeather.temperature.value).description + String(UnicodeScalar(0x00B0))
            self.tempImageView.image = UIImage(named: hourWeather.symbolName)
        }
    }
}


extension HourWeatherCell {
    private func configureHourWeatherCellUI() {
        self.contentView.addSubviews(self.topLabel, self.tempImageView, self.tempLabel)
       
        self.tempImageView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.height.equalTo(50)
        }
        
        self.topLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(tempImageView.snp.top)
        }
        
        self.tempLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(tempImageView.snp.bottom)
        }
    }
}
