import UIKit

class CollectionReusableView: UICollectionReusableView {
    static let identifier = "CollectionReusableView"
    //MARK: - Properties
   
    private lazy var leftBaseView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray4.cgColor
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private lazy var rightBaseView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray4.cgColor
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
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
    
    
    //MARK: - Helpers
    private func configureUI() {
        self.backgroundColor = .white
        self.leftBaseView.addSubviews(leftTitleLabel, leftTitleImageView)
        self.addSubview(leftBaseView)
        
        self.leftBaseView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().inset(10)
            $0.top.bottom.equalToSuperview()
        }
        
        self.leftTitleImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.width.height.equalTo(15)
        }
        
        self.leftTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(leftTitleImageView.snp.trailing).offset(10)
        }
    }
    
    private func configureTitle(_ section: Int) {
        switch section {
        case 0:
            DispatchQueue.main.async {
                self.leftTitleLabel.text = "시간별 일기예보"
                self.leftTitleImageView.image = UIImage(systemName: "clock")
            }
        case 1:
            DispatchQueue.main.async {
                self.leftTitleLabel.text = "10일간의 일기예보"
                self.leftTitleImageView.image = UIImage(systemName: "calendar")
            }
        case 2:
            DispatchQueue.main.async {
                self.leftTitleLabel.text = "대기질"
                self.leftTitleImageView.image = UIImage(named: "aqi.low")
            }
        case 3:
            self.addSubview(rightBaseView)
            self.rightBaseView.addSubviews(rightTitleLabel, rightTitleImageView)
            DispatchQueue.main.async {
                
                self.leftBaseView.snp.makeConstraints {
                    $0.leading.equalToSuperview().offset(10)
                    $0.trailing.equalTo(self.snp.centerX).inset(10)
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
                self.leftTitleLabel.text = "자외선 지수"
                self.leftTitleImageView.image = UIImage(systemName: "sun.max")
                self.rightTitleLabel.text = "일출"
                self.rightTitleImageView.image = UIImage(systemName: "sunrise")
            }
        case 4:
            print("")
        default:
            return
        }
        
    }
    
    //MARK: - Actions
    
}
