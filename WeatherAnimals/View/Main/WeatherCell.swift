import UIKit
import WeatherKit
import SnapKit
import Then

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
    
    
    private lazy var animalImageView = UIImageView().then { $0.backgroundColor = .gray }
    

    var weatherViewModel: WeatherViewModel! {
        didSet {
            guard let currentWeather = weatherViewModel.currentWeather else { return }
            self.configureUIWithData(currentWeather)
        }
    }
    
    
//MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.weatherViewModel = WeatherViewModel()
        self.configureUI()
        
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
//MARK: - Helpers
    private func configureUI() {
        self.contentView.addSubview(self.baseView)
        
        self.contentView.snp.makeConstraints{$0.edges.equalToSuperview()}
        
        self.baseView.addSubviews(self.tempLabel,
                                  self.addressLabel,
                                  self.celsiusLabel,
                                  self.weatherImageView,
                                  self.animalImageView)
        
        self.baseView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.top.equalToSuperview().offset(15)
            $0.bottom.equalToSuperview().inset(15)
        }
        
        self.tempLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(30)
        }
        
        self.addressLabel.snp.makeConstraints {
            $0.leading.equalTo(tempLabel.snp.leading)
            $0.bottom.equalToSuperview().offset(-5)
            
        }
        
        self.celsiusLabel.snp.makeConstraints {
            $0.top.equalTo(tempLabel.snp.top).offset(3)
            $0.leading.equalTo(tempLabel.snp.trailing).inset(3)
            
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
    
    private func configureUIWithData(_ weather: CurrentWeather) {
        guard let title = self.weatherViewModel.title else { return }
        DispatchQueue.main.async {
            self.tempLabel.text = String(round(weather.temperature.value))
            self.weatherImageView.image = UIImage(named: weather.symbolName)
            self.addressLabel.text = title
        }
    }
    func configureUIWithData(_ currentWeather: CurrentWeather, _ locationTitle: String) {
        DispatchQueue.main.async {
            self.tempLabel.text = String(round(currentWeather.temperature.value))
            self.weatherImageView.image = UIImage(named: currentWeather.symbolName)
            self.addressLabel.text = locationTitle
        }
    }
}
