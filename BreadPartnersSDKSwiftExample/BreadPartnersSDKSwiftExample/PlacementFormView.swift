//------------------------------------------------------------------------------
//  File:          PlacementFormView.swift
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
import SwiftUI

struct PlacementFormView: View {
    @StateObject private var viewModel = FormViewModel()
    @State private var formData = PlacementFormData()
    @State private var isExpanded: Bool = false

    @State private var isLoading = false
    @State private var error: String? = nil

    var body: some View {
        Form {
            DisclosureGroup("Placement Info", isExpanded: $isExpanded) {
                TextField(
                    "Placement ID", text: $formData.placementId)
                TextField("Amount", text: $formData.amount)
                Picker("Location Type", selection: $formData.location) {
                    ForEach(RTPSFormData.locationTypes, id: \.self) { option in
                        Text(option.rawValue.capitalized).tag(option)
                    }
                }
                .pickerStyle(MenuPickerStyle())

                Picker("Financial Type", selection: $formData.financial) {
                    ForEach(RTPSFormData.financialType, id: \.self) { option in
                        Text(option.rawValue.capitalized).tag(option)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                TextField("Loyalty ID", text: $formData.loyaltyId)
                TextField("Campaign ID", text: $formData.campaignID)
                TextField("Store Number", text: $formData.storeNumber)
                TextField("Override Key", text: $formData.overrideKey)
                TextField("Department ID", text: $formData.departmentId)
            }

            DisclosureGroup("Cardholder Info") {
                TextField(
                    "Cardholder Tier", text: $formData.cardholderTier)
                TextField("Channel", text: $formData.channel)
                TextField("Sub Channel", text: $formData.subchannel)
                TextField(
                    "Client Variable 1", text: $formData.clientVar1)
                TextField(
                    "Client Variable 2", text: $formData.clientVar2)
                TextField(
                    "Client Variable 3", text: $formData.clientVar3)
                TextField(
                    "Client Variable 4", text: $formData.clientVar4)
            }

            DisclosureGroup("Checkout Settings") {
                Toggle("Allow Checkout", isOn: $formData.allowCheckout)
                TextField(
                    "Selected Card Key", text: $formData.selectedCardKey
                )
                TextField(
                    "Default Selected Card Key",
                    text: $formData.defaultSelectedCardKey)
                TextField("Account ID", text: $formData.accountId)
                TextField(
                    "Application ID", text: $formData.applicationId)
                TextField(
                    "Invoice Number", text: $formData.invoiceNumber)
                Picker("Payment Mode", selection: $formData.paymentMode) {
                    ForEach(PlacementFormData.paymentModes, id: \.self) {
                        Text($0)
                    }
                }
                TextField(
                    "Provider Config", text: $formData.providerConfig)
                Toggle(
                    "Skip Verification",
                    isOn: $formData.skipVerification)
            }

            DisclosureGroup("EpJs Config") {

                Picker("SDK Env", selection: $formData.sdkEnv) {
                    ForEach(RTPSFormData.sdkEnvs, id: \.self) { option in
                        Text(option.rawValue.capitalized).tag(option)
                    }
                }
                .pickerStyle(MenuPickerStyle())

                TextField("API Key", text: $formData.apiKey)

                Toggle("Enable Logs", isOn: $formData.enableLog)

            }

            DisclosureGroup("Placement Style") {
                DynamicFonts(formData: $formData)

                DynamicColors(formData: $formData)

                Toggle(
                    "Separate Link & Button",
                    isOn: $formData.separateTextAndButton
                ).padding(
                    EdgeInsets.init(
                        top: 5, leading: 0, bottom: 10, trailing: 0))
            }

            DisclosureGroup("Popup Styling") {
                DynamicPopupStyles(formData: $formData)
            }
            
            Section {
                Button(action: {
                    hideKeyboard()
                    viewModel.generatePlacements(formData: formData)
                }) {
                    Text("Generate Placement").frame(
                        maxWidth: .infinity, maxHeight: .infinity)
                }
                .disabled(viewModel.isLoading)

                if let error = viewModel.error {
                    Section(header: Text("Error")) {
                        Text(error.localizedDescription)
                            .foregroundColor(.red)
                    }
                }

                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(
                            maxWidth: .infinity, maxHeight: .infinity)

                } else {
                    if let textWithLinkResponse = viewModel
                        .textWithLinkResponse
                    {
                        textWithLinkResponse
                            .linkColor(formData.secondaryColor)
                            .linkFont(
                                formData.fontName,
                                fontSize: formData.fontSize
                            )
                            .font(
                                .custom(
                                    formData.fontName,
                                    size: formData.fontSize)
                            )
                            .foregroundStyle(formData.primaryColor)
                            .bold()
                    }
                    if let textWithButton = viewModel.textWithButton {
                        textWithButton.0
                            .textColor(formData.primaryColor)
                            .font(
                                .custom(
                                    formData.fontName,
                                    size: formData.fontSize))

                        textWithButton.1
                            .font(
                                .custom(
                                    formData.fontName,
                                    size: formData.fontSize)
                            )
                            .textColor(Color.white)
                            .backgroundColor(Color.blue)
                            .cornerRadius(8)
                            .alignment(.trailing)
                    }
                }
            }

            Section {
                DisclosureGroup("Logs") {
                    if formData.enableLog {
                        Text(viewModel.logs).font(
                            .custom(
                                "Arial", size: 12)
                        )
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }

        }.onChange(of: viewModel.overlayResponse) {
            oldPopupView, newPopupView in
            guard let popup = newPopupView else { return }
            presentPopup(popup)
        }
    }
}
