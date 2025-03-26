import BreadPartnersSDKSwift
import Foundation
import UIKit

// MARK: - View Models
@MainActor
class FormViewModel: ObservableObject {

    @Published var textWithLinkResponse: BreadPartnerLinkTextSwitUI?
    @Published var textWithButton:
        (BreadPartnerTextView, BreadPartnerButtonView)?

    @Published var overlayResponse: UIViewController?
    @Published var isLoading = false
    @Published var error: Error?

    @Published var logs: String = "No Logs"

    func generatePlacements(formData: PlacementFormData) {
        isLoading = true
        textWithLinkResponse = nil
        textWithButton = nil
        overlayResponse = nil
        error = nil
        logs = "No Logs"

        Task {

            await BreadPartnersSDK.shared.setup(
                environment: formData.sdkEnv,
                integrationKey: formData.apiKey,
                enableLog: formData.enableLog
            )

            await BreadPartnersSDK.shared.registerPlacements(
                merchantConfiguration: MerchantConfiguration(
                    loyaltyID: formData.loyaltyId,
                    campaignID: formData.campaignID,
                    storeNumber: formData.storeNumber,
                    departmentId: formData.departmentId,
                    cardholderTier: formData.cardholderTier,
                    env: formData.sdkEnv,
                    channel: formData.channel,
                    subchannel: formData.subchannel,
                    overrideKey: formData.overrideKey
                ),
                placementsConfiguration: PlacementConfiguration(
                    placementData: PlacementData(
                        financingType: formData.financial,
                        locationType: formData.location,
                        placementId: formData.placementId,
                        domID: "123", allowCheckout: formData.allowCheckout,
                        order: Order(
                            totalPrice: CurrencyValue(
                                currency: "USD", value: Double(formData.amount))
                        ),
                        defaultSelectedCardKey: formData.defaultSelectedCardKey,
                        selectedCardKey: formData.selectedCardKey
                    )
                ),
                splitTextAndAction: formData.separateTextAndButton,
                forSwiftUI: true
            ) { event in
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch event {
                    case .renderSwiftUITextViewWithLink(let textView):
                        self.textWithLinkResponse = textView
                    case .renderSwiftUISeparateTextAndButton(
                        let textView, let button):
                        self.textWithButton = (textView, button)
                    case .renderPopupView(let popupView):
                        self.overlayResponse = popupView
                    case .sdkError(let error):
                        self.logs += "\n" + error.localizedDescription
                    case .onSDKEventLog(let logs):
                        self.logs += "\n" + "\(logs)"
                    default:
                        print("Event::\(event)")
                    }
                }

            }
        }
    }

    func rtpsCall(formData: RTPSFormData) {
        isLoading = true
        overlayResponse = nil
        error = nil
        logs = "No Logs"

        Task {

            await BreadPartnersSDK.shared.setup(
                environment: formData.sdkEnv,
                integrationKey: formData.apiKey,
                enableLog: formData.enableLog
            )
            try? await Task.sleep(nanoseconds: UInt64(1_500_000_000))

            let rtpsData1 = RTPSData(
                order: Order(
                    totalPrice: CurrencyValue(
                        currency: "USD",
                        value: Double(formData.productAmount))
                ), locationType: formData.location,
                prescreenId: Int(formData.preScreenID),
                mockResponse: formData.mockTest
            )

            let placementsConfiguration2 = PlacementConfiguration(
                rtpsData: rtpsData1
            )

            let merchantConfiguration2 = MerchantConfiguration(
                buyer: BreadPartnersBuyer(
                    givenName: formData.firstName,
                    familyName: formData.lastName,
                    additionalName: formData.middleName,
                    billingAddress: BreadPartnersAddress(
                        address1: formData.addressOne,
                        locality: formData.state,
                        region: formData.city,
                        postalCode: formData.zip)
                ),
                storeNumber: formData.storeNumber
            )

            await BreadPartnersSDK.shared.silentRTPSRequest(
                merchantConfiguration: merchantConfiguration2,
                placementsConfiguration: placementsConfiguration2
            ) { event in
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch event {
                    case .renderPopupView(let popupView):
                        self.overlayResponse = popupView
                    case .sdkError(let error):
                        self.logs += "\n" + error.localizedDescription
                    case .onSDKEventLog(let logs):
                        self.logs += "\n" + "\(logs)"
                    default:
                        print("Event::\(event)")
                    }
                }

            }
        }
    }
}
