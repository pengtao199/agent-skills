import AnyThinkSDK
import Foundation
import UIKit

@MainActor
final class TopOnRewardedService: NSObject {
    var onRewardEarned: (() -> Void)?
    var onClosed: (() -> Void)?
    var onShowFailed: ((Error) -> Void)?

    private var retryAttempt = 0

    func load(userID: String? = nil) {
        var extras: [String: Any] = [:]
        extras[kATAdLoadingExtraMediaExtraKey] = "rewarded_entry"

        if let userID, !userID.isEmpty {
            extras[kATAdLoadingExtraUserIDKey] = userID
        }

        ATAdManager.shared().loadAD(
            withPlacementID: TopOnConfig.Placement.rewarded,
            extra: extras,
            delegate: self
        )
    }

    func isReady() -> Bool {
        ATAdManager.shared().rewardedVideoReady(forPlacementID: TopOnConfig.Placement.rewarded)
    }

    func show(from presentingViewController: UIViewController) {
        guard isReady() else {
            load()
            return
        }

        let config = ATShowConfig(
            scene: TopOnConfig.Scene.rewarded,
            showCustomExt: "rewarded_show"
        )

        ATAdManager.shared().showRewardedVideo(
            withPlacementID: TopOnConfig.Placement.rewarded,
            config: config,
            in: presentingViewController,
            delegate: self
        )
    }
}

extension TopOnRewardedService: ATAdLoadingDelegate {
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

extension TopOnRewardedService: ATRewardedVideoDelegate {
    func rewardedVideoDidRewardSuccess(forPlacemenID placementID: String, extra: [AnyHashable : Any]) {
        onRewardEarned?()
    }

    func rewardedVideoDidFailToPlay(forPlacementID placementID: String, error: Error, extra: [AnyHashable : Any]) {
        onShowFailed?(error)
        load()
    }

    func rewardedVideoDidClose(forPlacementID placementID: String, rewarded: Bool, extra: [AnyHashable : Any]) {
        onClosed?()
        load()
    }
}
