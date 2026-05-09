import AnyThinkSDK
import Foundation
import UIKit

@MainActor
final class TopOnSplashService: NSObject {
    var onFinished: (() -> Void)?
    var onShowFailed: ((Error?) -> Void)?

    private var footerViewProvider: (() -> UIView)?

    func load(footerViewProvider: (() -> UIView)? = nil) {
        self.footerViewProvider = footerViewProvider

        var extras: [String: Any] = [:]
        extras[kATSplashExtraTolerateTimeoutKey] = 5
        extras[kATAdLoadingExtraMediaExtraKey] = "splash_entry"

        ATAdManager.shared().loadAD(
            withPlacementID: TopOnConfig.Placement.splash,
            extra: extras,
            delegate: self,
            containerView: footerViewProvider?()
        )
    }

    func isReady() -> Bool {
        ATAdManager.shared().splashReady(forPlacementID: TopOnConfig.Placement.splash)
    }

    func show(window: UIWindow, from viewController: UIViewController) {
        guard isReady() else {
            load(footerViewProvider: footerViewProvider)
            return
        }

        let config = ATShowConfig(
            scene: TopOnConfig.Scene.splash,
            showCustomExt: "splash_show"
        )

        ATAdManager.shared().showSplash(
            withPlacementID: TopOnConfig.Placement.splash,
            config: config,
            window: window,
            in: viewController,
            extra: [:],
            delegate: self
        )
    }
}

extension TopOnSplashService: ATSplashDelegate {
    func didFinishLoadingSplashAD(withPlacementID placementID: String, isTimeout: Bool) {
        if isTimeout {
            onFinished?()
        }
    }

    func didFailToLoadAD(withPlacementID placementID: String, error: Error) {
        onShowFailed?(error)
        onFinished?()
    }

    func didTimeoutLoadingSplashAD(withPlacementID placementID: String) {
        onFinished?()
    }

    func splashDidClose(forPlacementID placementID: String, extra: [AnyHashable : Any]) {
        onFinished?()
    }

    func splashDidShowFailed(forPlacementID placementID: String, error: Error, extra: [AnyHashable : Any]) {
        onShowFailed?(error)
        onFinished?()
    }
}
