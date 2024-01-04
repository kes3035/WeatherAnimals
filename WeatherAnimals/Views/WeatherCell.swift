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
    
    private lazy var weatherLabel = UILabel().then {
        $0.text = "맑음"
        
    }
    
    private lazy var tempLabel = UILabel().then {
        $0.text = "20"
    }
    
    private lazy var addressLabel = UILabel().then {
        $0.text = "죽전동, 용인시, 대한민국"
        
    }
    
    
    private lazy var precipitationLabel = UILabel().then {
        $0.text = ""
    }
    
    var currentWeather: CurrentWeather? {
        didSet {
            guard let currentWeather = self.currentWeather else { return }
            self.tempLabel.text = currentWeather.temperature.description
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
        baseView.addSubViews(views: 
//                                weatherLabel,
                             tempLabel,
                             addressLabel
//                             , precipitationLabel
        )
        baseView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.top.equalToSuperview().offset(15)
            $0.bottom.equalToSuperview().inset(15)
        }
        tempLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(30)
            $0.width.equalTo(50)
        }
        
        addressLabel.snp.makeConstraints {
            $0.leading.equalTo(tempLabel.snp.leading)
            $0.top.equalTo(tempLabel.snp.bottom).offset(10)
        }
        
        
    }
    
//MARK: - Actions
}
