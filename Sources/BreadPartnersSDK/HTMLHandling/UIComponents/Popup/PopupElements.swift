//------------------------------------------------------------------------------
//  File:          PopupElements.swift
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

/// An actor responsible for managing the elements within the popup.
@available(iOS 15.0, *)
internal actor PopupElements: NSObject {

    static let shared = PopupElements()

    private override init() {
        super.init()
    }

    /// Returns a close button with a system "xmark" icon.
    @MainActor func addCloseButton(
        target: Any, color: UIColor, action: Selector
    ) -> UIButton {
        let closeButton = UIButton(type: .system)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        let closeIcon = UIImage(systemName: "xmark")
        closeButton.setImage(closeIcon, for: .normal)
        closeButton.tintColor = color
        closeButton.imageView?.contentMode = .scaleAspectFit
        closeButton.addTarget(target, action: action, for: .touchUpInside)
        return closeButton
    }

    /// Creates a simple horizontal divider view.
    @MainActor func createHorizontalDivider(color: UIColor) -> UIView {
        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = color
        return divider
    }

    /// Creates a styled container view with optional border and corner radius.
    @MainActor func createContainerView(
        backgroundColor: UIColor, borderColor: CGColor? = nil,
        borderWidth: CGFloat = 0, cornerRadius: CGFloat = 12
    ) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = backgroundColor
        containerView.layer.cornerRadius = cornerRadius
        containerView.layer.masksToBounds = true
        if let borderColor = borderColor {
            containerView.layer.borderColor = borderColor
            containerView.layer.borderWidth = borderWidth
        }

        return containerView
    }

    /// Creates a UILabel with attributed text and specified style.
    @MainActor func createLabel(
        withText text: NSAttributedString, style: PopupTextStyle,
        align: NSTextAlignment = .center
    ) -> UILabel {
        let label = UILabel()
        label.attributedText = text
        label.applyTextStyle(style: style)
        label.textAlignment = align
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }

    /// Returns a UIStackView with specified axis and spacing.
    @MainActor func createStackView(
        axis: NSLayoutConstraint.Axis, spacing: CGFloat
    ) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        return stackView
    }

    /// Creates a styled UIButton with target-action.
    @MainActor func createButton(
        target: Any,
        title: String,
        buttonStyle: PopupActionButtonStyle?,
        action: Selector
    ) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = buttonStyle?.font
        button.setTitleColor(buttonStyle?.textColor ?? .white, for: .normal)
        button.backgroundColor =
            buttonStyle?.backgroundColor ?? UIColor(hex: "d50132")
        button.layer.cornerRadius = buttonStyle?.cornerRadius ?? 8.0
        button.layer.masksToBounds = true

        var config = UIButton.Configuration.plain()
        config.titlePadding = buttonStyle?.padding?.top ?? 0

        config.baseForegroundColor = .white
        config.baseForegroundColor = .gray.withAlphaComponent(0.9)

        button.configuration = config
        button.addTarget(target, action: action, for: .touchUpInside)
        return button
    }

    @MainActor func createLabelForTag(
        tag: String, value: String, popupStyle: PopUpStyling
    ) -> UILabel? {
        switch tag.lowercased() {
        case "h3":
            return createLabel(
                withText: value.toAttributedString(),
                style: popupStyle.headingThreePopupTextStyle)
        case "p":
            return createLabel(
                withText: value.toAttributedString(),
                style: popupStyle.paragraphPopupTextStyle)
        case "connector":
            return createLabel(
                withText: value.toAttributedString(),
                style: popupStyle.connectorPopupTextStyle)
        case "footer":
            return createLabel(withText: value.toAttributedString(),style: popupStyle.paragraphPopupTextStyle)
        default:
            return nil
        }
    }
}
