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
