import UIKit

class CollectionFirstHeader: UICollectionReusableView {
    static let identifier = "CollectionFirstHeader"
    //MARK: - Properties
   
    private lazy var baseView = UIView().then {
        $0.backgroundColor = UIColor(named: "background")
    }
    
    
    private lazy var titleLabel = UILabel().then {
        $0.font = UIFont.neoDeungeul(size: 14)
        $0.textColor = .black
        $0.text = "테스트"
    }
    
    private lazy var titleImageView = UIImageView().then {
        $0.backgroundColor = .clear
        $0.tintColor = .black
        $0.contentMode = .scaleAspectFill
    }
    
   
    
    var section: Int? {
        didSet {
            guard let section = section else { return }
            self.configureTitle(section)
        }
    }
    
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
        
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.baseView.layer.addBottomBorder(color: UIColor(named: "black") ?? .black, width: 2, spacing: 20)
    }
    
    //MARK: - Helpers
    private func configureUI() {
        self.backgroundColor = .white
        self.baseView.addSubviews(titleLabel, titleImageView)
        self.addSubview(baseView)
        
        self.baseView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().inset(10)
            $0.top.bottom.equalToSuperview()
        }
        
        self.titleImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.width.height.equalTo(15)
        }
        
        self.titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(titleImageView.snp.trailing).offset(10)
        }
    }
    
    private func configureTitle(_ section: Int) {
        switch section {
        case 0:
            DispatchQueue.main.async {
                self.titleLabel.text = "시간별 일기예보"
                self.titleImageView.image = UIImage(systemName: "clock")
            }
        case 1:
            DispatchQueue.main.async {
                self.titleLabel.text = "10일간의 일기예보"
                self.titleImageView.image = UIImage(systemName: "calendar")
            }
        case 2:
            DispatchQueue.main.async {
                self.titleLabel.text = "대기질"
                self.titleImageView.image = UIImage(named: "aqi.low")
            }
        default:
            return
        }
        
    }
    
    //MARK: - Actions
    
}

