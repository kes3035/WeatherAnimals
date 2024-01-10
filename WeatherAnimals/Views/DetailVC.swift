import UIKit
import WeatherKit

final class DetailVC: UIViewController {
//MARK: - Properties
    
    private lazy var scrollView = UIScrollView().then {
        $0.backgroundColor = .white
    }
    
    private lazy var contentView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private lazy var tempLabel = UILabel().then {
        $0.text = "24"
        $0.font = UIFont.neoDeungeul(size: 48)
    }
    
    private lazy var summaryLabel = UILabel().then {
        $0.text = "대체로 맑개"
        $0.font = UIFont.neoDeungeul(size: 20)

    }
    
    private lazy var highestTempLabel = UILabel().then {
        $0.text = "최고 : 123"
        $0.font = UIFont.neoDeungeul(size: 20)

    }
    
    private lazy var lowestTempLabel = UILabel().then {
        $0.text = "최저 : 123"
        $0.font = UIFont.neoDeungeul(size: 20)

    }
    
    private lazy var labelStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
        $0.distribution = .fill
    }
    
    private lazy var animalImage = UIImageView().then {
        $0.backgroundColor = .systemBlue
    }
    
    private lazy var topStack = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 14
    }
    
    private let flowLayout = UICollectionViewFlowLayout()
    
    private lazy var currentDayTempView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .green
        $0.layer.cornerRadius = 18
        $0.clipsToBounds = true
        $0.showsHorizontalScrollIndicator = false
        $0.register(CurrentWeatherCell.self, forCellWithReuseIdentifier: "CurrentWeatherCell")
    }
    
    private lazy var tenDaysTempView = UIView().then {
        $0.layer.cornerRadius = 18
        $0.backgroundColor = .systemBlue
    }
    
    private lazy var airQualityView = UIView().then {
        $0.backgroundColor = .systemGreen
        $0.layer.cornerRadius = 18
    }
    
    private lazy var rainFallView = UIView().then {
        $0.backgroundColor = .systemBrown
        $0.layer.cornerRadius = 18
    }
    
    var weather: CurrentWeather? {
        didSet {
            guard let weather = weather else { return }
            self.tempLabel.text = String(round(weather.temperature.value))
        }
    }
    
    
//MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        settingCVFlowLayout()
        settingNav()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.hidesBackButton = true
    }
//MARK: - Helpers
    private func configureUI() {
        self.view.backgroundColor = .white

        //Label끼리의 스택뷰에 뷰들 올리기
        self.labelStack.addArrangedSubviews(tempLabel, summaryLabel, highestTempLabel, lowestTempLabel)
        self.topStack.addArrangedSubviews(animalImage, labelStack)
        self.view.addSubViews(scrollView)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubViews(topStack, currentDayTempView, tenDaysTempView, airQualityView, rainFallView)
        
        animalImage.snp.makeConstraints { $0.height.width.equalTo(140) }
        
        tempLabel.snp.makeConstraints { $0.height.equalTo(50) }
        
        summaryLabel.snp.makeConstraints { $0.height.equalTo(20) }
        
        highestTempLabel.snp.makeConstraints { $0.height.equalTo(20) }
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.height.equalTo(1200)
        }
        
        topStack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(290)
            $0.height.equalTo(140)
        }
        
        currentDayTempView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().inset(15)
            $0.top.equalTo(topStack.snp.bottom).offset(20)
            $0.height.equalTo(100)
        }
        
        tenDaysTempView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().inset(15)
            $0.top.equalTo(currentDayTempView.snp.bottom).offset(20)
            $0.height.equalTo(700)
        }
        
    }
    
    private func settingNav() {
//        self.navigationItem.backButtonTitle = "죽전동"
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
    
    private func settingCVFlowLayout() {
        flowLayout.scrollDirection = .horizontal
    }
//MARK: - Actions

}
//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension DetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CurrentWeatherCell", for: indexPath) as! CurrentWeatherCell
        
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension DetailVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 100)
    }
}


//MARK: - UITableViewDelegate, UITableViewDataSource
extension DetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TenDaysWeatherCell", for: indexPath) as! TenDaysWeatherCell
         
        
        return cell
    }
    
    
}
