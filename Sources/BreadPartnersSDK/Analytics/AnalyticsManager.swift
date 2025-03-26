import Foundation
import UIKit

/// AnalyticsManager logs user interactions with placements in the app.
/// It tracks two events:
/// 1. **Click Placement**: When the user clicks on the placement.
/// 2. **View Placement**: When the user sees or interacts with the placement without clicking.
@available(iOS 15, *)
internal actor AnalyticsManager {

    private let apiClient: APIClient
    private let commonUtils: CommonUtils
    private let dispatchQueue: DispatchQueue

    init(
        apiClient: APIClient,
        commonUtils: CommonUtils,
        dispatchQueue: DispatchQueue
    ) {
        self.apiClient = apiClient
        self.commonUtils = commonUtils
        self.dispatchQueue = dispatchQueue
    }

    private var apiKey: String = ""

    func setApiKey(_ newApiKey: String) {
        apiKey = newApiKey
    }

    private func sendAnalyticsPayload(
        apiUrl: String, payload: Analytics.Payload
    ) async {
        let headers: [String: String] = [
            Constants.headerAuthorityKey: Constants.headerAuthorityValue,
            Constants.headerAcceptKey: Constants.headerAcceptValue,
            Constants.headerAcceptEncodingKey: Constants
                .headerAcceptEncodingValue,
            Constants.headerAcceptLanguageKey: Constants
                .headerAcceptLanguageValue,
            Constants.headerAccessControlRequestHeadersKey: Constants
                .headerAccessControlRequestHeadersValue,
            Constants.headerAccessControlRequestMethodKey: Constants
                .headerAccessControlRequestMethodValue,
        ]

        do {
            _ = try await apiClient.request(
                urlString: apiUrl, method: .OPTIONS, headers: headers,
                body: payload)
        } catch {
        }
    }
    /// TODO: Setup analytics payload
    private func createAnalyticsPlacementPayload(
        name: String, placementResponse: PlacementsResponse
    ) async -> Analytics.Payload {
        let timestamp = await commonUtils.getCurrentTimestamp()

        return await Analytics.Payload(
            name: name,
            props: Analytics.Props(
                eventProperties: Analytics.EventProperties(
                    placement: Analytics.Placement(
                        id: placementResponse.placements?.first?.id,
                        placementContentId: placementResponse.placementContent?
                            .first?.id,
                        overlayContentId: placementResponse.placementContent?
                            .first?.id),
                    placementContent: Analytics.PlacementContent(
                        id: placementResponse.placementContent?.first?.id,
                        contentType: placementResponse.placementContent?.first?
                            .contentType,
                        metadata: placementResponse.placementContent?.first?
                            .metadata
                    ),
                    metadata: [
                        "location": placementResponse.placements?.first?
                            .renderContext?.LOCATION
                    ],
                    actionTarget: nil
                ),
                userProperties: [:]
            ),
            context: Analytics.Context(
                timestamp: timestamp,
                apiKey: apiKey,
                browserCtx: Analytics.BrowserCtx(
                    library: Analytics.Library(
                        name: "bread-partners-sdk-ios", version: "0.0.1"),
                    userAgent: await commonUtils.getUserAgent(),
                    page: Analytics.Page(
                        path: "ToDo",
                        url: nil
                    )
                ),
                trackingInfo: Analytics.TrackingInfo(
                    userTrackingId: placementResponse.placements?.first?
                        .renderContext?.SDK_TID,
                    sessionTrackingId: "ToDO")
            )
        )
    }

    private func sendPlacementAnalytics(
        name: String, placementResponse: PlacementsResponse,
        apiUrlType: APIUrlType
    ) async {
        let payload = await createAnalyticsPlacementPayload(
            name: name, placementResponse: placementResponse)
        let apiUrl = APIUrl(urlType: apiUrlType).url
        await sendAnalyticsPayload(apiUrl: apiUrl, payload: payload)
    }

    func sendViewPlacement(placementResponse: PlacementsResponse) async {
        await sendPlacementAnalytics(
            name: "view-placement", placementResponse: placementResponse,
            apiUrlType: .viewPlacement)
    }

    func sendClickPlacement(placementResponse: PlacementsResponse) async {
        await sendPlacementAnalytics(
            name: "click-placement", placementResponse: placementResponse,
            apiUrlType: .clickPlacement)
    }
}
