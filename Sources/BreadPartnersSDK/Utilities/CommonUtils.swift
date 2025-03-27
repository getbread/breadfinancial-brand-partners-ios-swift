import Foundation
import UIKit

/// `CommonUtils` class provides utility methods for common operations across the BreadPartner SDK.
@available(iOS 15, *)
internal actor CommonUtils: NSObject {

    private let dispatchQueue: DispatchQueue
    private let alertHandler: AlertHandler

    init(dispatchQueue: DispatchQueue, alertHandler: AlertHandler) {
        self.dispatchQueue = dispatchQueue
        self.alertHandler = alertHandler
        super.init()
    }

    func executeAfterDelay(_ delay: TimeInterval) async {
        try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
    }

    @MainActor func handleSecurityCheckFailure(error: Error?) async {
        await executeAfterDelay(2)
        await alertHandler.hideAlert()

        await executeAfterDelay(0.5)
        await alertHandler.showAlert(
            title: Constants.securityCheckFailureAlertTitle,
            message: Constants.securityCheckAlertFailedMessage(
                error: error?.localizedDescription ?? ""
            ),
            showOkButton: true
        )
    }

    @MainActor func handleSecurityCheckPassed() async {
        await executeAfterDelay(2)
        await alertHandler.hideAlert()

        await executeAfterDelay(0.5)
        await alertHandler.showAlert(
            title: Constants.securityCheckSuccessAlertTitle,
            message: Constants.securityCheckSuccessAlertSubTitle,
            showOkButton: true
        )
    }

    func getCurrentTimestamp() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let currentDate = Date()
        let formattedTimestamp = dateFormatter.string(from: currentDate)
        return formattedTimestamp
    }

    func decodeJSON<T: Decodable>(from response: Any, to type: T.Type)
        async throws -> T
    {
        do {
            let jsonData: Data

            let unwrappedResponse =
                (response as? AnySendable)?.value ?? response

            if let responseData = unwrappedResponse as? Data {
                jsonData = responseData
            } else if let responseDictionary = unwrappedResponse
                as? [String: Any]
            {
                jsonData = try JSONSerialization.data(
                    withJSONObject: responseDictionary, options: [])
            } else if let responseArray = unwrappedResponse as? [[String: Any]]
            {
                jsonData = try JSONSerialization.data(
                    withJSONObject: responseArray, options: [])
            } else {
                throw NSError(
                    domain: "JSONDecodingError",
                    code: 1,
                    userInfo: [
                        NSLocalizedDescriptionKey: "Unsupported JSON structure"
                    ]
                )
            }

            // Initialize JSON decoder
            let decoder = JSONDecoder()

            // Decode to the expected type
            let decodedObject = try decoder.decode(T.self, from: jsonData)

            return decodedObject
        } catch {
            throw error
        }
    }

    /// Builds a URL for RTPS Web based on the provided integration and configuration details.
    /// - Parameters:
    ///   - integrationKey: The unique integration key for the request.
    ///   - merchantConfiguration: Configuration details for the buyer and store.
    ///   - rtpsData: Configuration for RTPS settings, including mock responses and prescreen data.
    /// - Returns: A URL constructed with the given parameters, or nil if the URL could not be built.
    func buildRTPSWebURL(
        integrationKey: String,
        merchantConfiguration: MerchantConfiguration,
        rtpsData: RTPSData,
        prescreenId: Int
    ) async -> URL? {

        let queryParams: [String: String?] = [
            "mockMO": rtpsData.mockResponse?.rawValue,
            "mockPA": rtpsData.mockResponse?.rawValue,
            "mockVL": rtpsData.mockResponse?.rawValue,
            "embedded": "true",
            "clientKey": integrationKey,
            "prescreenId": "\(prescreenId)",
            "cardType": rtpsData.cardType,
            "urlPath": "screen name",
            "firstName": merchantConfiguration.buyer?.givenName,
            "lastName": merchantConfiguration.buyer?.familyName,
            "address1": merchantConfiguration.buyer?.billingAddress?.address1,
            "city": merchantConfiguration.buyer?.billingAddress?.locality,
            "state": merchantConfiguration.buyer?.billingAddress?.region,
            "zip": merchantConfiguration.buyer?.billingAddress?.postalCode,
            "storeNumber": merchantConfiguration.storeNumber,
            "location": rtpsData.locationType?.rawValue,
            "channel": rtpsData.channel,
        ]

        guard
            var urlComponents = URLComponents(
                string: APIUrl(urlType: .rtpsWebUrl(type: "offer")).url)
        else {
            return nil
        }

        await Task {
            urlComponents.queryItems = queryParams.compactMap { key, value in
                guard let value = value, !value.isEmpty else { return nil }
                return URLQueryItem(name: key, value: value)
            }
        }.value

        return urlComponents.url
    }

    @MainActor func getUserAgent() -> String {
        let systemName = UIDevice.current.systemName  // e.g., "iOS"
        let systemVersion = UIDevice.current.systemVersion  // e.g., "17.2"
        let deviceModel = UIDevice.current.model  // e.g., "iPhone"

        return "\(deviceModel): \(systemName) \(systemVersion)"  // iPhone; iOS 18.2
    }

}
