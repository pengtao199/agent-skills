import UIKit

@MainActor
enum TopOnBootstrapExample {
    static func startAds(isEUFlow: Bool) {
        if isEUFlow {
            TopOnSDKManager.shared.startForEU {}
        } else {
            TopOnSDKManager.shared.start()
        }
    }

    static func attachBanner(in containerView: UIView, from viewController: UIViewController) {
        let service = TopOnBannerService()
        service.load()
        service.attach(to: containerView, presentingViewController: viewController)
    }

    static func showInterstitial(from viewController: UIViewController) {
        let service = TopOnInterstitialService()
        service.load()
        service.show(from: viewController)
    }

    static func showRewarded(from viewController: UIViewController) {
        let service = TopOnRewardedService()
        service.onRewardEarned = {
            print("Reward earned")
        }
        service.load(userID: "your-user-id")
        service.show(from: viewController)
    }

    static func makeNativeExpressView(from viewController: UIViewController) -> UIView? {
        let service = TopOnNativeExpressService()
        let size = CGSize(width: 320, height: 180)
        service.load(targetSize: size)
        return service.makeAdView(rootViewController: viewController, targetSize: size)
    }

    static func showSplash(window: UIWindow, from viewController: UIViewController) {
        let service = TopOnSplashService()
        service.onFinished = {
            print("Splash finished")
        }
        service.load {
            let footer = UIView(frame: CGRect(x: 0, y: 0, width: window.bounds.width, height: 120))
            footer.backgroundColor = .white
            return footer
        }
        service.show(window: window, from: viewController)
    }
}
