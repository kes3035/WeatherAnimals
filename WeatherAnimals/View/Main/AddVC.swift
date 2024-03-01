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
        
    private var searchController = UISearchController(searchResultsController: nil)
    
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
        settingNav()
        settingTableView()
        settingSearchCompleter()
        settingSearchController()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//         super.viewWillAppear(animated)
//         self.navigationItem.hidesBackButton = true
//    }
    
    //MARK: - Helpers
    private func configureUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(resultTableView)
        resultTableView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func settingSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "도시 검색"
        searchController.searchBar.searchTextField.font = UIFont.neoDeungeul(size: 15)
    
        navigationItem.searchController = searchController
        definesPresentationContext = true
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
    
    private func settingNav() {
        self.navigationItem.title = "지역 검색/추가"
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.neoDeungeul(size: 32)]
        self.navigationController?.navigationBar.titleTextAttributes = attributes as [NSAttributedString.Key : Any]
        self.navigationController?.navigationBar.largeTitleTextAttributes = attributes as [NSAttributedString.Key : Any]
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
}

//MARK: - UITableViewDelegate
extension AddVC: UITableViewDelegate {
    //tableView의 셀이 선택되었을 때 실행되는 메서드
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedResult = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: selectedResult)
        let search = MKLocalSearch(request: searchRequest)
        
//        search.start { response, error in
//            guard error == nil else { return }
//            guard let placemark = response?.mapItems[0].placemark else { return }
//        }
        let detailVC = DetailVC()
        detailVC.configureNavButton()
        let nav = UINavigationController(rootViewController: detailVC)
        self.present(nav, animated: true)
        
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
        searchResults = completer.results
        resultTableView.reloadData()
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
            searchResults.removeAll()
            resultTableView.reloadData()
        }
        searchCompleter.queryFragment = searchText
    }
}
