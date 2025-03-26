import Foundation

@available(iOS 15, *)
extension PopupController {

    func fetchWebViewPlacement() async {
        let builder = PlacementRequestBuilder(
            integrationKey: integrationKey,
            merchantConfiguration: merchantConfiguration,
            placementConfig: placementsConfiguration?.placementData,
            environment: APIUrl.currentEnvironment)
        let placementRequest = builder.build()
        
        let request = PlacementRequest(
            placements: [
                PlacementRequestBody(
                    id: popupModel.primaryActionButtonAttributes?
                        .dataContentFetch,
                    context: placementRequest.placements?.first?.context
                )
            ],
            brandId: integrationKey
        )
        await fetchData(requestBody: AnySendable(value: request))
    }

    private func fetchData(requestBody: AnySendable) async {
        let apiUrl = APIUrl(urlType: .generatePlacements).url
        do {
            let response = try await apiClient.request(
                urlString: apiUrl, method: .POST, body: requestBody)
            await handleResponse(response)
        } catch {
            await  alertHandler.showAlert(
                title: Constants.nativeSDKAlertTitle(),
                message: Constants.apiError(
                    message: error.localizedDescription),
                showOkButton: true
            )
        }
    }

    private func handleResponse(_ response: AnySendable) async {
        do {
            let responseModel: PlacementsResponse =
                try await commonUtils.decodeJSON(
                    from: response, to: PlacementsResponse.self)
            guard
                let popupPlacementHTMLContent = responseModel.placementContent?
                    .first,
                let popupPlacementModel = try await HTMLContentParser()
                    .extractPopupPlacementModel(
                        from: popupPlacementHTMLContent.contentData?.htmlContent
                            ?? ""
                    )
            else {
                await alertHandler.showAlert(
                    title: Constants.nativeSDKAlertTitle(),
                    message: Constants.popupPlacementParsingError,
                    showOkButton: true
                )
                return
            }

            self.webViewPlacementModel = popupPlacementModel
        } catch {
            await alertHandler.showAlert(
                title: Constants.nativeSDKAlertTitle(),
                message: Constants.catchError(
                    message: error.localizedDescription),
                showOkButton: true
            )
        }
    }

}
