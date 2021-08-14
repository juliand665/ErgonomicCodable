// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "ErgonomicCodable",
    products: [
        .library(
            name: "ErgonomicCodable",
            targets: ["ErgonomicCodable"]
		),
    ],
    dependencies: [
		.package(url: "https://github.com/juliand665/HandyOperators", from: "2.0.0"),
	],
    targets: [
        .target(
            name: "ErgonomicCodable",
            dependencies: ["HandyOperators"]
		),
        .testTarget(
            name: "ErgonomicCodableTests",
            dependencies: ["ErgonomicCodable"]
		),
    ]
)
