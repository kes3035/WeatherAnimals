import UIKit
import WeatherKit
import SnapKit
import Then

final class WeatherCell: UITableViewCell {
    static let identifier = "WeatherCell"
//MARK: - Properties
    
    private lazy var baseView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 13
        $0.clipsToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.black.cgColor
    }
    
    private lazy var weatherImageView = UIImageView().then {
        $0.backgroundColor = .gray
        
    }
    
    private lazy var tempLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.text = "20"
        $0.font = UIFont.neoDeungeul(size: 47)

    }
    
    private lazy var celsiusLabel = UILabel().then {
        $0.text = String(UnicodeScalar(0x00B0))
        $0.font = UIFont.neoDeungeul(size: 63)
    }
    
    private lazy var addressLabel = UILabel().then {
        $0.text = "죽전동, 용인시, 대한민국"
        $0.font = UIFont.neoDeungeul(size: 14)
        
    }
    
    
    private lazy var animalImageView = UIImageView().then {
        $0.backgroundColor = .gray
    }
    
    var weather: Weather? {
        didSet {
            self.configureUIWithData()
        }
    }
    
    var dailyWeather: DayWeather? {
        didSet {
            self.configureUIWithData2()
        }
    }
    
    
//MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        configureUI()
        
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
//MARK: - Helpers
    private func configureUI() {
        self.contentView.addSubview(baseView)
        baseView.addSubViews(tempLabel,
                             addressLabel,
                             celsiusLabel,
                             weatherImageView,
                             animalImageView
        )
        
        baseView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.top.equalToSuperview().offset(15)
            $0.bottom.equalToSuperview().inset(15)
        }
        
        tempLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(30)
        }
        
        addressLabel.snp.makeConstraints {
            $0.leading.equalTo(tempLabel.snp.leading)
            $0.bottom.equalToSuperview().offset(-5)
            
        }
        
        celsiusLabel.snp.makeConstraints {
            $0.top.equalTo(tempLabel.snp.top).offset(3)
            $0.leading.equalTo(tempLabel.snp.trailing).inset(3)
            
        }
        
        weatherImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(celsiusLabel.snp.trailing).offset(15)
            $0.width.height.equalTo(45)
        }
        
        animalImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(30)
            $0.width.height.equalTo(70)
        }
    }
    
    private func configureUIWithData() {
        guard let weather = self.weather else { return }
        DispatchQueue.main.async {
            self.tempLabel.text = String(round(weather.currentWeather.temperature.value))
            
        }
    }
    
    private func configureUIWithData2() {
        guard let dayWeather = self.dailyWeather else { return }
        DispatchQueue.main.async {
            
            
        }
    }
    
//MARK: - Actions
}
