import UIKit
import WeatherKit
import SnapKit
import Then
import CoreLocation


final class MainVC: UIViewController {
//MARK: - Properties
    private lazy var tableView = UITableView().then {
        $0.rowHeight = 150
        $0.delegate = self
        $0.dataSource = self
    }
    
    private lazy var locationTitle = UILabel().then {
        $0.text = "대한민국 용인시"
        $0.font = UIFont.systemFont(ofSize: 20)
    }
    
    private lazy var currentTemp = UILabel().then {
        $0.text = "17"
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    
    var weatherViewModel = WeatherViewModel()
    
    
    
    
//MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        settingTableView()
        self.weatherViewModel.getCurrentWeather(for: weatherViewModel.yongin)

    }
    
    
    
//MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        
    }
    private func settingTableView() {
        tableView.register(WeatherCell.self, forCellReuseIdentifier: WeatherCell.identifier)
        
    }
    
    
    
    
    
//MARK: - Actions
    


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
    
    
}
