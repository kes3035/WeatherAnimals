import UIKit

final class TabBC: UITabBarController {
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.settingTB()
    }
    
    
    
    //MARK: - Helpers
    private func settingTB() {
        
        // Tabbar Appearance Setting
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Constants.greenColor
        self.tabBar.standardAppearance = appearance
        self.tabBar.scrollEdgeAppearance = appearance
        
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = .white
        
        
        // ViewControllers Initialize
        let homeVC = MainVC()
        homeVC.tabBarItem = UITabBarItem(title: "홈",
                                         image: UIImage(systemName: "person"),
                                         selectedImage: UIImage(systemName: "person.fill"))
        let settingVC = SettingVC()
        settingVC.tabBarItem = UITabBarItem(title: "설정",
                                            image: UIImage(systemName: "gearshape"),
                                            selectedImage: UIImage(systemName: "gearshape.fill"))
        
        // NavController Initialize
        let nav1 = UINavigationController(rootViewController: homeVC)
        let nav2 = UINavigationController(rootViewController: settingVC)
        

        
        self.viewControllers = [nav1, nav2]
        
    }
}
