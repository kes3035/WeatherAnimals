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
    
    lazy var weatherViewModel = WeatherViewModel()
    
    private lazy var locationViewModel = LocationViewModel()
    
    //MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.weatherViewModel.creatLocation()
        self.configureUI()                              //UI결정
        self.settingNav()                               //Nav세팅
        self.settingTV()                                //TableView세팅
//        self.settingLocation()                          //사용자 위치 세팅
    }
    
    //MARK: - Helpers
    
    
    //MARK: - Actions
    @objc func plusButtonTapped(_ sender: UIButton) {
        let addVC = AddVC()
        addVC.hidesBottomBarWhenPushed = true
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(addVC, animated: true)
        }
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension MainVC: UITableViewDataSource, UITableViewDelegate {
    
    //테이블 뷰의 셀 갯수를 리턴하는 함수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let myLocation = self.weatherViewModel.myLocation else { return 1 }
        
//        guard let myDatas = self.weatherViewModel.myDatas else { return 1 }
//        
//        return myDatas.count + 1
        return myViewModel.getWeatherCellCount()
    }
    
    
    //테이블 뷰의 셀을 리턴하는 함수
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherCell.identifier, for: indexPath) as! WeatherCell
        cell.selectionStyle = .none
        

        
//        guard let myDatas = self.weatherViewModel.myDatas else { return cell }
//        DispatchQueue.global(qos: .default).async {
//            
//            
//            self.weatherViewModel.configureWeatherCell(with: myDatas, cellForRowAt: indexPath.row) { weatherData, locationTitle in
//                cell.configureUIWithData(weatherData, locationTitle)
//            }
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let location = self.weatherViewModel.creatLocation(cellForRowAt: indexPath.row)
        
        DispatchQueue.global().async {
            
            self.weatherViewModel.getDetailVCWeather(location: location) { [weak self] weatherViewModel in
                DispatchQueue.main.async {
                    let detailVC = DetailVC()
                    detailVC.weatherViewModel = weatherViewModel
                    detailVC.hidesBottomBarWhenPushed = true
                    self?.navigationController?.pushViewController(detailVC, animated: true)
                }
            }
            
        }
    }
}

extension MainVC {
    
    // UI설정
    private func configureUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(mainTableView)
        self.mainTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // NavigationController 설정
    private func settingNav() {

        let navTitleAttributes = [ NSAttributedString.Key.font: UIFont(name: "NeoDunggeunmoPro-Regular", size: 34.0)!]
        let navTitleAttributedStr = NSAttributedString(string: "날씨보개", attributes: navTitleAttributes)
        
        let navTitleLabel = UILabel().then {
            $0.textAlignment = .left
            $0.attributedText = navTitleAttributedStr
            $0.sizeToFit()
        }
//        navTitleLabel.textAlignment = .left
//        navTitleLabel.attributedText = navTitleAttributedStr
//        navTitleLabel.sizeToFit()
        
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
