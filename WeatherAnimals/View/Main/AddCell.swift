import UIKit

final class AddCell: UITableViewCell {
//MARK: - Properties
    lazy var titleLabel = UILabel().then {
        $0.text = "지역 타이틀"
        $0.font = UIFont.neoDeungeul(size: 15)
        $0.textColor = .black
    }
    
    private lazy var addButton = UIButton().then {
        $0.setTitle("추가", for: .normal)
        $0.setTitle("추가됨", for: .highlighted)
        $0.titleLabel?.font = .neoDeungeul(size: 14)
        $0.layer.cornerRadius = 4
        $0.clipsToBounds = true
        $0.backgroundColor = Constants.greenColor
        $0.setTitleColor(.white, for: .normal)
        $0.setTitleColor(.darkGray, for: .highlighted)
    }
    
    private lazy var deleteButton = UIButton().then {
        $0.setTitle("삭제", for: .normal)
        $0.titleLabel?.font = .neoDeungeul(size: 14)
        $0.layer.cornerRadius = 4
        $0.clipsToBounds = true
        $0.backgroundColor = .systemRed
        $0.setTitleColor(.white, for: .normal)
    }
    
//MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.configureUI()
        
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
 
//MARK: - Helpers
    private func configureUI() {
        self.contentView.addSubviews(titleLabel, addButton, deleteButton)
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
        }
        
        self.addButton.snp.makeConstraints {
            $0.width.equalTo(80)
            $0.height.equalTo(40)
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(self.contentView.snp.centerX)
        }
        
        self.deleteButton.snp.makeConstraints {
            $0.width.equalTo(80)
            $0.height.equalTo(40)
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(self.addButton.snp.trailing).offset(20)
        }
    }
}
