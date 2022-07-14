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
    .package(url: "https://github.com/onevcat/Kingfisher", .upToNextMinor(from: "5.14.0")),
    .package(url: "https://github.com/suzuki-0000/SKPhotoBrowser", revision: "06ec43d4768cd04e488cd022b57bac1ffecb282f"),
  ],
  targets: [
    .target(
      name: "ReaderSDKWrapper",
      dependencies: [
        .product(name: "RealmSwift", package: "realm-swift"),
        .product(name: "Realm", package: "realm-swift"),
        "SnapKit",
        "Zip",
        .product(name: "RxRelay", package: "RxSwift"),
        "KeychainAccess",
        "Kingfisher",
        "SKPhotoBrowser",
        .target(name: "ReaderSDK")
      ],
      path: "Sources/ReaderSDKWrapper",
      publicHeadersPath: ""
    ),
    .binaryTarget(
      name: "ReaderSDK",
      url: "https://bitbucket.org/ziniollc/ios-reader-demo/src/develop/ReaderSDK-2.42.0.xcframework.zip",
      checksum: "464297fab03c5e86e69e3ee99e59e93286e7261e0e0d2f38541c1067db772c74"
    )
  ]
)
