import Foundation

/// Enum to define different types of API URLs.
internal enum APIUrlType {
    case rtpsWebUrl(type: String)
    case brandStyle(brandId: String)
    case brandConfig(brandId: String)
    case generatePlacements
    case viewPlacement
    case clickPlacement
    case prescreen
    case virtualLookup
}

internal actor APIUrl {

    static var currentEnvironment: BreadPartnersEnvironment = .prod

    private let baseURL: String
    private let rtpsBaseURL: String
    private let urlType: APIUrlType

    /// Initializer for APIUrl with a configurable URL type
    init(urlType: APIUrlType) {
        self.urlType = urlType

        switch APIUrl.currentEnvironment {
        case .stage:
            self.baseURL = "https://brands.kmsmep.com"
            self.rtpsBaseURL = "https://acquire1uat.comenity.net"
        case .prod:
            self.baseURL = "https://brands.kmsmep.com"
            self.rtpsBaseURL = "https://acquire1.comenity.net"
        }
    }

    /// Set the environment
    static func setEnvironment(_ environment: BreadPartnersEnvironment) async {
        currentEnvironment = environment
    }

    /// Generates the correct URL based on the URL type
    nonisolated var url: String {
        switch urlType {
        case .rtpsWebUrl(let type):
            return "\(rtpsBaseURL)/prescreen/\(type)"
        case .brandStyle(let brandId):
            return "\(baseURL)/brands/\(brandId)/style"
        case .brandConfig(let brandId):
            return "\(baseURL)/brands/\(brandId)/config"
        case .generatePlacements:
            return "\(baseURL)/generatePlacements"
        case .viewPlacement:
            return "\(baseURL)/ep/v1/view-placement"
        case .clickPlacement:
            return "\(baseURL)/ep/v1/click-placement"
        case .prescreen:
            return "\(rtpsBaseURL)/api/prescreen"
        case .virtualLookup:
            return "\(rtpsBaseURL)/api/virtual_lookup"
        }
    }
}
