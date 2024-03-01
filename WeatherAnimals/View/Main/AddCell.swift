import UIKit

final class AddCell: UITableViewCell {
//MARK: - Properties
    lazy var titleLabel = UILabel().then {
        $0.text = "지역 타이틀"
        $0.font = UIFont.neoDeungeul(size: 15)
        $0.textColor = .black
    }
    
    
//MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.configureUI()
        
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
 
//MARK: - Helpers
    private func configureUI() {
        self.contentView.addSubviews(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
        }
    }
    
}
