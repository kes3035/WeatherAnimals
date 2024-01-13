//
//  TabBC.swift
//  WeatherAnimals
//
//  Created by 김은상 on 1/3/24.
//

import UIKit

final class TabBC: UITabBarController {
//    let weatherViewModel = WeatherViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTB()
    }
    
    
    
    private func settingTB() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Constants.greenColor
        self.tabBar.standardAppearance = appearance
        self.tabBar.scrollEdgeAppearance = appearance
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = .white
        let homeVC = MainVC()
//        self.weatherViewModel.getWeather(location: self.weatherViewModel.yongin)
//        homeVC.weatherViewModel.currentWeather = self.weatherViewModel.currentWeather
        homeVC.tabBarItem = UITabBarItem(title: "홈",
                                         image: UIImage(systemName: "person"),
                                         selectedImage: UIImage(systemName: "person.fill"))
        let settingVC = SettingVC()
        settingVC.tabBarItem = UITabBarItem(title: "설정",
                                            image: UIImage(systemName: "gearshape"),
                                            selectedImage: UIImage(systemName: "gearshape.fill"))
        
        let nav1 = UINavigationController(rootViewController: homeVC)
        let nav2 = UINavigationController(rootViewController: settingVC)
        
        self.viewControllers = [nav1, nav2]
        
        
    }
    
}
