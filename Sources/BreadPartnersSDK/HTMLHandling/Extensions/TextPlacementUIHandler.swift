//------------------------------------------------------------------------------
//  File:          TextPlacementUIHandler.swift
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

extension HTMLContentRenderer {

    /// Renders a text view and action button for either SwiftUI or UIKit.
    func renderTextAndButton() {
        if forSwiftUI {
            let plainTextView = createSwiftUIPlainTextView()
            let actionButton = createSwiftUIActionButton()

            self.callback(
                .renderSwiftUISeparateTextAndButton(
                    textView: plainTextView, button: actionButton)
            )

        } else {
            let plainTextView = createPlainTextView()

            let actionButton = createActionButton()

            self.callback(
                .renderSeparateTextAndButton(
                    textView: plainTextView, button: actionButton))
        }
    }

    /// Renders a text view with a clickable link, either for SwiftUI or UIKit.
    func renderTextViewWithLink() {

        var contentText = textPlacementModel?.contentText ?? ""
        var actionLink = textPlacementModel?.actionLink ?? ""
        let actionType = textPlacementModel?.actionType
        let htmlContent = textPlacementModel?.htmlContent

        // For NO_ACTION type, render as formatted HTML text that's clickable (triggers textClicked callback)
        if actionType == PlacementActionType.noAction.rawValue,
           let htmlString = htmlContent, !htmlString.isEmpty {
            
            // Convert HTML to attributed string
            if let attributedString = htmlString.htmlToAttributedString() {
                // Create a mutable copy to remove any link attributes and underlines
                let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
                let range = NSRange(location: 0, length: mutableAttributedString.length)
                mutableAttributedString.removeAttribute(.link, range: range)
                mutableAttributedString.removeAttribute(.underlineStyle, range: range)
                
                // Apply configurable font sizes while preserving formatting (bold, superscript, etc.)
                let baseFontSize: CGFloat = 18.0 // Default base font size
                let superscriptFontSize: CGFloat = 12.0 // Default superscript font size
                
                mutableAttributedString.enumerateAttributes(in: range, options: []) { attributes, attrRange, _ in
                    // Check if this is superscript by looking for baseline offset
                    let baselineOffset = attributes[.baselineOffset] as? NSNumber
                    let isSuperscript = (baselineOffset?.floatValue ?? 0) > 0
                    
                    if let currentFont = attributes[.font] as? UIFont {
                        // Use smaller size for superscript, regular size for normal text
                        let newSize = isSuperscript ? superscriptFontSize : baseFontSize
                        
                        // Preserve font traits (bold, italic)
                        let fontDescriptor = currentFont.fontDescriptor
                        let newFontDescriptor = fontDescriptor.withSize(newSize)
                        let newFont = UIFont(descriptor: newFontDescriptor, size: newSize)
                        
                        mutableAttributedString.addAttribute(.font, value: newFont, range: attrRange)
                    } else {
                        // If no font attribute, add default font
                        let defaultSize = isSuperscript ? superscriptFontSize : baseFontSize
                        let defaultFont = UIFont.systemFont(ofSize: defaultSize)
                        mutableAttributedString.addAttribute(.font, value: defaultFont, range: attrRange)
                    }
                }
                
                if forSwiftUI {
                    // Use the new initializer that accepts attributed string to preserve HTML formatting
                    let swiftUIView = BreadPartnerLinkTextSwitUI(
                        attributedString: mutableAttributedString,
                        onTap: {
                            Task {
                                await self.handleLinkInteraction(link: "")
                            }
                        }
                    )
                    self.callback(.renderSwiftUITextViewWithLink(textView: swiftUIView))
                } else {
                    // For UIKit, use BreadPartnerLinkText with HTML attributed string
                    let textView = BreadPartnerLinkText()
                    textView.configure(with: mutableAttributedString) { [self] _ in
                        Task {
                            await handleLinkInteraction(link: "")
                        }
                    }
                    self.callback(.renderTextViewWithLink(textView: textView))
                }
            } else {
                // Fallback to plain text if HTML conversion fails
                if forSwiftUI {
                    let swiftUIView = BreadPartnerLinkTextSwitUI(
                        contentText,
                        links: [],
                        onTap: {
                            Task {
                                await self.handleLinkInteraction(link: "")
                            }
                        }
                    )
                    self.callback(.renderSwiftUITextViewWithLink(textView: swiftUIView))
                } else {
                    let textView = BreadPartnerLinkText()
                    let plainAttributedString = NSAttributedString(string: contentText)
                    textView.configure(with: plainAttributedString) { [self] _ in
                        Task {
                            await handleLinkInteraction(link: "")
                        }
                    }
                    self.callback(.renderTextViewWithLink(textView: textView))
                }
            }
            return
        }

        // Original logic for other action types with clickable links
        if actionLink.isEmpty {
            actionLink = contentText
            contentText = ""
        }
        if forSwiftUI {
            let combinedText = contentText + actionLink
            let swiftUIView = BreadPartnerLinkTextSwitUI(
                combinedText,
                links: [actionLink],
                onTap: {
                    Task {
                        await self.handleLinkInteraction(
                            link: (actionLink)
                        )
                    }
                }
            )

            self.callback(.renderSwiftUITextViewWithLink(textView: swiftUIView))
        } else {
            let textView = BreadPartnerLinkText()
            let combinedText = createSpannableText(
                text: contentText,
                linkText: actionLink
            )

            textView.linkTextAttributes = [
                .foregroundColor: UIColor.blue,
                .underlineStyle: NSUnderlineStyle.single.rawValue,
            ]

            textView.configure(with: combinedText) { [self] link in
                Task {
                    await handleLinkInteraction(link: link)
                }
            }
            self.callback(.renderTextViewWithLink(textView: textView))
        }
    }

    /// Handles the tap event of an action button, triggering the link interaction.
    @objc func handleButtonTap(_ sender: UIButton) {
        guard let link = sender.accessibilityIdentifier else { return }

        Task {
            await handleLinkInteraction(link: link)
        }
    }

    /// Handles the link interaction for a given link, performing the appropriate action based on the action type.
    func handleLinkInteraction(link: String) async {
        guard let placementModel = textPlacementModel,
            let responseModel = responseModel
        else {
            return
        }

        if let actionType = await HTMLContentParser().handleActionType(
            from: placementModel.actionType ?? "")
        {
            switch actionType {
            case .showOverlay:
                await handlePopupPlacement(
                    responseModel: responseModel,
                    textPlacementModel: placementModel)
            case .noAction:
                callback(.textClicked)
            default:

                return callback(
                    .sdkError(
                        error: NSError(
                            domain: "", code: 500,
                            userInfo: [
                                NSLocalizedDescriptionKey: Constants
                                    .missingTextPlacementError
                            ])))
            }
        } else {
            return callback(
                .sdkError(
                    error: NSError(
                        domain: "", code: 500,
                        userInfo: [
                            NSLocalizedDescriptionKey: Constants
                                .noTextPlacementError
                        ])))
        }
    }

}
