import CoreLocation
import UIKit
import MapKit

final class AddVC: UIViewController {
    //MARK: - Properties
    
    //사용자가 제공한 부분 검색 문자열을 기반으로 완료 문자열 목록을 생성하기 위한 객체
    private var searchCompleter = MKLocalSearchCompleter()
    
    //특정 위도와 경도를 중심으로 한 직사각형 지리적 영역
    private var searchRegion: MKCoordinateRegion = MKCoordinateRegion(MKMapRect.world)
    
    //검색된 결과를 담는 배열
    private var searchResults = [MKLocalSearchCompletion]()
    
    //검색된 결과를 표시할 테이블뷰
    private var resultTableView = UITableView()
    
    //서치바
    private var searchBar = UISearchBar()
    
    //서치바에 검색할 때마다 장소를 가져와서 테이블뷰 업데이트
    private var places: MKMapItem? { didSet { resultTableView.reloadData() } }
    
    private var localSearch: MKLocalSearch? {
        willSet {
            // 검색창에 들어오기 전 검색 결과 초기화
            places = nil
            localSearch?.cancel()
        }
    }
    
    private lazy var weatherViewModel = WeatherViewModel()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        settingSearchBar()
        settingTableView()
        settingSearchCompleter()
        
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(resultTableView)
        
        resultTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func settingSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "도시 검색"
        self.navigationItem.titleView = searchBar
        self.searchBar.becomeFirstResponder()
    }
    
    private func settingTableView() {
        resultTableView.delegate = self
        resultTableView.dataSource = self
        resultTableView.rowHeight = 60
        resultTableView.register(AddCell.self, forCellReuseIdentifier: "AddCell")
    }
    private func settingSearchCompleter() {
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .address
        searchCompleter.region = searchRegion
    }
    
}

//MARK: - UITableViewDelegate
extension AddVC: UITableViewDelegate {
    //tableView의 셀이 선택되었을 때 실행되는 메서드
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let selectedResult = searchResults[indexPath.row]
       let searchRequest = MKLocalSearch.Request(completion: selectedResult)
       let search = MKLocalSearch(request: searchRequest)

       search.start { response, error in
        guard error == nil else { return }
           
        guard let placemark = response?.mapItems[0].placemark else { return }

           
        // 여기 메서드를 가지고 날씨 정보를 받아온 뒤에, detailVC로 넘겨서 DetailVC present 하기!!
           
        self.requestGetWeather(lat: placemark.coordinate.latitude, lon: placemark.coordinate.longitude, location: (placemark.locality ?? placemark.title) ?? "")
       }
   }
}
//MARK: - UITableViewDataSource
extension AddVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddCell", for: indexPath) as! AddCell
        let searchResult = searchResults[indexPath.row]
        cell.titleLabel.font = UIFont.neoDeungeul(size: 16)
        cell.titleLabel.textColor = .gray
//        cell.backgroundColor = .clear

        if let highlightText = searchBar.text {
            cell.titleLabel.setHighlighted(searchResult.title, with: highlightText)
        }

        return cell
    }
}
//MARK: - UISearchBarDelegate
extension AddVC: UISearchBarDelegate {
    //searchBar의 텍스트가 변경될 때마다 실행되는 메서드
   func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       if searchText.isEmpty {
           searchResults.removeAll()
           resultTableView.reloadData()
       }
       searchCompleter.queryFragment = searchText
   }
}

//MARK: - MKLocalSearchCompleterDelegate
extension AddVC: MKLocalSearchCompleterDelegate {

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        resultTableView.reloadData()
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        if let error = error as NSError? {
            print("MKLocalSearchCompleter encountered an error: \(error.localizedDescription). The query fragment is: \"\(completer.queryFragment)\"")
        }
    }

}

extension AddVC {
    func requestGetWeather(lat: Double, lon: Double, location: String) {
        let location = CLLocation(latitude: lat, longitude: lon)
        self.weatherViewModel.getWeather(location: location) { weather in
            DispatchQueue.main.async {
                let detailVC = DetailVC()
                detailVC.weather = weather
                self.present(detailVC, animated: true, completion: nil)
            }
        }
    }
}
