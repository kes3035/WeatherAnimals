import UIKit
import WeatherKit

final class CurrentWeatherCell: UICollectionViewCell {
    static let identifier = "CurrentWeatherCell"
    //MARK: - Properties
    private lazy var topLabel = UILabel().then {
        $0.text = "탑 레이블"
        $0.font = UIFont.neoDeungeul(size: 12)
    }
    
    private lazy var tempImageView = UIImageView().then {
        $0.backgroundColor = .white
        $0.tintColor = .black
        $0.contentMode = .scaleAspectFit
        
    }
    
    private lazy var tempLabel = UILabel().then {
        $0.text = "온도 레이블"
        $0.font = UIFont.neoDeungeul(size: 12)

    }
    
    var hourWeather: HourWeather? {
        didSet { configureUIWithData() }
    }
    
    
   
//MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
//MARK: - Helpers
    private func configureUI() {
        self.contentView.addSubviews(topLabel, tempImageView, tempLabel)
       
        
        tempImageView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.height.equalTo(50)
        }
        
        topLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(tempImageView.snp.top).offset(-5)
        }
        
        tempLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(tempImageView.snp.bottom).offset(5)
        }
    }
    
    private func configureUIWithData() {
        guard let hourWeather = self.hourWeather else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a h:mm"
        dateFormatter.locale = Locale(identifier:"ko_KR")
        let dateString = dateFormatter.string(from: hourWeather.date)
        DispatchQueue.main.async {
            self.topLabel.text = dateString
            self.tempLabel.text = round(hourWeather.temperature.value).description + String(UnicodeScalar(0x00B0))
            self.tempImageView.image = UIImage(named: hourWeather.symbolName)
        }
    }
    
//MARK: - Actions
}
