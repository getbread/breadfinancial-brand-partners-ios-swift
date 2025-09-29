// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BreadPartnersSDKSwift",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "BreadPartnersSDKSwift",
            targets: ["BreadPartnersSDKSwift"])
    ],
    dependencies: [
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.7.5"),
    ],
    targets: [
        .target(
            name: "BreadPartnersSDKSwift",
            dependencies: [
                "SwiftSoup",
            ]
        )
    ]
)
