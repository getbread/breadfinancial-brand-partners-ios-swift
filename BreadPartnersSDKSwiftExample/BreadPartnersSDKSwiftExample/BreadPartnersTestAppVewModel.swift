//------------------------------------------------------------------------------
//  File:          BreadPartnersTestAppVewModel.swift
//  Author(s):     Bread Financial
//  Date:          27 March 2025
//
//  Descriptions:  This file is part of the BreadPartnersSDK for iOS,
//  providing UI components and functionalities to integrate Bread Financial
//  services into partner applications.
//
//  © 2025 Bread Financial
//------------------------------------------------------------------------------

//
//  ViewModel.swift
//  BreadPartnersSampleApp
//
//  Created by SINGHAL, SHUBHAM on 06/03/25.
//
import BreadPartnersSDKSwift
import Combine
import Foundation

@MainActor
class BreadPartnersTestAppVewModel: ObservableObject {
    @Published var isSetupComplete = false
    
    init() {
        defer {
            Task {
                self.isSetupComplete = true
            }
        }
    }
}
