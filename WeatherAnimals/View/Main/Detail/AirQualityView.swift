import UIKit

final class AirQualityView: UIView {
//MARK: - Properties
    private lazy var titleLabel = UILabel().then {
        $0.text = "대기질"
        $0.font = UIFont.neoDeungeul(size: 20)
    }
    
    private lazy var airQualityLabel = UILabel().then {
        $0.text = "3"
        $0.font = UIFont.neoDeungeul(size: 32)
    }
    
    private lazy var airQualityView = UIView().then {
        $0.backgroundColor = Constants.greenColor
    }
    
    
//MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
//MARK: - Helpers
    private func configureUI() {
        self.backgroundColor = .white
        
    }
    
//MARK: - Actions
}
