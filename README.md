# CROSSx iOS SDK

[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS%2015.0+-lightgrey.svg)](https://developer.apple.com/ios/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

> 한국어 문서: [README.ko.md](README.ko.md)

CROSSx iOS SDK provides OAuth-based authentication and Embedded Wallet functionality for iOS applications.

## Features

- **OAuth Authentication** — Social login (Google, Apple, etc.)
- **Embedded Wallet** — Users never handle private keys directly
- **EVM Compatible** — CAIP-2 based chain identification (e.g. `eip155:612055`)
- **Transaction Confirmation Dialog** — Mandatory user approval before signing/sending (non-bypassable)
- **Secure Storage** — iOS Keychain-backed data storage
- **Native OAuth** — Uses `ASWebAuthenticationSession`
- **Session Restore** — Automatic sign-in on app relaunch
- **Biometric Authentication** — Face ID / Touch ID support for wallet unlock
- **Theme Customization** — Light/Dark mode with custom color token overrides
- **Localization (i18n)** — English (default) and Korean; extend with any `.lproj`
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
    .package(url: "https://github.com/to-nexus/crossx-sdk-ios", from: "2.0.0")
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

```swift
import CROSSxCoreSDK

let sdk = try CROSSxSDK(config: SDKConfig(
    projectId: "your-project-id",
    appName: "Your App Name"
))

// Restore session (auto sign-in if a saved token exists)
try await sdk.initialize()
```

#### Info.plist / xcconfig-Based Initialization

```swift
let sdk = try CROSSxSDK(config: try SDKConfig.fromInfoPlist(
    projectId: "your-project-id",
    appName: "Your App Name"
))
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

Handle the callback URL in your `AppDelegate` or `SceneDelegate`:

```swift
func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
    return sdk.handleURL(url)
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

To sign in and create a wallet in one step:

```swift
let result = try await sdk.signInWithCreate()
```

### 4. Create and Check Wallet

```swift
// Check wallet status before creating
let status = try await sdk.checkWallet()

// Create wallet (automatically migrates existing backup if found)
let wallet = try await sdk.createWallet()
print("Address: \(wallet.address)")
```

### 5. Get User Info

```swift
let userInfo = try await sdk.getUserInfo()
print("Email: \(userInfo.email ?? "")")
print("Addresses: \(userInfo.addresses)")
```

### 6. CAIP-2 Chain Identification

The SDK does not manage chains internally. Pass the CAIP-2 chain ID when calling sign/send methods.

```swift
let chainId = ChainId.crossMainnet    // "eip155:612055"
let chainId = ChainId.crossTestnet    // "eip155:612044"
let chainId = ChainId.ethereumMainnet // "eip155:1"
```

### 7. Transaction Confirmation Dialog

When calling `signTransaction()`, `sendTransaction()`, or `sendTransactionAndWait()`, the SDK automatically displays a user approval dialog. There is no public API to bypass this.

```swift
do {
    let result = try await sdk.sendTransactionAndWait(tx, chainId: ChainId.crossTestnet)
    print("txHash: \(result.txHash)")
} catch let error as CROSSxError {
    if case .userRejected = error {
        print("User cancelled the transaction")
    }
}
```

### 8. Sign Out

```swift
try await sdk.signOut()
```

## Biometric Authentication

```swift
let available = sdk.canUseBiometric()
let enabled = sdk.isBiometricEnabled()
try await sdk.setBiometricEnabled(true)
```

## Theme Customization

```swift
let sdk = try CROSSxSDK(config: SDKConfig(
    projectId: "your-project-id",
    appName: "Your App Name",
    theme: .system,
    themeTokens: SDKThemeTokens(
        light: SDKColorOverrides(primary: "#FF6B35", bg: "#F5F0EB"),
        dark:  SDKColorOverrides(primary: "#FF6B35", bg: "#1A0A00")
    )
))

// Change theme at runtime (takes effect on the next modal)
sdk.applyTheme(.dark)
```

## Localization (i18n)

The SDK uses Apple-standard `.strings` resources via `Bundle.module`.

| Language | Code | Status  |
|----------|------|---------|
| English  | `en` | Default |
| Korean   | `ko` | Supported |

To add a new language, place a `.lproj` folder in the SDK's `Resources/` directory — no code changes required.

## Token Refresh

```swift
let newAccessToken = try await sdk.refreshToken()
```

## Example Apps

**Swift Package Manager / Tuist:**
```bash
cd Examples/CROSSxSample
tuist install
tuist generate
open CROSSxSample.xcworkspace
```

**CocoaPods:**
```bash
cd Examples/CROSSxSampleCocoapods
ruby setup.rb
pod install
open CROSSxSampleCocoapods.xcworkspace
```

## License

MIT License. See [LICENSE](LICENSE) for details.
