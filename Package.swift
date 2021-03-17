// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LocalStoreRealm",
    platforms: [
        .macOS(.v10_10),
        .iOS(.v11),
        .tvOS(.v9),
        .watchOS(.v2)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "LocalStoreRealm",
            targets: ["LocalStoreRealm"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/dsay/SwiftRepository.git", from: "1.0.0"),
        .package(name: "Realm", url: "https://github.com/realm/realm-cocoa", .exact("5.3.3")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "LocalStoreRealm",
            dependencies: ["SwiftRepository", .product(name: "RealmSwift", package: "Realm")]),
        .testTarget(
            name: "LocalStoreRealmTests",
            dependencies: ["LocalStoreRealm"]),
    ]
)
