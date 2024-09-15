import UIKit
import WeatherKit

final class DetailVC: UIViewController {
    //MARK: - Properties
    
    private lazy var detailVCFlowLayout = UICollectionViewFlowLayout()
    
    private lazy var detailVCTopView = DetailView()
    
    // 콜렉션 뷰
    private lazy var detailCollectionView = UICollectionView(frame: .zero, collectionViewLayout: detailVCFlowLayout).then {
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
    
    private lazy var cancelButton = UIBarButtonItem(title: "취소",
                                                    style: .plain,
                                                    target: self,
                                                    action: #selector(buttonTapped(_:)))
    
    private lazy var addButton = UIBarButtonItem(title: "추가",
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(buttonTapped(_:)))
    
    private let itemsInSection = [1, 1, 2, 2, 2]

    var myWeather: MyWeather? {
        didSet {
            DispatchQueue.main.async { self.detailCollectionView.reloadData() }
        }
    }
    
    lazy var myViewModel = MyViewModel() {
        didSet {
            DispatchQueue.main.async {
                self.detailCollectionView.reloadData()
            }
        }
    }
    
    var isFromAddVC: Bool = false
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureDetailVCUI()                  //UI결정
        self.settingFlowLayout()            //CollectionView FlowLayout세팅
        self.configureTopView()
    }
    
    //MARK: - Helpers
    @objc func buttonTapped(_ sender: UIBarButtonItem) {
        guard let titleLabel = sender.title else { return }
        switch titleLabel {
        case "취소":
            self.dismiss(animated: true)
        case "추가":
            // 수정할 것
            self.myViewModel.addWeatherModelIntoLocal()
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
        return self.itemsInSection[section]
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = SectionType.section(for: indexPath.section),
              let myWeather = self.myWeather else {
            return UICollectionViewCell()
        }
        
        switch section {
        case .hour:
            return configureHourCell(collectionView, indexPath, myWeather)
        case .week:
            return configureWeekCell(collectionView, indexPath, myWeather)
        case .airQuality:
            return configureAirQualityCell(collectionView, indexPath, myWeather)
        case .sunset:
            return configureSunsetCell(collectionView, indexPath, myWeather)
        case .rainFall:
            return configureRainFallCell(collectionView, indexPath, myWeather)
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
            let widthPadding = sectionInsets.left * (itemsPerRow + 1) // 20
            let cellWidth = (width - widthPadding) / itemsPerRow      // width-20
            
            return CGSize(width: cellWidth, height: height/7)
        case 1:
            // 주간 날씨 셀
            let itemsPerRow: CGFloat = 1
            let widthPadding = sectionInsets.left * (itemsPerRow + 1)
            let cellWidth = (width - widthPadding) / itemsPerRow
            
            return CGSize(width: cellWidth, height: height/1.45)
        case 2,3,4:
            // 2, 3, 4번 셀
            // 행별로 존재하는 아이템 수
            let itemsPerRow: CGFloat = 2
            let itemsPerColumn: CGFloat = 1
              
            let widthPadding = sectionInsets.left * (itemsPerRow + 1)
            
            let cellWidth = (width - widthPadding) / itemsPerRow
//            let cellHeight = (height - heightPadding) / itemsPerColumn
            
            let size = CGSize(width: cellWidth, height: cellWidth - 30)
            return size
        default:
            return CGSize(width: width, height: 100)
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

extension DetailVC {
    private func configureDetailVCUI() {
        //최초UI 구성
        self.view.backgroundColor = .white
        
        self.view.addSubviews(self.detailCollectionView, self.detailVCTopView)
        
        self.detailVCTopView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(self.view.frame.height/5.3)
        }
        
        self.detailCollectionView.snp.makeConstraints {
            $0.top.equalTo(self.detailVCTopView.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configureTopView() {
        guard !isFromAddVC else {
            guard let temporaryWeather = self.myViewModel.getTemporaryWeatherForDetailVC() else { return }
            
            let currentTemp = String(round(temporaryWeather.currentWeather.temperature.value)) +  "°"
            let highTemp = "최고 : " + String(round(temporaryWeather.dailyWeathers[0].highTemperature.value)) +  "°"
            let lowTemp = "최저 : " + String(round(temporaryWeather.dailyWeathers[0].lowTemperature.value)) +  "°"
            
            DispatchQueue.main.async {
                self.detailVCTopView.tempLabel.text = currentTemp
                self.detailVCTopView.highestTempLabel.text = highTemp
                self.detailVCTopView.lowestTempLabel.text = lowTemp
                
            }
            
            return
        }
        guard let weathers = self.myViewModel.getWeathers(),
              let selectedIndex = self.myViewModel.getSelectedIndex() else { return }
        
        let weather = weathers[selectedIndex]
        let currentTemp = String(round(weather.currentWeather.temperature.value)) +  "°"
        let highTemp = "최고 : " + String(round(weather.dailyWeathers[0].highTemperature.value)) +  "°"
        let lowTemp = "최저 : " + String(round(weather.dailyWeathers[0].lowTemperature.value)) +  "°"
        
        DispatchQueue.main.async {
            self.detailVCTopView.tempLabel.text = currentTemp
            self.detailVCTopView.highestTempLabel.text = highTemp
            self.detailVCTopView.lowestTempLabel.text = lowTemp
            
        }
    }
    
    private func settingFlowLayout() {
        self.detailVCFlowLayout.scrollDirection = .vertical
        self.detailVCFlowLayout.sectionHeadersPinToVisibleBounds = true
    }
    
    func configureNavButton() {
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    // 각 섹션에 대한 셀 구성 메서드
    private func configureHourCell(_ collectionView: UICollectionView, _ indexPath: IndexPath, _ myWeather: MyWeather) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourCell.identifier, for: indexPath) as! HourCell
        //cell.myViewModel = self.myViewModel
        cell.myWeather = myWeather
        return cell
    }
    
    private func configureWeekCell(_ collectionView: UICollectionView, _ indexPath: IndexPath, _ myWeather: MyWeather) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeekCell.identifier, for: indexPath) as! WeekCell
        //cell.myViewModel = self.myViewModel
        cell.myWeather = myWeather
        cell.tenDaysTempView.rowHeight = self.detailCollectionView.frame.height / 14.5
        return cell
    }
    
    private func configureAirQualityCell(_ collectionView: UICollectionView, _ indexPath: IndexPath, _ myWeather: MyWeather) -> UICollectionViewCell {
        
        
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AirQualityCell.identifier, for: indexPath) as! AirQualityCell
            //cell.myViewModel = self.myViewModel
            cell.myWeather = myWeather
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UltravioletCell.identifier, for: indexPath) as! UltravioletCell
            //cell.myViewModel = self.myViewModel
            cell.myWeather = myWeather
            return cell
        }
    }
    
    private func configureSunsetCell(_ collectionView: UICollectionView, _ indexPath: IndexPath, _ myWeather: MyWeather) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SunsetCell.identifier, for: indexPath) as! SunsetCell
            //cell.myViewModel = self.myViewModel
            cell.myWeather = myWeather
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ApparentTempCell.identifier, for: indexPath) as! ApparentTempCell
            //cell.myViewModel = self.myViewModel
            cell.myWeather = myWeather
            return cell
        }
    }
    
    private func configureRainFallCell(_ collectionView: UICollectionView, _ indexPath: IndexPath, _ myWeather: MyWeather) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RainFallCell.identifier, for: indexPath) as! RainFallCell
            //cell.myViewModel = self.myViewModel
            cell.myWeather = myWeather
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HumidityCell.identifier, for: indexPath) as! HumidityCell
            //cell.myViewModel = self.myViewModel
            cell.myWeather = myWeather
            return cell
        }
    }
    
}

