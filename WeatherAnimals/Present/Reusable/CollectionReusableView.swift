import UIKit

class CollectionReusableView: UICollectionReusableView {
    static let identifier = "CollectionReusableView"
    //MARK: - Properties
   
    
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
        self.backgroundColor = .systemGray4
    }
    
    
    //MARK: - Actions
    
}
