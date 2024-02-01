import UIKit
import WeatherKit

final class HourWeatherCell: UICollectionViewCell {
    static let identifier = "HourWeatherCell"
    //MARK: - Properties
    lazy var topLabel = UILabel().then {
        $0.text = "로딩중"
        $0.font = UIFont.neoDeungeul(size: 12)
    }
    
    lazy var tempImageView = UIImageView().then {
        $0.backgroundColor = .white
        $0.tintColor = .black
        $0.contentMode = .scaleAspectFit
    }
    
    lazy var tempLabel = UILabel().then {
        $0.text = "로딩중"
        $0.font = UIFont.neoDeungeul(size: 12)

    }
   
//MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
        
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
}
