//
//  SceneDelegate.swift
//  WeatherAnimals
//
//  Created by 김은상 on 10/30/23.
//
import CoreData
import UIKit
import CoreLocation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        var myLocation = CLLocation(latitude: 0.0, longitude: 0.0)
        let launchVC = LaunchVC()
        let tabBarController = TabBC()
        let delay = DispatchTime.now()
        
        DispatchQueue.global().async {
            launchVC.locationViewModel.fetchLocation { coordinate, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                guard let coordinate = coordinate else { return }
                myLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                DispatchQueue.main.async {
                    launchVC.configureLoadingBar()
                    window.rootViewController = launchVC
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: delay + 2) {
            launchVC.configureLoadingBar2()
        }
        

        
        DispatchQueue.global(qos: .default).asyncAfter(deadline: delay + 3) {
            
            self.fetchMyData { [weak self] models in
                
                guard self == self else { return }
                
                tabBarController.viewModel.myDatas = models
                tabBarController.viewModel.myLocation = myLocation
                
                DispatchQueue.main.async { window.rootViewController = tabBarController }
            }
        }
       
//        let detail = DetailVC()
//        window.rootViewController = detail
        window.makeKeyAndVisible()
        self.window = window
    }


    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                /*

                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = self.persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchMyData( completion: @escaping([MyData])->(Void)) {
        let context = self.persistentContainer.viewContext
        
        do {
            let myData = try context.fetch(MyData.fetchRequest()) as! [MyData]
            completion(myData)
        } catch { print(error.localizedDescription) }
    }
}

