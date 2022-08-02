// swift-tools-version:5.6
import PackageDescription

let package = Package(
  name: "xcframework-maker",
  platforms: [
    .macOS(.v11),
  ],
  products: [
    .library(
      name: "XCFrameworkMaker",
      targets: [
        "XCFrameworkMaker",
      ]
    ),
    .executable(
      name: "make-xcframework",
      targets: [
        "make-xcframework",
      ]
    ),
  ],
  dependencies: [
    .package(
      url: "https://github.com/apple/swift-argument-parser.git",
      .upToNextMajor(from: "0.4.3")
    ),
    .package(
      url: "https://github.com/JohnSundell/ShellOut.git",
      .upToNextMajor(from: "2.3.0")
    ),
    .package(
      url: "https://github.com/d-date/arm64-to-sim.git",
      branch: "ignore-header"
    ),
  ],
  targets: [
    .target(
      name: "XCFrameworkMaker",
      dependencies: [
        .product(
          name: "ShellOut",
          package: "ShellOut"
        ),
        .product(
          name: "Arm64ToSim",
          package: "arm64-to-sim"
        ),
      ]
    ),
    .testTarget(
      name: "XCFrameworkMakerTests",
      dependencies: [
        .target(name: "XCFrameworkMaker"),
      ]
    ),
    .executableTarget(
      name: "make-xcframework",
      dependencies: [
        .target(name: "XCFrameworkMaker"),
        .product(
          name: "ArgumentParser",
          package: "swift-argument-parser"
        ),
      ]
    ),
  ]
)
