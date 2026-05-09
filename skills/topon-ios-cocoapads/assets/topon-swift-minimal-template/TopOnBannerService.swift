import AnyThinkSDK
import Foundation
import UIKit

@MainActor
final class TopOnBannerService: NSObject {
    private var bannerView: ATBannerView?

    func load() {
        var extras: [String: Any] = [:]
        extras[kATAdLoadingExtraBannerAdSizeKey] = NSValue(cgSize: CGSize(width: 320, height: 50))
        extras[kATAdLoadingExtraMediaExtraKey] = "banner_entry"

        ATAdManager.shared().loadAD(
            withPlacementID: TopOnConfig.Placement.banner,
            extra: extras,
            delegate: self
        )
    }

    func isReady() -> Bool {
        ATAdManager.shared().bannerAdReady(forPlacementID: TopOnConfig.Placement.banner)
    }

    func attach(to containerView: UIView, presentingViewController: UIViewController) {
        if !isReady() {
            load()
            return
        }

        let config = ATShowConfig(
            scene: TopOnConfig.Scene.banner,
            showCustomExt: "banner_show"
        )

        guard let banner = ATAdManager.shared().retrieveBannerView(
            forPlacementID: TopOnConfig.Placement.banner,
            config: config
        ) else {
            return
        }

        banner.delegate = self
        banner.presentingViewController = presentingViewController
        banner.translatesAutoresizingMaskIntoConstraints = false

        bannerView?.destroyBanner()
        bannerView?.removeFromSuperview()
        bannerView = banner

        containerView.addSubview(banner)
        NSLayoutConstraint.activate([
            banner.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            banner.topAnchor.constraint(equalTo: containerView.topAnchor),
            banner.widthAnchor.constraint(equalToConstant: 320),
            banner.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    func remove() {
        bannerView?.destroyBanner()
        bannerView?.removeFromSuperview()
        bannerView = nil
    }
}

extension TopOnBannerService: ATAdLoadingDelegate {
    func didFinishLoadingAD(withPlacementID placementID: String) {}

    func didFailToLoadAD(withPlacementID placementID: String, error: Error) {}
}

extension TopOnBannerService: ATBannerDelegate {
    func bannerView(_ bannerView: ATBannerView, didTapCloseButtonWithPlacementID placementID: String, extra: [AnyHashable : Any]) {
        remove()
    }
}
