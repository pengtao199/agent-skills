import AnyThinkSDK
import Foundation
import UIKit

@MainActor
final class TopOnNativeExpressService: NSObject {
    private var retryAttempt = 0
    private var currentAdView: ATNativeADView?
    private var currentOffer: ATNativeAdOffer?

    func load(targetSize: CGSize) {
        var extras: [String: Any] = [:]
        extras[kATExtraInfoNativeAdSizeKey] = NSValue(cgSize: targetSize)

        ATAdManager.shared().loadAD(
            withPlacementID: TopOnConfig.Placement.nativeExpress,
            extra: extras,
            delegate: self
        )
    }

    func isReady() -> Bool {
        ATAdManager.shared().nativeAdReady(forPlacementID: TopOnConfig.Placement.nativeExpress)
    }

    func makeAdView(rootViewController: UIViewController, targetSize: CGSize) -> ATNativeADView? {
        guard isReady() else {
            load(targetSize: targetSize)
            return nil
        }

        let configuration = ATNativeADConfiguration()
        configuration.adFrame = CGRect(origin: .zero, size: targetSize)
        configuration.rootViewController = rootViewController
        configuration.delegate = self
        configuration.sizeToFit = true
        configuration.videoPlayType = .onlyWiFiAutoPlayType

        guard let offer = ATAdManager.shared().getNativeAdOffer(
            withPlacementID: TopOnConfig.Placement.nativeExpress,
            scene: TopOnConfig.Scene.nativeExpress
        ) else {
            return nil
        }

        let adView = ATNativeADView(
            configuration: configuration,
            currentOffer: offer,
            placementID: TopOnConfig.Placement.nativeExpress
        )

        offer.renderer(with: configuration, selfRenderView: nil, nativeADView: adView)

        currentOffer = offer
        currentAdView = adView
        return adView
    }

    func destroyCurrentAd() {
        currentAdView?.destroyNative()
        currentAdView?.removeFromSuperview()
        currentAdView = nil
        currentOffer = nil
    }
}

extension TopOnNativeExpressService: ATAdLoadingDelegate {
    func didFinishLoadingAD(withPlacementID placementID: String) {
        retryAttempt = 0
    }

    func didFailToLoadAD(withPlacementID placementID: String, error: Error) {
        guard retryAttempt < 3 else { return }

        retryAttempt += 1
        let delaySeconds = pow(2.0, Double(min(3, retryAttempt)))
        DispatchQueue.main.asyncAfter(deadline: .now() + delaySeconds) {
            self.load(targetSize: CGSize(width: 320, height: 180))
        }
    }
}

extension TopOnNativeExpressService: ATNativeADDelegate {
    func didTapCloseButton(in adView: ATNativeADView, placementID: String, extra: [AnyHashable : Any]) {
        destroyCurrentAd()
        load(targetSize: adView.bounds.size == .zero ? CGSize(width: 320, height: 180) : adView.bounds.size)
    }
}
