import UIKit
import WeatherKit
import SnapKit
import Then
import CoreLocation

final class MainVC: UIViewController {
    //MARK: - Properties
    private lazy var mainTableView = UITableView()
    
    private lazy var plusImage = UIImageView().then {
        let image = UIImage(systemName: "plus.circle.fill")?.withRenderingMode(.alwaysTemplate)
        $0.image = image
        $0.tintColor = Constants.greenColor
        $0.isUserInteractionEnabled = true
        $0.contentMode = .scaleAspectFit
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(plusButtonTapped(_:))))
    }
    
    lazy var myViewModel = MyViewModel()
        
    private lazy var locationViewModel = LocationViewModel()
    
    //MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureMainVCUI()
        self.settingMainVCNav()
        self.settingTV()
    }
    //MARK: - Actions
    @objc func plusButtonTapped(_ sender: UIButton) {
        let addVC = AddVC()
        addVC.myViewModel = self.myViewModel
        addVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(addVC, animated: true)
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension MainVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myViewModel.getWeatherCellCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherCell.identifier, for: indexPath) as! WeatherCell
        cell.selectionStyle = .none

        self.myViewModel.setSelectedCellIndex(cellForRowAt: indexPath)
        cell.myViewModel = self.myViewModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.myViewModel.setSelectedCellIndex(cellForRowAt: indexPath)
        self.myViewModel.setSelectedLocation(cellForRowAt: indexPath)
        
        let detailVC = DetailVC()
        detailVC.myViewModel = self.myViewModel
        detailVC.hidesBottomBarWhenPushed = true
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            self.myViewModel.removeData(index: indexPath.row) {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}

extension MainVC {
    private func configureMainVCUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.mainTableView)
        self.mainTableView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func settingMainVCNav() {
        let navTitleAttributes = [ NSAttributedString.Key.font: UIFont(name: "NeoDunggeunmoPro-Regular", size: 34.0)!]
        let navTitleAttributedStr = NSAttributedString(string: "날씨보개", attributes: navTitleAttributes)
        
        let navTitleLabel = UILabel().then {
            $0.textAlignment = .left
            $0.attributedText = navTitleAttributedStr
            $0.sizeToFit()
        }
        
        let mainVCNavLeftBarButtonItem = UIBarButtonItem(customView: navTitleLabel)
        navigationItem.leftBarButtonItem = mainVCNavLeftBarButtonItem

        self.plusImage.frame = CGRect(x: 0, y: 0, width: 26, height: 26)
        let rightBarButtonItem = UIBarButtonItem(customView: plusImage)
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
    }
    
    private func settingTV() {
        self.mainTableView.dataSource = self
        self.mainTableView.delegate = self
        self.mainTableView.separatorStyle = .none
        self.mainTableView.register(WeatherCell.self, forCellReuseIdentifier: WeatherCell.identifier)
        self.mainTableView.rowHeight = self.view.frame.height/7
        self.mainTableView.translatesAutoresizingMaskIntoConstraints = false
    }
}
