// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BreadPartnersSDKSwift",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "BreadPartnersSDKSwift",
            targets: ["BreadPartnersSDKSwift"])
    ],
    dependencies: [
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.7.5"),
        .package(
            url:
                "https://github.com/GoogleCloudPlatform/recaptcha-enterprise-mobile-sdk.git",
            from: "18.8.1"),
    ],
    targets: [
        .target(
            name: "BreadPartnersSDKSwift",
            dependencies: [
                "SwiftSoup",
                .product(
                    name: "RecaptchaEnterprise",
                    package: "recaptcha-enterprise-mobile-sdk"),
            ]
        )
    ]
)
