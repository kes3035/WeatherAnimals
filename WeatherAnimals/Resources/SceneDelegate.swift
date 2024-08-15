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
        
        let launchVC = LaunchVC()
        let tabBC = TabBC()
        
        window.rootViewController = launchVC
        window.makeKeyAndVisible()
        self.window = window

        Task {
            do {
                let userLocation = try await tabBC.locationViewModel.fetchLocation()
                let userLocationTitle = try await tabBC.myViewModel.fetchLocationTitle(for: userLocation)
                let timeZone = try await tabBC.myViewModel.fetchTimeZone(for: userLocation)
                let userDict: LocationByTitle = [userLocationTitle: userLocation]
                
                tabBC.myViewModel.setUserLocation(with: userLocation)
                tabBC.myViewModel.setTimeZone(with: timeZone)
                
                let myDatas = try await self.fetchMyData()
                let coreDataLocationByTitle = try await tabBC.myViewModel.fetchCoreDataLocationByTitle(myDatas)
                let totalData = [userDict] + coreDataLocationByTitle
                tabBC.myViewModel.setLocationByTitle(totalData)
                
                let locations: [CLLocation] = totalData.flatMap { $0.values }
                let weathers = try await tabBC.myViewModel.fetchWeathers(for: locations)

                tabBC.myViewModel.setWeathers(with: weathers)
                
                try await Task.sleep(nanoseconds: 1_500_000_000)
                window.rootViewController = tabBC
            } catch {
                print(error.localizedDescription)
            }
        }
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
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchMyData() async throws -> [MyData] {
        let context = self.persistentContainer.viewContext
        
        return try await withCheckedThrowingContinuation { continuation in
            context.perform {
                do {
                    let myData = try context.fetch(MyData.fetchRequest()) as! [MyData]
                    continuation.resume(returning: myData)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
