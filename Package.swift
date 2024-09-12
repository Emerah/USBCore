// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "USBCore",
    platforms: [.macOS(.v14)],
    products: [.library(name: "USBCore", targets: ["USBCore"])],
    targets: [
        .systemLibrary(name: "Clibusb", path: "Sources/Clibusb", pkgConfig: "libusb-1.0", providers: [.brew(["libusb"])]),
        .target(name: "USBCore", dependencies: [.target(name: "Clibusb")])
    ]
)
