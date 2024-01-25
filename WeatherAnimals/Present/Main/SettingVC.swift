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
//        $0.isScrollEnabled = false
        $0.register(SettingCell.self, forCellReuseIdentifier: "SettingCell")
    }
    
    private lazy var headerView = UIView().then {
        $0.backgroundColor = .darkGray
    }
    
    
    
    
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
        self.settingTableView.tableHeaderView = self.headerView
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
        
        
        return cell
    }
    
    
    
}

