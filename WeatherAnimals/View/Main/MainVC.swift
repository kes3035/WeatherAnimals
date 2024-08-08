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
    
    // 현재까지는 코어 데이터와 유저 데이터를 이용해서 만든 [지역명:위치] 배열만 존재함
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
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(addVC, animated: true)
        }
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
        
        guard let locationByTitle = self.myViewModel.getLocationByTitle(),
              let title = locationByTitle[indexPath.row].keys.first,
              let weathers = self.myViewModel.getWeathers() else { return cell }
        
        
        
        
                
        cell.title = title
        cell.currentWeather = weathers[indexPath.row].currentWeather

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        self.myViewModel.setSelectedCellIndex(cellForRowAt: indexPath)
        
        self.myViewModel.setSelectedLocation(cellForRowAt: indexPath)
        
        self.myViewModel.setWeatherDataForDetailVC()
        
        
        self.myViewModel.didFetchWeather = {
            DispatchQueue.main.async {
                let detailVC = DetailVC()
                detailVC.myViewModel = self.myViewModel
                detailVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        }

    }
}

extension MainVC {
    // UI설정
    private func configureMainVCUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.mainTableView)
        self.mainTableView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    // NavigationController 설정
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
    
    // TableView 설정
    private func settingTV() {
        self.mainTableView.dataSource = self
        self.mainTableView.delegate = self
        self.mainTableView.separatorStyle = .none
        self.mainTableView.register(WeatherCell.self, forCellReuseIdentifier: WeatherCell.identifier)
        self.mainTableView.rowHeight = self.view.frame.height/7
        self.mainTableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // 위치 설정
//    private func settingLocation() {
//        self.locationViewModel.fetchLocation { [weak self] (location, error) in
//            guard let location = location,
//                  let self = self else { return }
//        
//            self.locationViewModel.userLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//            
//        }
//    }
}
