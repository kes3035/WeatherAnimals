import UIKit
import WeatherKit

final class HourCell: UICollectionViewCell {
    static let identifier = "HourCell"
    //MARK: - Properties
    private let hourCellCVFlowLayout = UICollectionViewFlowLayout()

    private lazy var hourCellCV = UICollectionView(frame: .zero, collectionViewLayout: hourCellCVFlowLayout).then {
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = UIColor(named: "background")
        $0.clipsToBounds = true
        $0.showsHorizontalScrollIndicator = false
        $0.register(HourWeatherCell.self, forCellWithReuseIdentifier: HourWeatherCell.identifier)
    }
 
    
    lazy var myViewModel = MyViewModel() {
        didSet {
            DispatchQueue.main.async {
                self.hourCellCV.reloadData()
            }
        }
    }
    
 
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
        self.contentView.addSubview(hourCellCV)
        self.contentView.snp.makeConstraints { $0.edges.equalToSuperview() }
        self.hourCellCV.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().inset(5)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
    
    private func settingFlowLayout() {
        self.hourCellCVFlowLayout.scrollDirection = .horizontal
        self.hourCellCVFlowLayout.sectionHeadersPinToVisibleBounds = true
    }
}


//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension HourCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourWeatherCell.identifier, for: indexPath) as! HourWeatherCell
        
        guard let hourlyWeathers = self.myViewModel.getHourlyWeathers(),
              let timeZone = self.myViewModel.getTimeZone() else { return cell }
        
        cell.timeZone = timeZone
        cell.hourWeather = hourlyWeathers[indexPath.row]
        
        return cell
    }
    
}


//MARK: - UICollectionViewDelegateFlowLayout
extension HourCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
}
