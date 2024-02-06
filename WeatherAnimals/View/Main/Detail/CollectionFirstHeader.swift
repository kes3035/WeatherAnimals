import UIKit

class CollectionFirstHeader: UICollectionReusableView {
    static let identifier = "CollectionFirstHeader"
    //MARK: - Properties
    
    private lazy var baseView = UIView()
    
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
    
    private lazy var leftBaseView = UIView()
    
    private lazy var rightBaseView = UIView()
    
    private lazy var leftTitleLabel = UILabel().then {
        $0.font = UIFont.neoDeungeul(size: 14)
        $0.textColor = .black
        $0.text = "테스트"
    }
    
    private lazy var leftTitleImageView = UIImageView().then {
        $0.backgroundColor = .clear
        $0.tintColor = .black
        $0.contentMode = .scaleAspectFill
    }
    
    private lazy var rightTitleLabel = UILabel().then {
        $0.font = UIFont.neoDeungeul(size: 14)
        $0.textColor = .black
        $0.text = "테스트"
    }
    
    private lazy var rightTitleImageView = UIImageView().then {
        $0.backgroundColor = .clear
        $0.tintColor = .black
        $0.contentMode = .scaleAspectFill
    }
    
    private lazy var baseViews = [baseView, leftBaseView, rightBaseView]
    
    
    var section: Int? {
        didSet {
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
        self.baseViews.forEach { $0.layer.addBottomBorder(color: UIColor(named: "black") ?? .black, width: 2, spacing: 20)}
    }
    
    //MARK: - Helpers
    private func configureUI() {
        self.backgroundColor = .white
        
        self.baseView.addSubviews(titleLabel, titleImageView)
        self.rightBaseView.addSubviews(rightTitleLabel, rightTitleImageView)
        self.leftBaseView.addSubviews(leftTitleLabel, leftTitleImageView)
        self.addSubviews(leftBaseView, rightBaseView, baseView)
        
        self.baseViews.forEach { $0.backgroundColor = UIColor(named: "background") }
        
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
                $0.leading.equalTo(self.titleImageView.snp.trailing).offset(10)
            }
            
            self.leftBaseView.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(10)
                $0.trailing.equalTo(self.snp.centerX).offset(-15)
                $0.top.bottom.equalToSuperview()
            }
            
            self.leftTitleImageView.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().offset(20)
                $0.width.height.equalTo(15)
            }
            
            self.leftTitleLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalTo(self.leftTitleImageView.snp.trailing).offset(10)
            }
            
            self.rightBaseView.snp.makeConstraints {
                $0.leading.equalTo(self.snp.centerX).offset(15)
                $0.trailing.equalToSuperview().inset(10)
                $0.top.bottom.equalToSuperview()
            }
            
            self.rightTitleImageView.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().offset(20)
                $0.width.height.equalTo(15)
            }
            
            self.rightTitleLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalTo(self.rightTitleImageView.snp.trailing).offset(10)
            }
        
    }
    
    private func configureTitle(_ section: Int?) {
        guard let section = section else { return }
        
        guard section == 0 || section == 1 else {
            // 0, 1 섹션이 아니면
            [self.baseView, self.titleLabel, self.titleImageView].forEach { $0.removeFromSuperview() }
            
            switch section {
            case 2:
                self.leftTitleLabel.text = "자외선 지수"
                self.leftTitleImageView.image = UIImage(systemName: "sun.max")
                self.rightTitleLabel.text = "대기질"
                self.rightTitleImageView.image = UIImage(systemName: "aqi.low")
            case 3:
                self.leftTitleLabel.text = "습도"
                self.leftTitleImageView.image = UIImage(systemName: "humidity")
                self.rightTitleLabel.text = "체감온도"
                self.rightTitleImageView.image = UIImage(systemName: "thermometer")
            case 4:
                self.leftTitleLabel.text = "강수량"
                self.leftTitleImageView.image = UIImage(systemName: "drop.fill")
                self.rightTitleLabel.text = "일출"
                self.rightTitleImageView.image = UIImage(systemName: "sunrise")
            default:
                break
            }
            
            return
        }
        // 0,1 섹션이면
        [self.leftBaseView, self.leftTitleLabel, self.leftTitleImageView, self.rightBaseView, self.rightTitleLabel, self.rightTitleImageView].forEach { $0.removeFromSuperview() }
        
        switch section {
        case 0:
            self.titleLabel.text = "시간별 일기예보"
            self.titleImageView.image = UIImage(systemName: "clock")
        case 1:
            self.titleLabel.text = "10일간의 일기예보"
            self.titleImageView.image = UIImage(systemName: "calendar")
        default:
            break
        }
    }
    
    //MARK: - Actions
    
}

