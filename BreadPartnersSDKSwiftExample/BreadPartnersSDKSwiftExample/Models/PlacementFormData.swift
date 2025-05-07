//------------------------------------------------------------------------------
//  File:          PlacementFormData.swift
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
import SwiftUICore
import UIKit

// MARK: - Form Data Model
struct PlacementFormData: @unchecked Sendable {
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
    var fontName = "ArialMT"
    var fontSize = 16.0
    var primaryColor = Color.black
    var secondaryColor = Color.blue
    var separateTextAndButton = false
    var stylePopup = false
    var popupStyleThemes = popupStyleThemeConst.first
}

struct PopupStyleThemes: @unchecked Sendable {
    let name: String
    let primaryColor: UIColor
    let lightColor: UIColor
    let darkColor: UIColor
    let boxColor: UIColor
    let smallTextSize: CGFloat
    let mediumTextSize: CGFloat
    let largeTextSize: CGFloat
    let xlargeTextSize: CGFloat
    let cornerRadius: CGFloat
}

let popupStyleThemeConst: [PopupStyleThemes] = [
    PopupStyleThemes(
        name: "Green",
        primaryColor: UIColor(hex: "#28A745"),
        lightColor: UIColor(hex: "#68ba7b"),
        darkColor: UIColor(hex: "#19692C"),
        boxColor: UIColor(hex: "#E6F9EF"),
        smallTextSize: 13,
        mediumTextSize: 16,
        largeTextSize: 19,
        xlargeTextSize: 22,
        cornerRadius: 0
    ),
    PopupStyleThemes(
        name: "Blue",
        primaryColor: UIColor(hex: "#007BFF"),
        lightColor: UIColor(hex: "#6da3de"),
        darkColor: UIColor(hex: "#003F7F"),
        boxColor: UIColor(hex: "#EAF4FF"),
        smallTextSize: 16,
        mediumTextSize: 19,
        largeTextSize: 22,
        xlargeTextSize: 26,
        cornerRadius: 10
    ),
    PopupStyleThemes(
        name: "Orange",
        primaryColor: UIColor(hex: "#FF8C00"),
        lightColor: UIColor(hex: "#FFDAB9"),
        darkColor: UIColor(hex: "#8B4500"),
        boxColor: UIColor(hex: "#FFF4E5"),
        smallTextSize: 18,
        mediumTextSize: 22,
        largeTextSize: 24,
        xlargeTextSize: 26,
        cornerRadius: 25
    ),
    PopupStyleThemes(
        name: "Purple",
        primaryColor: UIColor(hex: "#800080"),
        lightColor: UIColor(hex: "#D8BFD8"),
        darkColor: UIColor(hex: "#4B0082"),
        boxColor: UIColor(hex: "#F5F0FF"),
        smallTextSize: 20,
        mediumTextSize: 24,
        largeTextSize: 26,
        xlargeTextSize: 28,
        cornerRadius: 50
    )
]
