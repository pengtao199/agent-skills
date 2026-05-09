import AnyThinkSDK
import AppTrackingTransparency
import Foundation
import UIKit

@MainActor
final class TopOnSDKManager {
    static let shared = TopOnSDKManager()

    private var hasStarted = false

    private init() {}

    func start(debug: Bool = _isDebugAssertConfiguration()) {
        guard !hasStarted else { return }

        if debug {
            ATAPI.setLogEnabled(true)
            ATAPI.integrationChecking()
        }

        if !TopOnConfig.customChannel.isEmpty {
            ATSDKGlobalSetting.sharedManager().channel = TopOnConfig.customChannel
        }

        do {
            try ATAPI.sharedInstance().start(
                withAppID: TopOnConfig.appID,
                appKey: TopOnConfig.appKey
            )
            hasStarted = true
        } catch {
            assertionFailure("TopOn init failed: \(error)")
        }
    }

    func startForEU(completion: @escaping () -> Void) {
        let presenter = UIApplication.shared.topOnTopViewController() ?? UIViewController()

        ATAPI.sharedInstance().showGDPRConsentDialog(in: presenter) {
            let consent = ATAPI.sharedInstance().dataConsentSet
            let isFirstResolvedLaunch = UserDefaults.standard.bool(forKey: "TopOn.GDPR.FirstLaunchResolved")

            if (consent == .unknown && isFirstResolvedLaunch) || consent == .personalized {
                if #available(iOS 14, *) {
                    ATTrackingManager.requestTrackingAuthorization { _ in }
                }
            }

            self.start()
            completion()
            UserDefaults.standard.set(true, forKey: "TopOn.GDPR.FirstLaunchResolved")
        }
    }

    #if canImport(AnyThinkDebuggerUISDK)
    func showDebugUI() {
        guard let presenter = UIApplication.shared.topOnTopViewController() else { return }
        ATDebuggerAPI.sharedInstance().showDebugger(
            in: presenter,
            show: .present,
            debugkey: TopOnConfig.debugKey
        )
    }
    #endif
}
