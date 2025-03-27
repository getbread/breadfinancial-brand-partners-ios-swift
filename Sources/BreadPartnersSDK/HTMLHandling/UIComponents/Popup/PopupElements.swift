import UIKit

@available(iOS 15.0, *)
internal actor PopupElements: NSObject {

    static let shared = PopupElements()

    private override init() {
        super.init()
    }

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

    @MainActor func createHorizontalDivider(color: UIColor) -> UIView {
        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = color
        return divider
    }

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
