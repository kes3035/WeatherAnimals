import UIKit
import WeatherKit

final class DetailVC: UIViewController {
//MARK: - Properties
    
    private lazy var scrollView = UIScrollView().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var contentView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private lazy var tempLabel = UILabel().then {
        $0.text = "24"
        $0.font = UIFont.neoDeungeul(size: 48)
    }
    
    private lazy var celsiusLabel = UILabel().then {
        $0.text = String(UnicodeScalar(0x00B0))
        $0.font = UIFont.neoDeungeul(size: 50)
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
    
    private lazy var tempView = UIView().then {
        $0.backgroundColor = .clear
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
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 18
        $0.clipsToBounds = true
        $0.layer.borderColor = UIColor.systemGray4.cgColor
        $0.layer.borderWidth = 1
        $0.showsHorizontalScrollIndicator = false
        $0.register(CurrentWeatherCell.self, forCellWithReuseIdentifier: "CurrentWeatherCell")
    }
    
    private lazy var tenDaysTempView = UITableView().then {
        $0.isScrollEnabled = false
        $0.register(TenDaysWeatherCell.self, forCellReuseIdentifier: "TenDaysWeatherCell")
        $0.layer.cornerRadius = 18
        $0.backgroundColor = .white
        $0.layer.borderColor = UIColor.systemGray4.cgColor
        $0.layer.borderWidth = 1
    }
    
    private lazy var airQualityView = UIView().then {
        $0.backgroundColor = .systemGreen
        $0.layer.cornerRadius = 18
    }
    
    private lazy var airQualityLabel = UILabel().then {
        $0.text = "55"
        $0.font = UIFont.neoDeungeul(size: 30)
        $0.textColor = .white
    }
    
    private lazy var airQualityLineView = UIView().then {
        $0.backgroundColor = Constants.greenColor
        
    }
    
    private lazy var rainFallView = UIView().then {
        $0.backgroundColor = .systemBrown
        $0.layer.cornerRadius = 18
    }
    
    private lazy var addButton = UIButton().then {
        $0.backgroundColor = .clear
        $0.setTitle("추가", for: .normal)
        $0.setTitleColor(Constants.greenColor, for: .normal)
        $0.titleLabel?.font = UIFont.neoDeungeul(size: 16)
        $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }

    private lazy var cancelButton = UIButton().then {
        $0.backgroundColor = .clear
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(Constants.greenColor, for: .normal)
        $0.titleLabel?.font = UIFont.neoDeungeul(size: 16)
        $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }
    
    var weatherViewModel = WeatherViewModel()
    
    var weather: CurrentWeather? {
        didSet {
            configureUIWithData()
        }
    }
    
    var dayWeather: [DayWeather]? {
        didSet {
            configureUIWithData2()
        }
    }
    
    var hourWeather: [HourWeather]? {
        didSet {
        
        }
    }

    
//MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        settingCVFlowLayout()
        settingNav()
        settingTV()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.tabBarController?.navigationItem.hidesBackButton = true
//    }
//MARK: - Helpers
    private func configureUI() {
        self.view.backgroundColor = .white

        //Label끼리의 스택뷰에 뷰들 올리기
        self.tempView.addSubview(tempLabel)
        self.labelStack.addArrangedSubviews(tempView, summaryLabel, highestTempLabel, lowestTempLabel)
        self.topStack.addArrangedSubviews(animalImage, labelStack)
        self.airQualityView.addSubViews(airQualityLabel, airQualityLineView)
        self.view.addSubViews(scrollView, addButton, cancelButton)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubViews(topStack, currentDayTempView, 
                                tenDaysTempView, airQualityView,
                                rainFallView, celsiusLabel)
        
//        cancelButton.snp.makeConstraints {
//            $0.top.equalToSuperview().offset(10)
//            $0.leading.equalToSuperview().offset(15)
//        }
//
//        addButton.snp.makeConstraints {
//            $0.top.equalToSuperview().offset(10)
//            $0.trailing.equalToSuperview().offset(-15)
//        }
        
        animalImage.snp.makeConstraints { $0.height.width.equalTo(140) }
        
        tempView.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.width.equalTo(50)
        }
        
        tempLabel.snp.makeConstraints { $0.top.bottom.leading.equalToSuperview() }
        
        celsiusLabel.snp.makeConstraints {
            $0.top.equalTo(tempLabel.snp.top).offset(3)
            $0.leading.equalTo(tempLabel.snp.trailing).inset(5)
        }
        
        summaryLabel.snp.makeConstraints { $0.height.equalTo(20) }
        
        highestTempLabel.snp.makeConstraints { $0.height.equalTo(20) }
        
        scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        
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
            $0.height.equalTo(600)
        }
        
        airQualityView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().inset(15)
            $0.top.equalTo(tenDaysTempView.snp.bottom).offset(20)
            $0.height.equalTo(80)
        }
        
        airQualityLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview().offset(10)
            $0.height.equalTo(30)
        }
        
        airQualityLineView.snp.makeConstraints {
            $0.top.equalTo(airQualityLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(1)
        }
    }
    
    private func settingNav() {
//        let attributes = [
//            NSAttributedString.Key.font: UIFont(name: "NeoDunggeunmoPro-Regular", size: 20.0)!]
//        let attributedString = NSAttributedString(string: "지역타이틀", attributes: attributes)
//        let titleLabel = UILabel()
//        titleLabel.textAlignment = .center
//        titleLabel.attributedText = attributedString
//        titleLabel.sizeToFit()
//        let leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        
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
//        self.navigationItem.leftBarButtonItem = leftBarButtonItem

    }
    
    private func settingTV() {
        self.tenDaysTempView.delegate = self
        self.tenDaysTempView.dataSource = self
        self.tenDaysTempView.rowHeight = 60
    }
    
    private func settingCVFlowLayout() {
        flowLayout.scrollDirection = .horizontal
    }
    
    private func configureUIWithData() {
        guard let weather = weather else { return }
        DispatchQueue.main.async {
            self.tempLabel.text = String(round(weather.temperature.value))
            
        }
    }
    
    private func configureUIWithData2() {
        guard let dayWeather = dayWeather else { return }
        DispatchQueue.main.async {
            self.highestTempLabel.text = "최고 : " + "\(dayWeather[0].highTemperature)"
            self.lowestTempLabel.text = "최저 : " + "\(dayWeather[0].lowTemperature)"
            self.summaryLabel.text = dayWeather[0].condition.description

        }
    }
    
    
//MARK: - Actions
    @objc func buttonTapped(_ sender: UIButton) {
        switch sender.currentTitle {
        case "추가":
            print("디버깅: 추가버튼 눌림")
        case "취소":
            print("디버깅: 취소버튼 눌림")
        default:
            break
        }
    }
    
}
//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension DetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let hourWeather = self.hourWeather else { return 0 }

        return hourWeather.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CurrentWeatherCell", for: indexPath) as! CurrentWeatherCell
        guard let hourWeather = self.hourWeather else { return cell }
        cell.hourWeather = hourWeather[indexPath.row]
        
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
        guard let dayWeather = self.dayWeather else { return cell }
        cell.dayWeather = dayWeather[indexPath.row]
        if indexPath.row == 0 {
            cell.weekdaysTitleLabel.text = "오늘"
        } else {
            cell.weekdaysTitleLabel.text = self.weatherViewModel.getDayOfWeeks(from: Date())[indexPath.row]
        }
        return cell
    }
    
    
}
