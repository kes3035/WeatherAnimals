import UIKit

class CollectionReusableView: UICollectionReusableView {
    static let identifier = "CollectionReusableView"
    //MARK: - Properties
    private lazy var baseView = UIView().then {
        $0.backgroundColor = .systemGray3
    }
    
    var type: String? {
        didSet {
            guard let type = type else { return }
            self.configureUIWithType(type)
        }
    }
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    private func configureUI() {
        self.addSubview(baseView)
        
        
        self.baseView.snp.makeConstraints {
            $0.leading.top.equalToSuperview().offset(15)
            $0.trailing.bottom.equalToSuperview().inset(15)
        }
    }
    
    private func configureUIWithType(_ type: String) {
        switch type {
        case "CurrentWeather":
            print("")
        case "DailyWeather":
            print("")
        case "AirQuality":
            print("")
        default:
            return
        }
    }
    
    
    //MARK: - Actions
    
}
