import UIKit
import WeatherKit
import SnapKit
import Then
import CoreLocation


final class MainVC: UIViewController {
//MARK: - Properties
    private lazy var tableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
    }
    
    private lazy var locationTitle = UILabel().then {
        $0.text = "대한민국 용인시"
    }
    
    private lazy var currentTemp = UILabel().then {
        $0.text = "17"
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    
    private lazy var plusButton = UIButton().then {
        $0.tintColor = Constants.greenColor
        $0.addTarget(self, action: #selector(plusButtonTapped(_:)), for: .touchUpInside)
    }
    
    
    var weatherViewModel = WeatherViewModel()
    
    
    
    
//MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        settingNav()
        settingTableView()
//        self.weatherViewModel.getCurrentWeather(for: weatherViewModel.yongin)

    }
    
    
    
//MARK: - Helpers
    private func configureUI() {
        
        
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(self.view.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func settingNav() {
        let attributes = [
            NSAttributedString.Key.font: UIFont(name: "NeoDunggeunmoPro-Regular", size: 34.0)!]
        let attributedString = NSAttributedString(string: "날씨보개", attributes: attributes)
        let titleLabel = UILabel()
        titleLabel.textAlignment = .left
        titleLabel.attributedText = attributedString
        titleLabel.sizeToFit()
        let titleItem = UIBarButtonItem(customView: titleLabel)
        
        
        navigationItem.leftBarButtonItem = titleItem
    }
    
    private func settingTableView() {
        tableView.register(WeatherCell.self, forCellReuseIdentifier: WeatherCell.identifier)
        tableView.rowHeight = self.view.frame.height/7
    }
    
    
    
    
    
//MARK: - Actions
    @objc func plusButtonTapped(_ sender: UIButton) {
        print("디버깅: plus 버튼 눌림")
    }


}

//MARK: - Extensions
extension MainVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherCell.identifier, for: indexPath) as! WeatherCell
        cell.currentWeather = self.weatherViewModel.currentWeather
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailVC()
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
}
