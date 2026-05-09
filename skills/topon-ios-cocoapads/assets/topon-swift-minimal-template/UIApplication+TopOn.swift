import UIKit

extension UIApplication {
    var topOnKeyWindow: UIWindow? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first(where: \.isKeyWindow)
    }

    func topOnTopViewController(base: UIViewController? = nil) -> UIViewController? {
        let baseViewController = base ?? topOnKeyWindow?.rootViewController

        if let navigationController = baseViewController as? UINavigationController {
            return topOnTopViewController(base: navigationController.visibleViewController)
        }

        if let tabBarController = baseViewController as? UITabBarController {
            return topOnTopViewController(base: tabBarController.selectedViewController)
        }

        if let presented = baseViewController?.presentedViewController {
            return topOnTopViewController(base: presented)
        }

        return baseViewController
    }
}
