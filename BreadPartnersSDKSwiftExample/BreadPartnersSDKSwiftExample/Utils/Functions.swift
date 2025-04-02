//------------------------------------------------------------------------------
//  File:          Functions.swift
//  Author(s):     Bread Financial
//  Date:          27 March 2025
//
//  Descriptions:  This file is part of the BreadPartnersSDK for iOS,
//  providing UI components and functionalities to integrate Bread Financial
//  services into partner applications.
//
//  © 2025 Bread Financial
//------------------------------------------------------------------------------

import UIKit

func presentPopup(_ popup: UIViewController) {
    guard
        let windowScene = UIApplication.shared.connectedScenes.first
            as? UIWindowScene,
        let rootVC = windowScene.windows.first?.rootViewController
    else { return }

    popup.modalPresentationStyle = .overFullScreen
    popup.modalTransitionStyle = .crossDissolve

    rootVC.present(popup, animated: true)
}

func hideKeyboard() {
    UIApplication.shared.sendAction(
        #selector(UIResponder.resignFirstResponder), to: nil, from: nil,
        for: nil)
}
