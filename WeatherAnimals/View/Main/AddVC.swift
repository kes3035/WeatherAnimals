import CoreLocation
import UIKit
import MapKit

final class AddVC: UIViewController {
    //MARK: - Properties
    private var searchCompleter = MKLocalSearchCompleter()
    
    private var searchRegionBasedLatLong: MKCoordinateRegion = MKCoordinateRegion(MKMapRect.world)
    
    private var searchResultsArr = [MKLocalSearchCompletion]()
    
    private var searchResultTableView = UITableView()
        
    private var searchController = UISearchController(searchResultsController: nil)
    
    private var searchedPlace: MKMapItem? { didSet { searchResultTableView.reloadData() } }
    
    private var localSearch: MKLocalSearch? {
        willSet {
            searchedPlace = nil
            localSearch?.cancel()
        }
    }
    
    private lazy var myViewModel = MyViewModel()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAddVCUI()
        settingNav()
        settingSearchResultTableView()
        settingSearchCompleter()
        settingSearchController()
    }
}

//MARK: - UITableViewDelegate
extension AddVC: UITableViewDelegate {
    //tableView의 셀이 선택되었을 때 실행되는 메서드
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedResult = searchResultsArr[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: selectedResult)
        let search = MKLocalSearch(request: searchRequest)
        
        let detailVC = DetailVC()
        detailVC.configureNavButton()
        DispatchQueue.global().async {
            search.start { response, error in
                guard error == nil else { return }
                guard let placemark = response?.mapItems[0].placemark else { return }
                let location = CLLocation(latitude: placemark.coordinate.latitude, longitude: placemark.coordinate.longitude)
                
                
                self.myViewModel.setWeatherDataForDetailVC(for: location)
                
                self.myViewModel.didFetchWeather = {
                    detailVC.myViewModel = self.myViewModel
                    DispatchQueue.main.async {
                        DispatchQueue.main.async {
                            let nav = UINavigationController(rootViewController: detailVC)
                            self.present(nav, animated: true)
                        }
                    }
                }
            }
        }
    }
}
//MARK: - UITableViewDataSource
extension AddVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultsArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddCell", for: indexPath) as! AddCell
        let searchResult = searchResultsArr[indexPath.row]
        cell.titleLabel.font = UIFont.neoDeungeul(size: 16)
        cell.titleLabel.textColor = .gray
        if let highlightText = searchController.searchBar.text {
            DispatchQueue.main.async {
                cell.titleLabel.setHighlighted(searchResult.title, with: highlightText)
            }
        }

        return cell
    }
}

//MARK: - MKLocalSearchCompleterDelegate
extension AddVC: MKLocalSearchCompleterDelegate {

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResultsArr = completer.results
        searchResultTableView.reloadData()
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        if let error = error as NSError? {
            print("MKLocalSearchCompleter encountered an error: \(error.localizedDescription). The query fragment is: \"\(completer.queryFragment)\"")
        }
    }
}

extension AddVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        // 검색어에 따라 검색을 수행하고 결과를 업데이트하는 로직을 작성합니다.
        // 이 부분에서 검색 결과를 업데이트하고 테이블 뷰를 다시 로드해야 합니다.
        // searchCompleter.queryFragment = searchText (위 코드에서 사용된 searchCompleter와 유사한 로직을 작성)
        // searchResults = ... (검색 결과 업데이트)
        // resultTableView.reloadData() (테이블 뷰 다시 로드)
        if searchText.isEmpty {
            searchResultsArr.removeAll()
            searchResultTableView.reloadData()
        }
        searchCompleter.queryFragment = searchText
    }
}

extension AddVC {
    private func configureAddVCUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.searchResultTableView)
        self.searchResultTableView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func settingSearchController() {
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "도시 검색"
        self.searchController.searchBar.searchTextField.font = UIFont.neoDeungeul(size: 15)
    
        navigationItem.searchController = self.searchController
        definesPresentationContext = true
    }
    
    private func settingSearchResultTableView() {
        self.searchResultTableView.delegate = self
        self.searchResultTableView.dataSource = self
        self.searchResultTableView.rowHeight = 60
        self.searchResultTableView.register(AddCell.self, forCellReuseIdentifier: "AddCell")
    }
    private func settingSearchCompleter() {
        self.searchCompleter.delegate = self
        self.searchCompleter.resultTypes = .address
        self.searchCompleter.region = searchRegionBasedLatLong
    }
    
    private func settingNav() {
        self.navigationItem.title = "지역 검색/추가"
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.neoDeungeul(size: 32)]
        self.navigationController?.navigationBar.titleTextAttributes = attributes as [NSAttributedString.Key : Any]
        self.navigationController?.navigationBar.largeTitleTextAttributes = attributes as [NSAttributedString.Key : Any]
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
}


