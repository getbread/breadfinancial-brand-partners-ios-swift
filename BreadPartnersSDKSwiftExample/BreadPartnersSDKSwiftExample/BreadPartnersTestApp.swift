//------------------------------------------------------------------------------
//  File:          BreadPartnersTestApp.swift
//  Author(s):     Bread Financial
//  Date:          27 March 2025
//
//  Descriptions:  This file is part of the BreadPartnersSDK for iOS,
//  providing UI components and functionalities to integrate Bread Financial
//  services into partner applications.
//
//  © 2025 Bread Financial
//------------------------------------------------------------------------------

import SwiftUI

@main
struct BreadPartnersTestApp: App {
    @StateObject private var model = BreadPartnersTestAppVewModel()

    var body: some Scene {
        WindowGroup {
            if !model.isSetupComplete {
                ProgressView("Setting up...")
                    .progressViewStyle(CircularProgressViewStyle())
            } else {
                FormView()
            }
        }
    }
}
