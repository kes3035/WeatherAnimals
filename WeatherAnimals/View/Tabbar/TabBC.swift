import UIKit

final class TabBC: UITabBarController {
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.settingTB()
    }
    //MARK: - Helpers
    private func settingTB() {
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Constants.greenColor
        self.tabBar.standardAppearance = appearance
        self.tabBar.scrollEdgeAppearance = appearance
        
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = .white
        
        let mainVC = MainVC()
        mainVC.weatherViewModel.fetchMyData()
        mainVC.tabBarItem = UITabBarItem(title: "홈",
                                         image: UIImage(systemName: "person"),
                                         selectedImage: UIImage(systemName: "person.fill"))
        let settingVC = SettingVC()
        settingVC.tabBarItem = UITabBarItem(title: "설정",
                                            image: UIImage(systemName: "gearshape"),
                                            selectedImage: UIImage(systemName: "gearshape.fill"))
        
        let nav1 = UINavigationController(rootViewController: mainVC)
        let nav2 = UINavigationController(rootViewController: settingVC)
        


        self.viewControllers = [nav1, nav2]
    }
}
