import UIKit

@available(iOS 15, *)
extension HTMLContentRenderer {

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

    func renderTextViewWithLink() {

        var contentText = textPlacementModel?.contentText ?? ""
        var actionLink = textPlacementModel?.actionLink ?? ""
        let actionType = textPlacementModel?.actionType

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

    @objc func handleButtonTap(_ sender: UIButton) {
        guard let link = sender.accessibilityIdentifier else { return }

        Task {
            await handleLinkInteraction(link: link)
        }
    }

    func handleLinkInteraction(link: String) async {
        guard let placementModel = textPlacementModel,
            let responseModel = responseModel
        else {
            return
        }

        if let actionType = await htmlContentParser.handleActionType(
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
                return await  alertHandler.showAlert(
                    title: Constants.nativeSDKAlertTitle(),
                    message: Constants.missingTextPlacementError,
                    showOkButton: true)
            }
        } else {
            return await alertHandler.showAlert(
                title: Constants.nativeSDKAlertTitle(),
                message: Constants.noTextPlacementError, showOkButton: true)
        }
    }

}
