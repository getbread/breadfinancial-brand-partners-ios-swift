//------------------------------------------------------------------------------
//  File:          Extensions.swift
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

//  Provides reusable extension methods for use across apps integrating the Bread Partners SDK.
public extension UIImageView {
    func loadImage(from url: URL, completion: @escaping (Bool) -> Void) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                    completion(true)
                }
            } else {
                DispatchQueue.main.async {
                    self.image = nil
                    completion(false)
                }
            }
        }
    }
}


public extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "")
        var hexInt: UInt64 = 0
        
        Scanner(string: hexString).scanHexInt64(&hexInt)
        
        let red = CGFloat((hexInt >> 16) & 0xFF) / 255.0
        let green = CGFloat((hexInt >> 8) & 0xFF) / 255.0
        let blue = CGFloat(hexInt & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}


extension UILabel {
    func applyTextStyle(style: PopupTextStyle) {
        if let font = style.font {
            self.font = font
        }
        
        if let textColor = style.textColor {
            self.textColor = textColor
        }
        
        if let textSize = style.textSize {
            self.font = self.font?.withSize(textSize)
        }
    }
}

extension Optional where Wrapped == String {
    func takeIfNotEmpty() -> String? {
        guard let self = self,
            !self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else {
            return nil
        }
        return self
    }
}
