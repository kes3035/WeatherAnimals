import UIKit
import WeatherKit
import SnapKit
import Then
import CoreLocation

final class WeatherCell: UITableViewCell {
    static let identifier = "WeatherCell"
//MARK: - Properties
    
    private lazy var baseView = UIView().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.borderWidth = 3
        $0.layer.borderColor = UIColor.black.cgColor
    }
    
    private lazy var weatherImageView = UIImageView().then {
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFill
    }
    
    private lazy var currentTempLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.text = "현재 온도.."
        $0.font = UIFont.neoDeungeul(size: 47)
    }
    
    private lazy var celsiusLabel = UILabel().then {
        $0.text = String(UnicodeScalar(0x00B0))
        $0.font = UIFont.neoDeungeul(size: 63)
    }
    
    private lazy var locationAddressLabel = UILabel().then {
        $0.text = "주소를 로딩중입니다.."
        $0.font = UIFont.neoDeungeul(size: 14)
    }
    
    private lazy var animalImageView = UIImageView().then {
        $0.backgroundColor = .gray
    }
    
    lazy var indexPath: Int = 0 {
        didSet {
            let myData = self.myViewModel.getMyDatas()[indexPath]
            self.configureWeatherCellUIWithData(myData)
        }
    }
    
    var currentWeather: CurrentWeather? {
        didSet {
            
        }
    }
    
    lazy var myViewModel = MyViewModel()
        
    
//MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.configureWeatherCellUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
//MARK: - Helpers
    private func configureWeatherCellUIWithData(_ myData: [String: CLLocation]) {
        
        guard let location = myData.values.first,
              let title = myData.keys.first else { return }
        
        self.myViewModel.setCurrentWeather(location: location)
        
        self.myViewModel.didFetchWeather = {
            if let currentWeather = self.myViewModel.getCurrentWeather() {
                DispatchQueue.main.async {
                    self.currentTempLabel.text = String(round(currentWeather.temperature.value))
                    self.weatherImageView.image = UIImage(named: currentWeather.symbolName)
                    self.locationAddressLabel.text = title
                }
            }
        }
    }
}

extension WeatherCell {
    private func configureWeatherCellUI() {
        self.contentView.addSubview(self.baseView)
        self.contentView.snp.makeConstraints{$0.edges.equalToSuperview()}
        
        self.baseView.addSubviews(self.currentTempLabel,
                                  self.locationAddressLabel,
                                  self.celsiusLabel,
                                  self.weatherImageView,
                                  self.animalImageView)
        
        self.baseView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.top.equalToSuperview().offset(15)
            $0.bottom.equalToSuperview().inset(15)
        }
        
        self.currentTempLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(30)
        }
        
        self.locationAddressLabel.snp.makeConstraints {
            $0.leading.equalTo(currentTempLabel.snp.leading)
            $0.bottom.equalToSuperview().offset(-5)
            
        }
        
        self.celsiusLabel.snp.makeConstraints {
            $0.top.equalTo(currentTempLabel.snp.top).offset(3)
            $0.leading.equalTo(currentTempLabel.snp.trailing).inset(3)
            
        }
        
        self.weatherImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(celsiusLabel.snp.trailing).offset(15)
            $0.width.height.equalTo(45)
        }
        
        self.animalImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(30)
            $0.width.height.equalTo(70)
        }
    }
}
