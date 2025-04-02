//------------------------------------------------------------------------------
//  File:          RTPSFormData.swift
//  Author(s):     Bread Financial
//  Date:          27 March 2025
//
//  Descriptions:  This file is part of the BreadPartnersSDK for iOS,
//  providing UI components and functionalities to integrate Bread Financial
//  services into partner applications.
//
//  © 2025 Bread Financial
//------------------------------------------------------------------------------

import SwiftUICore
import BreadPartnersSDKSwift
import Foundation

// MARK: - Form Data Model
struct RTPSFormData {
    // Constants for dropdowns
    static let paymentModes = ["FULL", "SPLIT"]
    static let hostEnvs = ["QA","STAGE", "QA_AZ","PROD","STAGE_AZ", "PROD_AZ"]
    static let sdkEnvs = BreadPartnersEnvironment.allCases
    static let fmcApiEnvs = [ "DEV", "UAT", "PROD"]
    static let adserverApiEnvs = ["LOCAL", "DEV", "QA", "STAGE", "PROD"]
    static let mockTestCase = BreadPartnersMockOptions.allCases
    static let locationTypes = BreadPartnersLocationType.allCases
    static let financialType = BreadPartnersFinancingType.allCases
    

    var firstName = "Carol"
    var middleName = ""
    var lastName = "Jones"
    var addressOne = "3075 Loyalty Cir"
    var addressTwo = ""
    var city = "Columbus"
    var state = "OH"
    var country = ""
    var zip = "43219"
    var preScreenID = ""
    var email = ""
    var mobile = ""
    var alternateMobile = ""
    var cardAmount = ""
    var cardType = ""
    var storeNumber = "2009"
    var loyaltyNumber = ""
    var customerNumber = ""
    var productAmount = ""
    var checkoutAmount = ""
    var category = ""
    var sku = ""
    var correlationData = ""
    var overrideKey = ""
    var cardChoiceCode = ""
    var departmentId = ""
    var existing = false
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
    var mockTest = BreadPartnersMockOptions.success
    var location = BreadPartnersLocationType.checkout
    var financial = BreadPartnersFinancingType.installments
    
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
    var env = "STAGE"
    var uqpParams = "embedded=true&clientKey=\(TestAppConstants.brandID)"
    var fontName = "Gentium Plus"
    var fontSize = 16.0
    var primaryColor = Color.black
    var secondaryColor = Color.blue
    var separateTextAndButton = false
}

