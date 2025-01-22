// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MVVMC",
    platforms: [.iOS("13.0")],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MVVMC",
            targets: ["MVVMC"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "MVVMC"),
        .testTarget(
            name: "MVVMCTests",
            dependencies: ["MVVMC"]
        ),
    ]
)
