# Changelog

All notable changes to CROSSx iOS SDK will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added (v1.0.0 - 다중 체인 기반)
- 🌐 **다중 체인 지원 아키텍처** 추가
  - `ChainType` enum - 체인 식별자 (ethereum, solana, bitcoin, cosmos)
  - `ChainPort` protocol - 체인 추상화 인터페이스
  - `ChainTransaction` union type - 체인별 트랜잭션 타입
  - `AddressInfo` - 체인별 주소 정보 (derivation path 포함)
- `AuthResult.walletAddresses` - 다중 주소 지원
- `EVMTransaction` - Ethereum 전용 트랜잭션 타입
- `SolanaTransaction`, `BitcoinTransaction`, `CosmosTransaction` 타입 정의 (향후 구현)
- **`EVMNetworkConfig`** - EVM 네트워크 설정
  - Cross Mainnet (eip155:612055) 기본 지원
  - Cross Testnet (eip155:612044) 기본 지원
  - Ethereum, Polygon, BSC 등 주요 EVM 체인 지원
- BIP-44 Derivation Path 지원
  - Ethereum: m/44'/60'/0'/0/0
  - Solana: m/44'/501'/0'/0'
  - Bitcoin: m/44'/0'/0'/0/0
  - Cosmos: m/44'/118'/0'/0/0

### Changed
- ✅ **하위 호환성 유지** - 기존 코드 수정 없이 동작
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
