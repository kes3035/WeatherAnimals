import UIKit
import WeatherKit

/*
 오늘 날씨에 대한 정보가 들어있는 셀
 수평으로 스크롤 가능한 콜렉션뷰로 이루어짐
 */
final class CurrentCell: UICollectionViewCell {
    static let identifier = "CurrentCell"
    //MARK: - Properties
    private let flowLayout = UICollectionViewFlowLayout()

    private lazy var currentCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
        $0.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        $0.clipsToBounds = true
        $0.layer.borderColor = UIColor.systemGray4.cgColor
        $0.layer.borderWidth = 1
        $0.showsHorizontalScrollIndicator = false
        $0.register(CurrentWeatherCell.self, forCellWithReuseIdentifier: CurrentWeatherCell.identifier)
    }
    
    lazy var weatherViewModel = WeatherViewModel()
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
        self.settingFlowLayout()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    //MARK: - Helpers
    
    private func configureUI() {
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(currentCollectionView)
        self.currentCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().inset(5)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().inset(10)
        }
    }
    
    private func settingFlowLayout() {
        self.flowLayout.scrollDirection = .horizontal
        self.flowLayout.sectionHeadersPinToVisibleBounds = true
    }
    
    //MARK: - Actions
    
    
}

extension CurrentCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        self.weatherViewModel.getHourlyWeather(location: weatherViewModel.yongin) { hourWeathers in
//            let count = hourWeathers.count
//        }
        return 10
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentWeatherCell.identifier, for: indexPath) as! CurrentWeatherCell
        return cell
    }
    
    
}

extension CurrentCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 100)
    }
}
