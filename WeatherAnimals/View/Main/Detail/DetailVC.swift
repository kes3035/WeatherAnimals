import UIKit
import WeatherKit

final class DetailVC: UIViewController {
    //MARK: - Properties
    
    // 콜렉션 뷰를 위한 FlowLayout
    private let flowLayout = UICollectionViewFlowLayout().then {
        $0.estimatedItemSize = .zero
    }
    
    // 디테일VC의 최상단 화면을 구성하는 TopView
    private let topView = DetailView()
    
    // 콜렉션 뷰
    private lazy var detailCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .white
        $0.showsVerticalScrollIndicator = false
        
        $0.register(HourCell.self, forCellWithReuseIdentifier: HourCell.identifier)
        $0.register(WeekCell.self, forCellWithReuseIdentifier: WeekCell.identifier)
        $0.register(AirQualityCell.self, forCellWithReuseIdentifier: AirQualityCell.identifier)
        $0.register(UltravioletCell.self, forCellWithReuseIdentifier: UltravioletCell.identifier)
        $0.register(SunsetCell.self, forCellWithReuseIdentifier: SunsetCell.identifier)
        $0.register(ApparentTempCell.self, forCellWithReuseIdentifier: ApparentTempCell.identifier)
        $0.register(RainFallCell.self, forCellWithReuseIdentifier: RainFallCell.identifier)
        $0.register(HumidityCell.self, forCellWithReuseIdentifier: HumidityCell.identifier)
        $0.register(CollectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionHeader.identifier) 
        
    }
    
    private lazy var cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(buttonTapped(_:)))
    
    private lazy var addButton = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(buttonTapped(_:)))
    
    
    // 뷰모델
    lazy var weatherViewModel = WeatherViewModel() {
        didSet {
            DispatchQueue.main.async {
                self.detailCollectionView.reloadData()
            }
        }
    }
    
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()                  //UI결정
        self.settingFlowLayout()            //CollectionView FlowLayout세팅
        self.configureTopView()
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
        let (currentTemp, highTemp, lowTemp) = self.weatherViewModel.configureTopView()
        DispatchQueue.main.async {
            self.topView.tempLabel.text = currentTemp
            self.topView.highestTempLabel.text = highTemp
            self.topView.lowestTempLabel.text = lowTemp
        }
    }
    
    private func settingFlowLayout() {
        self.flowLayout.scrollDirection = .vertical
        self.flowLayout.sectionHeadersPinToVisibleBounds = true
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
        case 2,3,4:
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
            cell.tenDaysTempView.rowHeight = self.detailCollectionView.frame.height/14.5
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
        // 양옆위아래에서 10만큼 유격
        let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        // 콜렉션뷰 너비, 높이(view너비, 높이)
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        
        // 행별로 존재하는 아이템 수
      
        
        
        
        switch indexPath.section {
        case 0:
            // 시간별 날씨 셀
            let itemsPerRow: CGFloat = 1
            let itemsPerColumn: CGFloat = 1
            let widthPadding = sectionInsets.left * (itemsPerRow + 1)
            
            let cellWidth = (width - widthPadding) / itemsPerRow
            return CGSize(width: cellWidth, height: collectionView.frame.height/7)
        case 1:
            // 주간 날씨 셀
            let itemsPerRow: CGFloat = 1
            let itemsPerColumn: CGFloat = 1
            let widthPadding = sectionInsets.left * (itemsPerRow + 1)
            
            let cellWidth = (width - widthPadding) / itemsPerRow
            return CGSize(width: cellWidth, height: collectionView.frame.height/1.45)
        case 2,3,4:
            // 2, 3, 4번 셀
            // 양옆위아래에서 10만큼 유격
            let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            
            // 콜렉션뷰 너비, 높이(view너비, 높이)
            let width = collectionView.frame.width
            let height = collectionView.frame.height
            
            // 행별로 존재하는 아이템 수
            let itemsPerRow: CGFloat = 2
            let itemsPerColumn: CGFloat = 1

            let widthPadding = sectionInsets.left * (itemsPerRow + 1)
            let heightPadding = sectionInsets.top * (itemsPerColumn + 1)
            
            let cellWidth = (width - widthPadding) / itemsPerRow
            let cellHeight = (height - heightPadding) / itemsPerColumn
            
            let size = CGSize(width: cellWidth, height: cellWidth - 30)
            return size
        default:
            return CGSize(width: collectionView.frame.width, height: 100)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 30)
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



