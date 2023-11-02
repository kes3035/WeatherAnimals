import UIKit
import WeatherKit

final class WeatherCell: UITableViewCell {
    static let identifier = "WeatherCell"
//MARK: - Properties
    
    private lazy var baseView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
        $0.layer.borderWidth = 3
        $0.layer.borderColor = UIColor.gray.cgColor
    }
    
    private lazy var weatherLabel = UILabel().then {
        $0.text = "맑음"
        
    }
    
    private lazy var tempLabel = UILabel().then {
        $0.text = "20"
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
                             tempLabel
//                             , precipitationLabel
        )
        baseView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().inset(10)
            $0.top.equalToSuperview().offset(5)
            $0.bottom.equalToSuperview().inset(5)
        }
        tempLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
    }
    
//MARK: - Actions
}
