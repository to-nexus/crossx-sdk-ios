# CROSSx iOS SDK

[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS%2015.0+-lightgrey.svg)](https://developer.apple.com/ios/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

CROSSx iOS SDK provides OAuth-based authentication and Embedded Wallet functionality for iOS applications.

## Features

- **OAuth Authentication** — Social login (Google, Apple, etc.)
- **Embedded Wallet** — Users never handle private keys directly
- **EVM Compatible** — CAIP-2 based chain identification (e.g. `eip155:612055`)
- **Transaction Confirmation Dialog** — Mandatory user approval before signing/sending (non-bypassable)
- **Secure Storage** — iOS Keychain-backed data storage
- **Native OAuth** — Uses `ASWebAuthenticationSession`
- **Session Restore** — Automatic sign-in on app relaunch
- **Swift Concurrency** — Full async/await support
- **Zero Dependencies** — Pure Swift/Foundation implementation

## Requirements

- iOS 15.0+
- Xcode 15.0+
- Swift 5.9+

## Supported Networks

### Cross Network
- **Cross Mainnet** (eip155:612055) — Production
- **Cross Testnet** (eip155:612044) — Development (default)

### Other EVM Chains
- Ethereum Mainnet, Sepolia
- Polygon Mainnet, Amoy
- BNB Smart Chain Mainnet, Testnet

## Installation

### Swift Package Manager

#### Via Xcode

1. Open your project in Xcode
2. Go to **File → Add Packages…**
3. Enter the repository URL:
   ```
   https://github.com/to-nexus/crossx-sdk-ios
   ```
4. Select a version rule and add the package

#### Via Package.swift

```swift
dependencies: [
    .package(url: "https://github.com/to-nexus/crossx-sdk-ios", from: "1.0.0")
]
```

Then add the dependency to your target:

```swift
.target(
    name: "YourApp",
    dependencies: [
        .product(name: "CROSSxSDK", package: "crossx-sdk-ios")
    ]
)
```

### CocoaPods

Add the following to your `Podfile`:

```ruby
platform :ios, '15.0'

target 'YourApp' do
  use_frameworks!
  pod 'CROSSxSDK'
end
```

Then run:

```bash
pod install
```

> **Note**: After installation, always open the `.xcworkspace` file instead of `.xcodeproj`.

## Quick Start

### 1. Initialize the SDK

#### Simple Initialization (Recommended)

```swift
import CROSSxCoreSDK

let sdk = try CROSSxSDK(config: SDKConfig(
    projectId: "your-project-id"
))

// Restore session (auto sign-in if a saved token exists)
try await sdk.initialize()
```

#### Info.plist / xcconfig-Based Initialization

```swift
let sdk = try CROSSxSDK(config: SDKConfig.fromInfoPlist(projectId: "your-project-id"))
```

### 2. Register a Custom URL Scheme

The SDK automatically generates a URL scheme from the `projectId`: `crossx-{projectId}`

Register it in your `Info.plist`:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>crossx-your-project-id</string>
        </array>
    </dict>
</array>
```

Handle the callback URL in your `AppDelegate`:

```swift
func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
    if sdk.handleURL(url) {
        return true
    }
    return false
}
```

### 3. Sign In

```swift
let result = try await sdk.signIn()
if result.success {
    print("Signed in!")
    print("Wallet address: \(result.walletAddress ?? "")")
}
```

### 4. CAIP-2 Chain Identification

The SDK does not manage chains internally. Pass the CAIP-2 chain ID when calling sign/send methods.

```swift
let chainId = ChainId.crossMainnet   // "eip155:612055"
let chainId = ChainId.ethereumMainnet // "eip155:1"
```

### 5. Transaction Confirmation Dialog

When calling `signTransaction()`, `sendTransaction()`, or `sendTransactionAndWait()`, the SDK automatically displays a user approval dialog. There is no public API to bypass this.

```swift
import CROSSxCoreSDK

do {
    let result = try await sdk.sendTransactionAndWait(tx, chainId: ChainId.crossTestnet)
    print("txHash: \(result.txHash)")
} catch let error as CROSSxError {
    if case .userRejected = error {
        print("User cancelled the transaction")
    }
}
```

> See [Transaction Confirmation Dialog Guide](doc/transaction-confirmation.md) for details.

### 6. Sign Out

```swift
try await sdk.signOut()
```

## Example App

```bash
cd Examples/CROSSxSampleCocoapods
ruby setup.rb
pod install
open CROSSxSampleCocoapods.xcworkspace
```

See [Examples/CROSSxSampleCocoapods/README.md](Examples/CROSSxSampleCocoapods/README.md) for details.

## License

MIT License. See [LICENSE](LICENSE) for details.
