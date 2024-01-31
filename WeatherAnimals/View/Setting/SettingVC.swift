import UIKit
/*
 0. 앱 설정
  0.0 동물 바꾸기
  0.1 알림 설정

 1. 앱 정보
  1.0 앱에 대하여
  1.1 써드파티 라이브러리
  1.2 개발자 정보
 
 2. 기타
  2.0 개발자에게 커피사주기
  2.1 버그 리포트
 */


final class SettingVC: UIViewController {
//MARK: - Properties
    private lazy var settingTableView = UITableView(frame: .zero, style: .grouped).then {
        $0.delegate = self
        $0.dataSource = self
        $0.rowHeight = 80
        $0.separatorStyle = .none
        $0.register(SettingCell.self, forCellReuseIdentifier: "SettingCell")
    }
    
    private lazy var options: [String] = ["동물 바꾸기", "알림 설정", "앱에 대하여", "써드파티 라이브러리",
                                          "개발자 정보", "개발자에게 커피사주기", "버그 리포트"]
    
    
    
//MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.settingNav()
    }
    
//MARK: - Helpers
    private func configureUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(settingTableView)
        
        self.settingTableView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func settingNav() {
        let attributes = [
            NSAttributedString.Key.font: UIFont(name: "NeoDunggeunmoPro-Regular", size: 34.0)!]
        let attributedString = NSAttributedString(string: "설정", attributes: attributes)
        let titleLabel = UILabel()
        titleLabel.textAlignment = .left
        titleLabel.attributedText = attributedString
        titleLabel.sizeToFit()
        
        let leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
}


//MARK: - UITableViewDelegate, UITableViewDataSource
extension SettingVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 3
        case 2:
            return 2
        default:
            return 2
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
        cell.selectionStyle = .none
        cell.titleLabel.text = self.options[indexPath.row]

        return cell
    }
    
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = TableHeaderView()
        switch section {
        case 0:
            header.titleLabel.text = "앱 설정"
        case 1:
            header.titleLabel.text = "앱 정보"
        case 2:
            header.titleLabel.text = "기타"
        default:
            header.titleLabel.text = "기타"
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
}

