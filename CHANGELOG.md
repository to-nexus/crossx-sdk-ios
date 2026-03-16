# Changelog

All notable changes to CROSSx iOS SDK will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.1] - 2026-03-16

### Added
- 🌐 **Multi-chain support architecture**
  - `ChainType` enum — Chain identifier (ethereum, solana, bitcoin, cosmos)
  - `ChainPort` protocol — Chain abstraction interface
  - `ChainTransaction` union type — Per-chain transaction types
  - `AddressInfo` — Per-chain address information (including derivation path)
- `AuthResult.walletAddresses` — Multi-address support
- `EVMTransaction` — Ethereum-specific transaction type
- `SolanaTransaction`, `BitcoinTransaction`, `CosmosTransaction` type definitions (future implementation)
- **`NetworkConfig` Protocol** — Network configuration interface
  - Common protocol that all blockchain networks must conform to
  - Unified management for EVM, Solana, Bitcoin, and other chains
  - `NetworkType` enum — Network type identifier (evm, solana, bitcoin, cosmos)
  - Type-check helpers: `isEVM`, `isSolana`, `isBitcoin`, `isCosmos`
  - Default explorer URL generation
- **`EVMNetworkConfig`** — EVM network configuration (conforms to `NetworkConfig`)
  - Cross Mainnet (eip155:612055) supported by default
  - Cross Testnet (eip155:612044) supported by default
  - Major EVM chains supported: Ethereum, Polygon, BSC, etc.
  - EVM-specific property: `chainId` (EIP-155)
- **Chain Management API**
  - `ChainInfo` — Chain information and active state (generic NetworkConfig support)
  - `getChains()` — Retrieve all configured chains
  - `getActiveChain()` — Retrieve the currently active chain
  - `setActiveChain(_ caip2: String)` — Change active chain by CAIP-2 identifier
  - `setActiveChain(chainId: Int)` — Change active chain by Chain ID
  - Thread-safe chain state management (using NSLock)
- BIP-44 Derivation Path support
  - Ethereum: m/44'/60'/0'/0/0
  - Solana: m/44'/501'/0'/0'
  - Bitcoin: m/44'/0'/0'/0/0
  - Cosmos: m/44'/118'/0'/0/0

### Changed
- **OAuth session cookie persistence** — `prefersEphemeralSession` default changed to `false`
  - Google sign-in history is shared with Safari
  - Simplified re-authentication by retaining previous login information
- `AuthResult.walletAddress` deprecated (still usable)
- Architecture synchronized with the JavaScript SDK

---

## [1.0.0] - 2026-02-06

### Added
- Clean Architecture + Hexagonal Architecture
  - 5 Ports (CryptoPort, StoragePort, NetworkPort, OAuthPort, WalletProviderPort)
  - 7 Core Types (SDKConfig, AuthResult, JWTPayload, SignatureResult, TransactionParams, Errors, JWTVerifyResult)
  - 5 UseCases (SignInUseCase, SignOutUseCase, SignMessageUseCase, SendTransactionUseCase, WithdrawUseCase)
- SDK Public API
  - `initialize()` — Session restore
  - `signIn()` — OAuth sign-in
  - `signOut()` — Sign out
  - `signMessage()` — Message signing
  - `sendTransaction()` — Send transaction
  - `withdraw()` — Account deletion
- Swift Package Manager & CocoaPods support
- Tuist-based sample app (CROSSxSample)
- CocoaPods sample app (CROSSxSampleCocoapods)
- Transaction confirmation dialog (non-bypassable user approval)
- iOS Keychain-backed secure storage
- Native OAuth via `ASWebAuthenticationSession`
- Automatic session restore on app relaunch
- Full async/await support (Swift Concurrency)
- Zero external dependencies (100% pure Swift)
- Sendable protocol applied (Swift Concurrency safety)

### Technical Details
- Swift 5.9+
- iOS 15.0+
- Xcode 15.0+
