import BreadPartnersSDKSwift
import SwiftUICore

// MARK: - Form Data Model
struct PlacementFormData {
    // Constants for dropdowns
    static let paymentModes = ["FULL", "SPLIT"]
    static let hostEnvs = [
        "QA", "STAGE", "QA_AZ", "PROD", "STAGE_AZ", "PROD_AZ",
    ]
    static let sdkEnvs = BreadPartnersEnvironment.allCases
    static let locationTypes = BreadPartnersLocationType.allCases
    static let financialType = BreadPartnersFinancingType.allCases
    static let fmcApiEnvs = ["DEV", "UAT", "PROD"]
    static let adserverApiEnvs = ["LOCAL", "DEV", "QA", "STAGE", "PROD"]

    var placementId = TestAppConstants.placementID1
    var amount = "119900"
    var location = BreadPartnersLocationType.checkout
    var financial = BreadPartnersFinancingType.installments
    var loyaltyId = ""
    var campaignID = ""
    var storeNumber = ""
    var overrideKey = ""
    var departmentId = ""
    var cardholderTier = ""
    var channel = ""
    var subchannel = ""
    var clientVar1 = ""
    var clientVar2 = ""
    var clientVar3 = ""
    var clientVar4 = ""
    var allowCheckout = false
    var selectedCardKey = ""
    var defaultSelectedCardKey = ""
    var accountId = ""
    var applicationId = ""
    var invoiceNumber = ""
    var paymentMode = "FULL"
    var providerConfig = ""
    var skipVerification = false
    var sdkHostEnv = "STAGE"
    var sdkEnv = BreadPartnersEnvironment.stage
    var fmcApiEnv = "UAT"
    var adserverApiEnv = "PROD"
    var apiKey = TestAppConstants.brandID
    var clientName = TestAppConstants.clientName
    var enableLog = true
    var enableAnalytics = false
    var enableSessionData = false
    var sdkTid = ""
    var env = BreadPartnersEnvironment.stage
    var uqpParams = "embedded=true&clientKey=\(TestAppConstants.brandID)"
    var fontName = "Gentium Plus"
    var fontSize = 16.0
    var primaryColor = Color.black
    var secondaryColor = Color.blue
    var separateTextAndButton = false
}
