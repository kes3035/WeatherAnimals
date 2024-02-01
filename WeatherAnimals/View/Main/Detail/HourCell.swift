import UIKit
import WeatherKit

final class HourCell: UICollectionViewCell {
    static let identifier = "HourCell"
    //MARK: - Properties
    private let flowLayout = UICollectionViewFlowLayout()

    private lazy var hourCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
        $0.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        $0.clipsToBounds = true
        $0.layer.borderColor = UIColor.systemGray4.cgColor
        $0.layer.borderWidth = 1
        $0.showsHorizontalScrollIndicator = false
        $0.register(HourWeatherCell.self, forCellWithReuseIdentifier: HourWeatherCell.identifier)
    }
    
    var weatherViewModel: WeatherViewModel! {
        didSet {
            DispatchQueue.main.async {
                self.hourCollectionView.reloadData()
            }
        }
    }
    
//    var hourWeathers: [HourWeather]? {
//        didSet {
//            DispatchQueue.main.async {
//                self.hourCollectionView.reloadData()
//            }
//        }
//    }
 
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.weatherViewModel = WeatherViewModel()
        self.weatherViewModel.getHourWeather(location: self.weatherViewModel.yongin)
        self.configureUI()
        self.settingFlowLayout()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    //MARK: - Helpers
    
    private func configureUI() {
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(hourCollectionView)
        self.hourCollectionView.snp.makeConstraints {
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
}

extension HourCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return 10
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourWeatherCell.identifier, for: indexPath) as! HourWeatherCell
        
        guard let hourWeathers = self.weatherViewModel.hourWeathers else { return cell }
        
        let hourWeather = hourWeathers[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a h:mm"
        dateFormatter.locale = Locale(identifier:"ko_KR")
        let dateString = dateFormatter.string(from: hourWeather.date)
        
        cell.topLabel.text = dateString
        cell.tempLabel.text = round(hourWeather.temperature.value).description + String(UnicodeScalar(0x00B0))
        cell.tempImageView.image = UIImage(named: hourWeather.symbolName)
        
        return cell
    }
    
}

extension HourCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 100)
    }
}
