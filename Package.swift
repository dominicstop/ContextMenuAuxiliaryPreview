// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "ContextMenuAuxiliaryPreview",
  platforms: [
    .iOS(.v13),
  ],
  products: [
    .library(
      name: "ContextMenuAuxiliaryPreview",
      targets: ["ContextMenuAuxiliaryPreview"]
    ),
  ],
  targets: [
    .target(
      name: "ContextMenuAuxiliaryPreview",
      dependencies: [],
      path: "Sources",
      linkerSettings: [
				.linkedFramework("UIKit"),
			]
    ),
  ],
  swiftLanguageVersions: [
    .v5,
  ]
);
