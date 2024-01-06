import UIKit

final class CurrentWeatherCell: UICollectionViewCell {
//MARK: - Properties
    private lazy var topLabel = UILabel().then {
        $0.text = "탑 레이블"
        $0.font = UIFont.neoDeungeul(size: 16)
    }
    
    private lazy var tempImageView = UIImageView().then {
        $0.backgroundColor = .gray
        
    }
    
    private lazy var tempLabel = UILabel().then {
        $0.text = "온도 레이블"
        $0.font = UIFont.neoDeungeul(size: 16)

    }
    
    
    
    
   
//MARK: - LifeCycle
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
//MARK: - Helpers
    private func configureUI() {
        self.contentView.addSubViews(topLabel, tempImageView, tempLabel)
        topLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(5)
        }
        
        tempImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(50)
            $0.top.equalTo(topLabel.snp.bottom).offset(5)
        }
        
        tempLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(tempImageView.snp.bottom).offset(5)
        }
    }
    
//MARK: - Actions
}
