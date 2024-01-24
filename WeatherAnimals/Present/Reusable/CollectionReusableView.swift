import UIKit

class CollectionReusableView: UICollectionReusableView {
    static let identifier = "CollectionReusableView"
    //MARK: - Properties
   
    private lazy var baseView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray4.cgColor
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.font = UIFont.neoDeungeul(size: 14)
        $0.textColor = .black
        $0.text = "테스트"
    }
    
    private lazy var titleImageView = UIImageView().then {
        $0.backgroundColor = .darkGray
        $0.contentMode = .scaleAspectFit
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
        self.backgroundColor = .white
        self.baseView.addSubviews(titleLabel, titleImageView)
        self.addSubview(baseView)
        
        self.baseView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(9)
            $0.trailing.equalToSuperview().inset(9)
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
    
    
    //MARK: - Actions
    
}
