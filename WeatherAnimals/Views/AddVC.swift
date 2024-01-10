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
    private var resultTableView = UITableView(frame: .zero)
    
    //서치바
    private var searchBar = UISearchBar()
    
    //서치바에 검색할 때마다 장소를 가져와서 테이블뷰 업데이트
    private var places: MKMapItem? { didSet { resultTableView.reloadData() } }
    
    private var localSearch: MKLocalSearch? {
        willSet {
            // Clear the results and cancel the currently running local search before starting a new search.
            places = nil
            localSearch?.cancel()
        }
    }
    
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
        self.tabBarController?.tabBar.isHidden = true
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

//MARK: - UITableViewDataSource, UITableViewDelegate

extension AddVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let selectedResult = searchResults[indexPath.row]
       let searchRequest = MKLocalSearch.Request(completion: selectedResult)
       let search = MKLocalSearch(request: searchRequest)

       search.start { response, error in
        guard error == nil else {
            return
        }
        guard let placemark = response?.mapItems[0].placemark else { return }

        self.requestGetWeather(lat: placemark.coordinate.latitude, lon: placemark.coordinate.longitude, location: (placemark.locality ?? placemark.title) ?? "")
       }
   }
}

extension AddVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let searchResult = searchResults[indexPath.row]

        cell.textLabel?.font = .systemFont(ofSize: 16)
        cell.textLabel?.textColor = .gray
        cell.backgroundColor = .clear

        if let highlightText = searchBar.text {
            cell.textLabel?.setHighlighted(searchResult.title, with: highlightText)
        }

        return cell
    }
}
//MARK: - UISearchBarDelegate
extension AddVC: UISearchBarDelegate {
   func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       if searchText.isEmpty {
           searchResults.removeAll()
           resultTableView.reloadData()
       }
       searchCompleter.queryFragment = searchText
   }
}


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
        WeatherService.shared.requestGetWeather(lat: lat, lon: lon, location: location) { [weak self]  weather in
            let vc = MainVC()
            if let weather = weather {
                vc.setData(weather: weather)
                self?.present(vc, animated: true, completion: nil)
            }
        }
    }
}
