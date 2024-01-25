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
    
    private lazy var plusImage = UIImageView().then {
        let image = UIImage(systemName: "plus.circle.fill")?.withRenderingMode(.alwaysTemplate)
        $0.image = image
        $0.tintColor = Constants.greenColor
        $0.isUserInteractionEnabled = true
        $0.contentMode = .scaleAspectFit
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(plusButtonTapped(_:))))
    }
    
    var weatherViewModel = WeatherViewModel()
    
    var locationViewModel = LocationViewModel()
//MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        settingNav()
        settingTV()
        settingLocation()
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
        let leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        plusImage.frame = CGRect(x: 0, y: 0, width: 26, height: 26)
        let rightBarButtonItem = UIBarButtonItem(customView: plusImage)
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    
    private func settingTV() {
        tableView.register(WeatherCell.self, forCellReuseIdentifier: WeatherCell.identifier)
        tableView.rowHeight = self.view.frame.height/7
    }
    
    
    private func settingLocation() {
        locationViewModel.fetchLocation { [weak self] (location, error) in
            self?.locationViewModel.loc = CLLocation(latitude: location?.latitude ?? 0.0, longitude: location?.longitude ?? 0.0)
        }
    }
    
    
    
    
//MARK: - Actions
    @objc func plusButtonTapped(_ sender: UIButton) {
        let addVC = AddVC()
        addVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(addVC, animated: true)
    }


}

//MARK: - Extensions
extension MainVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherCell.identifier, for: indexPath) as! WeatherCell
        cell.selectionStyle = .none
        self.weatherViewModel.getMainVCWeather(location: self.weatherViewModel.yongin) { cell.weather = $0 }
        return cell
    }
    
    //셀이 선택되었을 때 실행되는 메서드
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailVC()
        self.weatherViewModel.getDetailVCWeather(location: self.weatherViewModel.yongin)
        detailVC.weatherViewModel = self.weatherViewModel
        detailVC.hidesBottomBarWhenPushed = true
        print("디버깅: DetailVC push할 예정")
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
}
