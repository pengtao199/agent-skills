import AnyThinkSDK
import Foundation
import UIKit

@MainActor
final class TopOnInterstitialService: NSObject {
    var onClosed: (() -> Void)?
    var onShowFailed: ((Error) -> Void)?

    private var retryAttempt = 0

    func load() {
        var extras: [String: Any] = [:]
        extras[kATAdLoadingExtraMediaExtraKey] = "interstitial_entry"

        ATAdManager.shared().loadAD(
            withPlacementID: TopOnConfig.Placement.interstitial,
            extra: extras,
            delegate: self
        )
    }

    func isReady() -> Bool {
        ATAdManager.shared().interstitialReady(forPlacementID: TopOnConfig.Placement.interstitial)
    }

    func show(from presentingViewController: UIViewController) {
        guard isReady() else {
            load()
            return
        }

        let config = ATShowConfig(
            scene: TopOnConfig.Scene.interstitial,
            showCustomExt: "interstitial_show"
        )

        ATAdManager.shared().showInterstitial(
            withPlacementID: TopOnConfig.Placement.interstitial,
            showConfig: config,
            in: presentingViewController,
            delegate: self,
            nativeMixViewBlock: nil
        )
    }
}

extension TopOnInterstitialService: ATAdLoadingDelegate {
    func didFinishLoadingAD(withPlacementID placementID: String) {
        retryAttempt = 0
    }

    func didFailToLoadAD(withPlacementID placementID: String, error: Error) {
        guard retryAttempt < 3 else { return }

        retryAttempt += 1
        let delaySeconds = pow(2.0, Double(min(3, retryAttempt)))
        DispatchQueue.main.asyncAfter(deadline: .now() + delaySeconds) {
            self.load()
        }
    }
}

extension TopOnInterstitialService: ATInterstitialDelegate {
    func interstitialFailedToShow(forPlacementID placementID: String, error: Error, extra: [AnyHashable : Any]) {
        onShowFailed?(error)
    }

    func interstitialDidFailToPlayVideo(forPlacementID placementID: String, error: Error, extra: [AnyHashable : Any]) {
        onShowFailed?(error)
        load()
    }

    func interstitialDidClose(forPlacementID placementID: String, extra: [AnyHashable : Any]) {
        onClosed?()
        load()
    }
}
