# Changelog

All notable changes to CROSSx iOS SDK will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- 🌍 **다국어(i18n) 지원 인프라** 도입
  - `L10n` 헬퍼 타입 — `Bundle.module` + `NSLocalizedString` 기반 타입-세이프 문자열 접근
  - `en.lproj/Localizable.strings` — 영어 기본 번역 (82개 키)
  - `ko.lproj/Localizable.strings` — 한국어 번역 (82개 키)
  - `Package.swift`에 `defaultLocalization: "en"` 설정 추가
  - 새 언어 추가 시 `.lproj` 폴더만 추가하면 코드 변경 없이 지원 가능

### Changed
- **UI 문자열 다국어 전환** — 6개 SwiftUI 뷰의 하드코딩 문자열을 `L10n` 호출로 전환
  - `WalletSelectorView`, `TransactionConfirmView`, `LoginSelectionSheetView`
  - `MigrationFoundView`, `MigrationPinInputView`, `MigrationPresenter`
- **에러 메시지 다국어 전환** — `CROSSxError`, `OAuthError`, `TokenStoreError`의 `errorDescription`을 `L10n` 호출로 전환
- **내부 로그 및 메시지 영문화** — `Log.d` 디버그 메시지 및 내부 문자열을 한국어에서 영어로 전환 (개발자용 로그는 다국어 대상 아님)

### Added (v1.0.0 - 다중 체인 기반)
- 🌐 **다중 체인 지원 아키텍처** 추가
  - `ChainType` enum - 체인 식별자 (ethereum, solana, bitcoin, cosmos)
  - `ChainPort` protocol - 체인 추상화 인터페이스
  - `ChainTransaction` union type - 체인별 트랜잭션 타입
  - `AddressInfo` - 체인별 주소 정보 (derivation path 포함)
- `AuthResult.walletAddresses` - 다중 주소 지원
- `EVMTransaction` - Ethereum 전용 트랜잭션 타입
- `SolanaTransaction`, `BitcoinTransaction`, `CosmosTransaction` 타입 정의 (향후 구현)
- **🔌 `NetworkConfig` Protocol** - 네트워크 설정 인터페이스
  - 모든 블록체인 네트워크가 준수해야 하는 공통 프로토콜
  - EVM, Solana, Bitcoin 등 다양한 체인 통합 관리
  - `NetworkType` enum - 네트워크 타입 식별 (evm, solana, bitcoin, cosmos)
  - 타입 체크 헬퍼: `isEVM`, `isSolana`, `isBitcoin`, `isCosmos`
  - Explorer URL 생성 기본 구현 제공
- **`EVMNetworkConfig`** - EVM 네트워크 설정 (`NetworkConfig` 준수)
  - Cross Mainnet (eip155:612055) 기본 지원
  - Cross Testnet (eip155:612044) 기본 지원
  - Ethereum, Polygon, BSC 등 주요 EVM 체인 지원
  - EVM 전용 속성: `chainId` (EIP-155)
- **🔗 체인 관리 API (Chain Management)**
  - `ChainInfo` - 체인 정보 및 활성 상태 (제네릭 NetworkConfig 지원)
  - `getChains()` - 설정된 모든 체인 리스트 조회
  - `getActiveChain()` - 현재 활성 체인 조회
  - `setActiveChain(_ caip2: String)` - CAIP-2로 활성 체인 변경
  - `setActiveChain(chainId: Int)` - Chain ID로 활성 체인 변경
  - Thread-safe 체인 상태 관리 (NSLock 사용)
  - 네트워크 타입 체크: `isEVM`, `isSolana` 등
- BIP-44 Derivation Path 지원
  - Ethereum: m/44'/60'/0'/0/0
  - Solana: m/44'/501'/0'/0'
  - Bitcoin: m/44'/0'/0'/0/0
  - Cosmos: m/44'/118'/0'/0/0

### Changed
- ✅ **하위 호환성 유지** - 기존 코드 수정 없이 동작
- **OAuth 세션 쿠키 유지** - `prefersEphemeralSession` 기본값 `false`로 변경
  - Google 로그인 히스토리가 Safari와 공유됨
  - 이전 로그인 정보 유지로 재로그인 간소화
- `AuthResult.walletAddress` deprecated (여전히 사용 가능)
- JavaScript SDK와 아키텍처 동기화

### Added (v0.1.0)
- Clean Architecture + Hexagonal Architecture 구조 적용
- Core Layer 완전 구현
  - 5개 Ports (CryptoPort, StoragePort, NetworkPort, OAuthPort, WalletProviderPort)
  - 7개 Core Types (SDKConfig, AuthResult, JWTPayload, SignatureResult, TransactionParams, Errors, JWTVerifyResult)
  - 5개 UseCases (SignInUseCase, SignOutUseCase, SignMessageUseCase, SendTransactionUseCase, WithdrawUseCase)
- SDK Public API 구현
  - `initialize()` - 세션 복원
  - `signIn()` - OAuth 로그인
  - `signOut()` - 로그아웃
  - `signMessage()` - 메시지 서명
  - `sendTransaction()` - 트랜잭션 전송
  - `withdraw()` - 탈퇴
- Tuist 기반 샘플 앱 (CROSSxSample)
- Mock Adapters (임시 구현)
- 플랫폼별 OAuth 처리 방식 문서
- Unity용 Native OAuth Package 설계 문서

### Changed
- **iOS 최소 버전 13.0 → 15.0으로 상향**
- macOS 최소 버전 10.15 → 12.0으로 상향
- **외부 의존성 제거**: JWTDecode → 순수 Swift/Foundation 구현
  - JWT 파싱을 base64url 디코딩으로 직접 구현
  - 백엔드에서 서명 검증하므로 클라이언트는 단순 파싱만 수행

### Technical Details
- Swift 5.9+
- iOS 15.0+
- ✅ 외부 의존성 없음 (100% 순수 Swift)
- Sendable 프로토콜 적용 (Swift Concurrency 안전성)

---

## [0.1.0] - 2026-02-06

### Added
- 초기 프로젝트 구조 생성
- Swift Package Manager 설정
- 문서 작성 (10개)
  - requirements.md
  - architecture.md
  - oauth-integration.md
  - jwt-validation.md
  - oauth-endpoints.md
  - api-endpoints.md
  - platform-differences.md
  - native-oauth-package.md
  - README.md
  - DOCUMENT_INDEX.md
- Cursor AI 규칙
  - SDK_ARCHITECTURE.mdc
  - PORTS_CONVENTION.mdc

---

**버전 관리 시작일**: 2026-02-06
