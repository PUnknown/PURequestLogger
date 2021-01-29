import UIKit

extension UIApplication {
    var topViewController: UIViewController? {
        let window: UIWindow?
        if let keyWindow = keyWindow {
            window = keyWindow
        } else {
            window = windows.first(where: { $0.isKeyWindow })
        }
        
        return window?.rootViewController.map { getTopViewController(withRoot: $0) }
    }
    
    private func getTopViewController(withRoot rootViewController: UIViewController) -> UIViewController {
        var vcRoot = rootViewController
        
        while true {
            if let vcTabSelected = (vcRoot as? UITabBarController)?.selectedViewController {
                vcRoot = vcTabSelected
            } else if let vcPresented = (vcRoot as? UINavigationController)?.presentedViewController {
                vcRoot = vcPresented
            } else if let vcLast = (vcRoot as? UINavigationController)?.viewControllers.last {
                vcRoot = vcLast
            } else {
                return vcRoot
            }
        }
    }
}
