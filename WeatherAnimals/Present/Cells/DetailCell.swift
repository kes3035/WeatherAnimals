import UIKit

final class DetailCell: UICollectionViewCell {
    static let identifier = "DetailCell"
    //MARK: - Properties
    private lazy var baseView = UIView().then {
        $0.backgroundColor = .systemMint

    }
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    //MARK: - Helpers
    private func configureUI() {
        self.contentView.addSubview(baseView)
        self.baseView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    //MARK: - Actions
    
}
