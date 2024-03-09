import UIKit
import WeatherKit

final class DetailVC: UIViewController {
    //MARK: - Properties
    
    // 콜렉션 뷰를 위한 FlowLayout
    private let flowLayout = CustomFlowLayout()

    
    // 디테일VC의 최상단 화면을 구성하는 TopView
    private let topView = DetailView()
    
    
    // 콜렉션 뷰
    private lazy var detailCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .white
        $0.showsVerticalScrollIndicator = false
        $0.register(HourCell.self, forCellWithReuseIdentifier: HourCell.identifier) //CurrentCell 등록
        $0.register(WeekCell.self, forCellWithReuseIdentifier: WeekCell.identifier) //WeekCell 등록
        $0.register(AirQualityCell.self, forCellWithReuseIdentifier: AirQualityCell.identifier) //AirQualityCell 등록
        $0.register(UltravioletCell.self, forCellWithReuseIdentifier: UltravioletCell.identifier) //AirQualityCell 등록
        $0.register(SunsetCell.self, forCellWithReuseIdentifier: SunsetCell.identifier) //AirQualityCell 등록
        $0.register(ApparentTempCell.self, forCellWithReuseIdentifier: ApparentTempCell.identifier) //AirQualityCell 등록
        $0.register(RainFallCell.self, forCellWithReuseIdentifier: RainFallCell.identifier) //AirQualityCell 등록
        $0.register(HumidityCell.self, forCellWithReuseIdentifier: HumidityCell.identifier) //HumidityCell 등록
        $0.register(CollectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionHeader.identifier) //Header 등록
        
    }
    
    private lazy var cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(buttonTapped(_:)))
    
    private lazy var addButton = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(buttonTapped(_:)))
    
    
    // 뷰모델
    var weatherViewModel: WeatherViewModel! {
        didSet {
            DispatchQueue.main.async {
                self.detailCollectionView.reloadData()
                self.configureTopView()
            }
        }
    }
    
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.weatherViewModel = WeatherViewModel()
      
        guard let location = self.weatherViewModel.location else { return }
        
        self.weatherViewModel.getDetailVCWeather(location: location)
        
        self.weatherViewModel.getAirQualityCondition(location: location)

        self.configureUI()

        self.settingFlowLayout()
    }
    
    //MARK: - Helpers
    private func configureUI() {
        //최초UI 구성
        self.view.backgroundColor = .white
        
        self.view.addSubviews(detailCollectionView, topView)
        
        self.topView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(140)
        }
        
        self.detailCollectionView.snp.makeConstraints{
            $0.top.equalTo(self.topView.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configureTopView() {
        guard let dayWeather = weatherViewModel.dayWeathers,
              let current = weatherViewModel.currentWeather else { return }
        DispatchQueue.main.async {
            self.topView.tempLabel.text = String(round(current.temperature.value)) +  "°"
            self.topView.highestTempLabel.text = "최고 : " + String(round(dayWeather[0].highTemperature.value)) +  "°"
            self.topView.lowestTempLabel.text = "최저 : " + String(round(dayWeather[0].lowTemperature.value)) +  "°"
        }
    }
    
    private func settingNav() {
        let rightButton = UIButton().then {
            $0.setImage(UIImage(systemName: "ellipsis"), for: .normal)
            $0.imageView?.tintColor = Constants.greenColor
            $0.imageView?.contentMode = .scaleAspectFit
            $0.backgroundColor = .systemGray4
            $0.layer.cornerRadius = 5
        }
        
        rightButton.frame = CGRect(x: 0, y: 0, width: 34, height: 32)
        let rightBarButton = UIBarButtonItem(customView: rightButton)
        self.navigationItem.rightBarButtonItem = rightBarButton
        
    }
    
    private func settingFlowLayout() {
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionHeadersPinToVisibleBounds = true
        
    }
    
    func configureNavButton() {
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func buttonTapped(_ sender: UIBarButtonItem) {
        
        guard let titleLabel = sender.title else { return }
        switch titleLabel {
        case "취소":
            self.dismiss(animated: true)
        case "추가":
            print("addButtonTapped")
            self.weatherViewModel.setValue(self.weatherViewModel)
            self.dismiss(animated: true)
        default:
            break
        }
    }
    
}
//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension DetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int { return 5 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0, 1:
            return 1
        case 2, 3, 4:
            return 2
        default:
            return 1
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourCell.identifier, for: indexPath) as! HourCell
            
            cell.weatherViewModel = self.weatherViewModel

            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeekCell.identifier, for: indexPath) as! WeekCell
            
            cell.weatherViewModel = self.weatherViewModel

            
            
            return cell
        case 2:
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AirQualityCell.identifier, for: indexPath) as! AirQualityCell
                
                cell.weatherViewModel = self.weatherViewModel
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UltravioletCell.identifier, for: indexPath) as! UltravioletCell
                
                cell.weatherViewModel = self.weatherViewModel
                return cell
            }
        case 3:
            if indexPath.row == 0 {
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SunsetCell.identifier, for: indexPath) as! SunsetCell
                cell.weatherViewModel = self.weatherViewModel

                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ApparentTempCell.identifier, for: indexPath) as! ApparentTempCell
                cell.weatherViewModel = self.weatherViewModel

                return cell
            }
        case 4:
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RainFallCell.identifier, for: indexPath) as! RainFallCell
                cell.weatherViewModel = self.weatherViewModel
                
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HumidityCell.identifier, for: indexPath) as! HumidityCell
                cell.weatherViewModel = self.weatherViewModel
                return cell
            }
        default:
            return UICollectionViewCell()
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension DetailVC: UICollectionViewDelegateFlowLayout {
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: self.view.frame.width, height: 100)
        case 1:
            return CGSize(width: self.view.frame.width, height: 388)
        case 2, 3, 4:
            
            let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            let width = collectionView.frame.width
            let itemsPerRow: CGFloat = 2
            let widthPadding = sectionInsets.left * (itemsPerRow + 1)
//            let itemsPerColumn: CGFloat = 1
            let cellWidth = (width - widthPadding) / itemsPerRow
            let size = CGSize(width: cellWidth, height: cellWidth - 30)
            return size
        default:
            return CGSize(width: 100, height: 100)
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionHeader,
              let firstHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                           withReuseIdentifier: CollectionHeader.identifier,
                                                                           for: indexPath)  as? CollectionHeader

        else { return UICollectionReusableView()}
        firstHeader.section = indexPath.section

        return firstHeader
    }
}



extension DetailVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == self.detailCollectionView else { return }
    }
}



