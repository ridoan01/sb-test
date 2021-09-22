import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let initalViewController = UINavigationController(rootViewController: MovieListViewController())
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = initalViewController
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

