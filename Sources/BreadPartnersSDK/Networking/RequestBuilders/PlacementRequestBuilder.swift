//------------------------------------------------------------------------------
//  File:          PlacementRequestBuilder.swift
//  Author(s):     Bread Financial
//  Date:          27 March 2025
//
//  Descriptions:  This file is part of the BreadPartnersSDK for iOS,
//  providing UI components and functionalities to integrate Bread Financial
//  services into partner applications.
//
//  © 2025 Bread Financial
//------------------------------------------------------------------------------

import Foundation

/// `PlacementRequestBuilder` helps create a request for placements by collecting
/// necessary details like pricing and settings. It uses given configurations to
/// build and organize placement data..
class PlacementRequestBuilder {
    private var integrationKey: String = ""
    private var placements: [PlacementRequestBody] = []
    private var brandId: String = ""

    init(
        integrationKey: String,
        merchantConfiguration: MerchantConfiguration?,
        placementConfig: PlacementData?,
        environment: BreadPartnersEnvironment?
    ) {
        self.brandId = integrationKey
        self.createPlacementRequestBody(
            merchantConfiguration: merchantConfiguration,
            placementData: placementConfig)
    }

    private func createPlacementRequestBody(
        merchantConfiguration: MerchantConfiguration?,
        placementData: PlacementData?
    ) {
        let context = ContextRequestBody(
            ENV: APIUrl.currentEnvironment.rawValue,
            LOCATION: placementData?.locationType?.rawValue,
            PRICE: placementData?.order?.totalPrice?.value,
            CARDHOLDER_TIER: merchantConfiguration?.cardholderTier
                .takeIfNotEmpty(),
            STORE_NUMBER: merchantConfiguration?.storeNumber,
            LOYALTY_ID: merchantConfiguration?.loyaltyID.takeIfNotEmpty(),
            OVERRIDE_KEY: merchantConfiguration?.overrideKey.takeIfNotEmpty(),
            CLIENT_VAR_1: merchantConfiguration?.clientVariable1
                .takeIfNotEmpty(),
            CLIENT_VAR_2: merchantConfiguration?.clientVariable2
                .takeIfNotEmpty(),
            CLIENT_VAR_3: merchantConfiguration?.clientVariable3
                .takeIfNotEmpty(),
            CLIENT_VAR_4: merchantConfiguration?.clientVariable4
                .takeIfNotEmpty(),
            DEPARTMENT_ID: merchantConfiguration?.departmentId.takeIfNotEmpty(),
            channel: merchantConfiguration?.channel.takeIfNotEmpty(),
            subchannel: merchantConfiguration?.subchannel.takeIfNotEmpty(),
            CMP: merchantConfiguration?.campaignID.takeIfNotEmpty(),
            ALLOW_CHECKOUT: placementData?.allowCheckout ?? false
        )

        let placement = PlacementRequestBody(
            id: placementData?.placementId,
            context: context
        )

        placements.append(placement)
    }

    func build() -> PlacementRequest {
        return PlacementRequest(
            placements: placements,
            brandId: brandId
        )
    }
}
