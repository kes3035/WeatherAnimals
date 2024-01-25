import UIKit
import WeatherKit

final class DetailVC: UIViewController {
    //MARK: - Properties
    private let flowLayout = UICollectionViewFlowLayout()
    
    private let topView = DetailView()
    
    private lazy var detailCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .white
        $0.showsVerticalScrollIndicator = false
        $0.register(CurrentCell.self, forCellWithReuseIdentifier: CurrentCell.identifier) //CurrentCell 등록
        $0.register(WeekCell.self, forCellWithReuseIdentifier: WeekCell.identifier) //WeekCell 등록
        $0.register(AirQualityCell.self, forCellWithReuseIdentifier: AirQualityCell.identifier) //AirQualityCell 등록
        $0.register(UltravioletCell.self, forCellWithReuseIdentifier: UltravioletCell.identifier) //AirQualityCell 등록
        $0.register(SunsetCell.self, forCellWithReuseIdentifier: SunsetCell.identifier) //AirQualityCell 등록
        $0.register(ApparentTempCell.self, forCellWithReuseIdentifier: ApparentTempCell.identifier) //AirQualityCell 등록
        $0.register(RainFallCell.self, forCellWithReuseIdentifier: RainFallCell.identifier) //AirQualityCell 등록

        
        
        $0.register(CollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionReusableView.identifier) //Header 등록
    }
    
    var weatherViewModel = WeatherViewModel()
    
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.settingNav()
        self.settingFlowLayout()
    }
    //MARK: - Helpers
    
    func configureUI() {
        self.view.backgroundColor = .white
        self.view.addSubviews(detailCollectionView, topView)
        
        self.topView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(140)
        }
        
        self.detailCollectionView.snp.makeConstraints{
            $0.top.equalTo(topView.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
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
    
    
    //MARK: - Actions
    
}
//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension DetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int { return 5 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0, 1, 2:
            return 1
        case 3, 4:
            return 2
        default:
            return 1
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentCell.identifier, for: indexPath) as! CurrentCell
            cell.weatherViewModel.hourWeather = self.weatherViewModel.hourWeather
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeekCell.identifier, for: indexPath) as! WeekCell
            cell.weatherViewModel.dayWeather = self.weatherViewModel.dayWeather
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AirQualityCell.identifier, for: indexPath) as! AirQualityCell
            return cell
        case 3:
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UltravioletCell.identifier, for: indexPath) as! UltravioletCell
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SunsetCell.identifier, for: indexPath) as! SunsetCell
                return cell
            }
        case 4:
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ApparentTempCell.identifier, for: indexPath) as! ApparentTempCell
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RainFallCell.identifier, for: indexPath) as! RainFallCell
                return cell
            }
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentCell.identifier, for: indexPath) as! CurrentCell
            return cell
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
            return CGSize(width: self.view.frame.width, height: 600)
        case 2:
            return CGSize(width: self.view.frame.width, height: 170)
        case 3, 4:
            return CGSize(width: self.view.frame.width/2 - 5, height: self.view.frame.width/2 - 5)
        default:
            return CGSize(width: 100, height: 100)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 30)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                           withReuseIdentifier: CollectionReusableView.identifier,
                                                                           for: indexPath)  as? CollectionReusableView
        else { return UICollectionReusableView()}
        return header
    }
    
}


//extension DetailVC: UIScrollViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        guard scrollView == self.detailCollectionView else { return }
//        let offsetY = scrollView.contentOffset.y
//
//        // HeaderView의 높이만큼 스크롤 되었을 때 (HeaderView가 화면 밖에 있는 상태)
//        if offsetY >= 20 {
//            // 이전 헤더뷰를 투명하게 만들기
//
//        } else {
//            // 스크롤이 헤더뷰의 높이 미만일 때, 투명도를 조절하여 페이드아웃 효과 생성
////            let alpha = 1.0 - (offsetY / headerViewHeight)
////            previousHeaderView.alpha = alpha
//        }
//    }
//}
//


