//------------------------------------------------------------------------------
//  File:          FormViewModel.swift
//  Author(s):     Bread Financial
//  Date:          27 March 2025
//
//  Descriptions:  This file is part of the BreadPartnersSDK for iOS,
//  providing UI components and functionalities to integrate Bread Financial
//  services into partner applications.
//
//  © 2025 Bread Financial
//------------------------------------------------------------------------------

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
    @Published var overlayResponse2: UIViewController?
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
        
        /// Prepare popup styling configuration object for each style elemnt
        let popUpStyling = PopUpStyling(
            loaderColor: formData.popupStyleThemes!.primaryColor,
            crossColor: formData.popupStyleThemes!.primaryColor,
            dividerColor: formData.popupStyleThemes!.boxColor,
            borderColor: formData.popupStyleThemes!.boxColor.cgColor,
            titlePopupTextStyle: PopupTextStyle(
                font: UIFont(
                    name: formData.fontName, size: Double(formData.popupStyleThemes!.xlargeTextSize)),
                textColor: formData.popupStyleThemes!.darkColor
            ),
            subTitlePopupTextStyle: PopupTextStyle(
                font: UIFont(
                    name: formData.fontName, size: Double(formData.popupStyleThemes!.mediumTextSize)),
                textColor: formData.popupStyleThemes!.lightColor
            ),
            headerPopupTextStyle: PopupTextStyle(
                font: UIFont(
                    name: formData.fontName, size: Double(formData.popupStyleThemes!.mediumTextSize)),
                textColor: formData.popupStyleThemes!.darkColor
            ),
            headerBgColor: formData.popupStyleThemes!.boxColor,
            headingThreePopupTextStyle: PopupTextStyle(
                font: UIFont(
                    name: formData.fontName, size: Double(formData.popupStyleThemes!.largeTextSize)),
                textColor: formData.popupStyleThemes!.primaryColor
            ),
            paragraphPopupTextStyle: PopupTextStyle(
                font: UIFont(
                    name: formData.fontName, size: Double(formData.popupStyleThemes!.smallTextSize)),
                textColor: formData.popupStyleThemes!.lightColor
            ),
            connectorPopupTextStyle: PopupTextStyle(
                font: UIFont(
                    name: formData.fontName, size: Double(formData.popupStyleThemes!.largeTextSize)),
                textColor: formData.popupStyleThemes!.darkColor
            ),
            disclosurePopupTextStyle: PopupTextStyle(
                font: UIFont(
                    name: formData.fontName, size: Double(formData.popupStyleThemes!.smallTextSize)),
                textColor: formData.popupStyleThemes!.lightColor
            ),
            actionButtonStyle: PopupActionButtonStyle(
                font: UIFont(
                    name: formData.fontName, size: Double(formData.popupStyleThemes!.mediumTextSize)),
                textColor: .white,
                backgroundColor: formData.popupStyleThemes!.primaryColor,
                cornerRadius: formData.popupStyleThemes!.cornerRadius,
                padding: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
            )
        )
                
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
                    ),
                    popUpStyling: formData.stylePopup ? popUpStyling : nil
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
                        break
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
                        locality: formData.city,
                        region: formData.state,
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
                        break
                    }
                }

            }
        }
    }
    
    func openExperienceForPlacement(formData: PlacementFormData) {
        isLoading = true
        textWithLinkResponse = nil
        textWithButton = nil
//        overlayResponse = nil
        error = nil
        logs = "No Logs"

        Task {

            await BreadPartnersSDK.shared.setup(
                environment: BreadPartnersEnvironment.stage,
                integrationKey: "217a0943-8031-457d-b9e3-7375c8af3a22",
                enableLog: true
            )

            await BreadPartnersSDK.shared.openExperienceForPlacement(
                merchantConfiguration: MerchantConfiguration(
                    env: BreadPartnersEnvironment.stage,
                    channel: "X",
                    subchannel: "X"
                ),
                placementsConfiguration: PlacementConfiguration(
                    placementData: PlacementData(
                        placementId: "a0348301-dc9a-4c34-b68d-dacb40fe3696",
                        domID: "", order: Order(
                            totalPrice: CurrencyValue(
                                currency: "USD", value: 0)
                        )
                    )
                ),
                forSwiftUI: true
            ) { event in
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch event {
                    case .renderPopupView(let popupView):
                        self.overlayResponse2 = popupView
                    case .sdkError(let error):
                        self.logs += "\n" + error.localizedDescription
                    case .onSDKEventLog(let logs):
                        self.logs += "\n" + "\(logs)"
                    default:
                        break
                    }
                }

            }
        }
    }
}
