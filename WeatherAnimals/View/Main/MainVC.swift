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
    
    lazy var weatherViewModel = WeatherViewModel()
    
    private var locationViewModel: LocationViewModel!
    
    //MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()                              //UI결정
        self.settingNav()                               //Nav세팅
        self.settingTV()                                //TableView세팅
        self.settingLocation()                          //사용자 위치 세팅
    }
    
    //MARK: - Helpers
    private func configureUI() {
        
        self.view.backgroundColor = .white
        self.view.addSubview(mainTableView)
        self.mainTableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
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
        navigationItem.leftBarButtonItem = leftBarButtonItem

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
        
    }
    
    private func settingLocation() {

        self.locationViewModel = LocationViewModel()
        self.locationViewModel.fetchLocation { [weak self] (location, error) in
            self?.locationViewModel.loc = CLLocation(latitude: location?.latitude ?? 0.0, longitude: location?.longitude ?? 0.0)
        }
        
    }
    
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
        guard let myDatas = self.weatherViewModel.myDatas else { return 0 }
        
        return myDatas.count
    }
    
    
    //테이블 뷰의 셀을 리턴하는 함수
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherCell.identifier, for: indexPath) as! WeatherCell
        cell.selectionStyle = .none
                
        let location = self.weatherViewModel.creatLocation(cellForRowAt: indexPath.row)
        
        DispatchQueue.global(qos: .default).async {
            
            self.weatherViewModel.getMainVCWeather(location: location)
            
            self.weatherViewModel.didFetchedWeathers = { [weak self] in
                cell.weatherViewModel = self?.weatherViewModel
                
                DispatchQueue.main.async { self?.mainTableView.reloadData() }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let detailVC = DetailVC()
        detailVC.hidesBottomBarWhenPushed = true

        let location = self.weatherViewModel.creatLocation(cellForRowAt: indexPath.row)
        
        DispatchQueue.global().async {
            self.weatherViewModel.getDetailVCWeather(location: location)
            
            self.weatherViewModel.didChangeWeather = { [weak self] weatherViewModel in
                
                detailVC.weatherViewModel = weatherViewModel
                
                DispatchQueue.main.async {
                    self?.navigationController?.pushViewController(detailVC, animated: true)
                }
            }
        }
    }
}
