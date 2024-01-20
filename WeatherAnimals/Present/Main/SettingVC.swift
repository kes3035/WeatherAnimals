import UIKit

final class SettingVC: UIViewController {
//MARK: - Properties
    private lazy var settingTableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.rowHeight = 80
        $0.isScrollEnabled = false
        $0.register(SettingCell.self, forCellReuseIdentifier: "SettingCell")
    }
    
    
    
    
    
    
//MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        settingNav()
        
    }
    
//MARK: - Helpers
    private func configureUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(settingTableView)
        
        settingTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
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
    
//MARK: - Actions
    

}


//MARK: - UITableViewDelegate, UITableViewDataSource
extension SettingVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
        
        
        return cell
    }
    
    
    
}

