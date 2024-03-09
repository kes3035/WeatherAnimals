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
    
    var weatherViewModel: WeatherViewModel! {
        didSet {
            self.weatherViewModel.fetchMyData()
            DispatchQueue.main.async {
                self.mainTableView.reloadData()
            }
        }
    }
    
    private var locationViewModel: LocationViewModel!
    
    //MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.weatherViewModel = WeatherViewModel()
//        self.weatherViewModel.getMainVCWeather(location: self.weatherViewModel.yongin)
        self.configureUI()
        self.settingNav()
        self.settingTV()
        self.settingLocation()
    }
    
    //MARK: - Helpers
    private func configureUI() {
        // Basic Setting For Drawing View
        self.view.backgroundColor = .white
        self.view.addSubview(mainTableView)
        self.mainTableView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func settingNav() {
        // Navigation Setting For Custom Title Font
        let attributes = [
            NSAttributedString.Key.font: UIFont(name: "NeoDunggeunmoPro-Regular", size: 34.0)!]
        let attributedString = NSAttributedString(string: "날씨보개", attributes: attributes)
        let titleLabel = UILabel()
        titleLabel.textAlignment = .left
        titleLabel.attributedText = attributedString
        titleLabel.sizeToFit()
        let leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.leftBarButtonItem = leftBarButtonItem

        // Navigation Setting For rightBarButtonItem
        self.plusImage.frame = CGRect(x: 0, y: 0, width: 26, height: 26)
        let rightBarButtonItem = UIBarButtonItem(customView: plusImage)
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    private func settingTV() {
        // Basic Setting For Main TableView
        self.mainTableView.dataSource = self
        self.mainTableView.delegate = self
        self.mainTableView.separatorStyle = .none
        mainTableView.register(WeatherCell.self, forCellReuseIdentifier: WeatherCell.identifier)
        mainTableView.rowHeight = self.view.frame.height/7
    }
    
    private func settingLocation() {
        // When App Run for the first time, User needs to allow using their location
        self.locationViewModel = LocationViewModel()
        self.locationViewModel.fetchLocation { [weak self] (location, error) in
            self?.locationViewModel.loc = CLLocation(latitude: location?.latitude ?? 0.0, longitude: location?.longitude ?? 0.0)
        }
    }
    
    //MARK: - Actions
    @objc func plusButtonTapped(_ sender: UIButton) {
        // When Plus Button Tapped, AddVC will be pushed
        let addVC = AddVC()
//        let nav = UINavigationController(rootViewController: addVC)
        addVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(addVC, animated: true)
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension MainVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Returns the count of locations user added
        guard let myDatas = self.weatherViewModel.myDatas else { return 0 }
        
        return myDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Data Transport to Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherCell.identifier, for: indexPath) as! WeatherCell
        cell.selectionStyle = .none
        guard let myDatas = self.weatherViewModel.myDatas else { return cell }
        
        let location = CLLocation(latitude: myDatas[indexPath.row].latitude, longitude: myDatas[indexPath.row].longitude)
        
        self.weatherViewModel.getMainVCWeather(location: location )

        self.weatherViewModel.didChangeWeather = { [weak self] weatherViewModel in
            
            cell.weatherViewModel = weatherViewModel
            self?.weatherViewModel = weatherViewModel
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let detailVC = DetailVC()
        guard let myDatas = self.weatherViewModel.myDatas else { return }
        let location = CLLocation(latitude: myDatas[indexPath.row].latitude, longitude: myDatas[indexPath.row].longitude)
        self.weatherViewModel.location = location
        detailVC.weatherViewModel = self.weatherViewModel
        detailVC.hidesBottomBarWhenPushed = true
        
        self.weatherViewModel.getDetailVCWeather(location: self.weatherViewModel.yongin)
        self.weatherViewModel.didFetchedWeathers = {
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }
}
