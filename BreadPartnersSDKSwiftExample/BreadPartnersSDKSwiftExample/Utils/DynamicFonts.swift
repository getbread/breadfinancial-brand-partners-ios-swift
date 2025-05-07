//------------------------------------------------------------------------------
//  File:          DynamicFonts.swift
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

struct DynamicFonts: View {
    
    @Binding var formData: PlacementFormData

    @State private var fontSize: CGFloat = 16
    @State private var selectedFont: String = "ArialMT"
    
    let fonts = ["Noteworthy-Light", "Georgia-Bold", "Verdana-Bold", "Avenir-Heavy", "Zapfino"]
    
    var fontMapping: [String: String] = [
        "Noteworthy-Light": "Noteworthy-Light",
        "Georgia-Bold": "Georgia-Bold",
        "Verdana-Bold": "Verdana-Bold",
        "Avenir-Heavy": "Avenir-Heavy",
        "Zapfino": "Zapfino"
    ]
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            HStack {
                Text("Font Size ")
                Slider(value: $formData.fontSize, in: 12...32, step: 1)
            }
            
            Menu {
                ForEach(fonts, id: \.self) { font in
                    Button(action: {
                        selectedFont = font
                        formData.fontName = font
                    }) {
                        Text(font)
                    }
                }
            } label: {
                Text("Select Font: \(selectedFont)")
                    .padding()
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(8)
            }            
        }
        .padding()
    }
}
