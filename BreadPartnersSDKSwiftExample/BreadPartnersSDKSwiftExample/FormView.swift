//------------------------------------------------------------------------------
//  File:          FormView.swift
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

struct FormView: View {
    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            ?? "Unknown"
    }

    var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
    }
    var body: some View {
        NavigationView {
            TabView {
                PlacementFormView().tabItem {
                    Image(systemName: "house.fill")
                    Text("Placement")
                }
                RTPSFormView().tabItem {
                    Image(systemName: "cart.fill")
                    Text("RTPS")
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    VStack(alignment: .leading) {
                        Text("Bread Partners Swift Package Manager Example")
                            .font(.subheadline)
                            .bold().padding(.top, 8)
                        Text("App Version: v\(appVersion) (\(buildNumber))")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }

}
