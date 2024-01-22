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
        
        $0.register(CurrentCell.self, forCellWithReuseIdentifier: CurrentCell.identifier) //DetailCell 등록
        $0.register(WeekCell.self, forCellWithReuseIdentifier: WeekCell.identifier) //WeekCell 등록
        
        $0.register(CollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionReusableView.identifier) //Header 등록
    }
    
//MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        settingNav()
        settingFlowLayout()

    }
//MARK: - Helpers
    
    func configureUI() {
        self.view.backgroundColor = .white
        self.view.addSubViews(detailCollectionView, topView)
        
        self.topView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
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
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        /*
         섹션의 갯수를 정하는 메서드
         0 : 현재 날씨 요약 섹션
         1 : 현재 날씨의 시간별 요약 섹션 == CurrentCell
         2 : 오늘로부터 10일간의 날씨 요약 섹션 == WeekCell
         3 : 대기질 지수를 나타내는 섹션 == AirQualityCell
         4 : 자외선, 체감온도
         */
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //콜렉션뷰의 섹션별 아이템 갯수
        //0, 1, 2 섹션은 1개씩
        //3, 4    섹션은 2개씩
        switch section {
        case 0, 1:
            return 1
        case 2, 3:
            return 2
        default:
            return 1
        }
    }
   
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        /*
         셀에 데이터를 전달하는 메서드
         indexPath.row에 따라 각 셀에 데이터 전달
         */
        
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentCell.identifier, for: indexPath) as! CurrentCell
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeekCell.identifier, for: indexPath) as! WeekCell
            return cell
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentCell.identifier, for: indexPath) as! CurrentCell
            return cell
        }
      
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension DetailVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        /*
         섹션별 크기를 정하는 메서드
         */
        switch indexPath.section {
        case 0:
            return CGSize(width: self.view.frame.width, height: 100)
        case 1:
            return CGSize(width: self.view.frame.width, height: 600)
        case 2:
            return CGSize(width: self.view.frame.width/2 - 20, height: 200)
        case 3:
            return CGSize(width: self.view.frame.width/2 - 20, height: 200)
        default:
            return CGSize(width: 100, height: 100)
        }
    }
//    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        /*
         섹션별 헤더의 크기를 정하는 메서드
         */
//        switch section {
//        case 0:
//            return CGSize(width: self.view.frame.width, height: 10)
//        case 1,2,3,4:
//            return CGSize(width: 100, height: 100)
//        default:
//            return CGSize(width: 100, height: 100)
//        }
        return CGSize(width: self.view.frame.width, height: 20)

    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        /*
         헤더 등록하는 메서드
         */
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionReusableView.identifier, for: indexPath)  as? CollectionReusableView else { return UICollectionReusableView()}
//        return header

        switch indexPath.section {
        case 0:
//            header.type = indexPath.section
            return header
        case 1,2,3,4:
            return header
        default:
            return header
        }
    }
}


