import Foundation

enum TopOnConfig {
    static let appID = "__TOPON_APP_ID__"
    static let appKey = "__TOPON_APP_KEY__"

    enum Placement {
        static let banner = "__TOPON_BANNER_PLACEMENT_ID__"
        static let interstitial = "__TOPON_INTERSTITIAL_PLACEMENT_ID__"
        static let rewarded = "__TOPON_REWARDED_PLACEMENT_ID__"
        static let nativeExpress = "__TOPON_NATIVE_EXPRESS_PLACEMENT_ID__"
        static let splash = "__TOPON_SPLASH_PLACEMENT_ID__"
    }

    enum Scene {
        static let banner = ""
        static let interstitial = ""
        static let rewarded = ""
        static let nativeExpress = ""
        static let splash = ""
    }

    static let debugKey = "__TOPON_DEBUG_KEY__"
    static let customChannel = ""
}
