// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "ReaderSDK",
  platforms: [.iOS(.v12)],
  products: [
    .library(name: "ReaderSDK", targets: ["ReaderSDKWrapper"]),
  ],
  dependencies: [
    .package(url: "https://github.com/realm/realm-swift", exact: "10.28.0"),
    .package(url: "https://github.com/SnapKit/SnapKit", exact: "5.6.0"),
    .package(url: "https://github.com/marmelroy/Zip", exact: "2.1.2"),
    .package(url: "https://github.com/ReactiveX/RxSwift", .upToNextMinor(from: "6.5.0")),
    .package(url: "https://github.com/kishikawakatsumi/KeychainAccess", .upToNextMinor(from: "4.2.2")),
    .package(url: "https://github.com/onevcat/Kingfisher", .upToNextMinor(from: "5.14.0"))
  ],
  targets: [
    .target(
      name: "ReaderSDKWrapper",
      dependencies: [
        .target(name: "ReaderSDK"),
        .product(name: "RealmSwift", package: "realm-swift"),
        "SnapKit",
        "Zip",
        .product(name: "RxRelay", package: "RxSwift"),
        "KeychainAccess",
        "Kingfisher"
      ],
      path: "Sources/ReaderSDKWrapper",
      publicHeadersPath: ""
    ),
    .binaryTarget(
      name: "ReaderSDK",
      url: "https://github.com/rserentill/ios-reader-sdk/raw/main/ReaderSDK-2.42.1.xcframework.zip",
      checksum: "a4722b976753c45950ae49d96c4291d66c51f959ffc7811f6e26ef2939e70e12"
    )
  ]
)
