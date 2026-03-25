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
            
            if forSwiftUI {
                // For SwiftUI, convert HTML to attributed string and render as tappable text
                if let attributedString = htmlString.htmlToAttributedString() {
                    // Use the plain text without HTML tags, no links array (empty)
                    let swiftUIView = BreadPartnerLinkTextSwitUI(
                        attributedString.string,
                        links: [], // No links to underline
                        onTap: {
                            Task {
                                await self.handleLinkInteraction(link: "")
                            }
                        }
                    )
                    self.callback(.renderSwiftUITextViewWithLink(textView: swiftUIView))
                } else {
                    // Fallback to plain text if HTML conversion fails
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
                }
            } else {
                // For UIKit, use BreadPartnerLinkText with HTML attributed string
                let textView = BreadPartnerLinkText()
                
                if let attributedString = htmlString.htmlToAttributedString() {
                    // Create a mutable copy to remove any link attributes and underlines
                    let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
                    let range = NSRange(location: 0, length: mutableAttributedString.length)
                    mutableAttributedString.removeAttribute(.link, range: range)
                    mutableAttributedString.removeAttribute(.underlineStyle, range: range)
                    
                    textView.configure(with: mutableAttributedString) { [self] _ in
                        Task {
                            await handleLinkInteraction(link: "")
                        }
                    }
                } else {
                    // Fallback to plain text if HTML conversion fails
                    let plainAttributedString = NSAttributedString(string: contentText)
                    textView.configure(with: plainAttributedString) { [self] _ in
                        Task {
                            await handleLinkInteraction(link: "")
                        }
                    }
                }
                
                self.callback(.renderTextViewWithLink(textView: textView))
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
