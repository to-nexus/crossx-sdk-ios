# Changelog

## [1.2.4] - 2026-03-27

Android SDK API 통일을 위한 리네이밍 및 신규 API 추가.

### Added
- `signInWithCreate(provider:)` — 로그인 + 지갑 생성 원스텝 API
- `refreshToken()` — Access Token 수동 갱신 API
- `walletRpc(request:chainId:)` — 범용 JSON-RPC 호출 API
- `waitForTxAndGetReceipt(txHash:chainId:timeoutMs:pollIntervalMs:)` — Android 호환 Receipt 폴링
- `sendTransactionWithWaitForReceipt(...)` — Android 호환 전송 + Receipt 폴링
- `createWallet(migrateAutomatically:)` — 자동 마이그레이션 제어 파라미터 추가
- `SDKUserInfo.loginType` — 로그인 타입 필드
- `SDKUserInfo.addresses` — 지갑 주소 목록 필드
- `SDKUserInfo` 편의 접근자: `id`, `email`, `provider`, `accessToken`, `idToken`, `sub`
- `canUseBiometric()` — 기기 생체 인증 가용 여부 확인
- `isBiometricEnabled()` — 생체 인증 활성화 여부 확인
- `setBiometricEnabled(_:)` — 생체 인증 활성화/비활성화

### Changed
- `LoginProvider` → `SDKSignInProvider` 리네이밍
- `CROSSxTheme` → `SDKThemeMode` 리네이밍
- `CROSSxThemeConfig` → `SDKThemeTokens` 리네이밍
- `CROSSxThemeTokens` → `SDKColorOverrides` 리네이밍
- `PasswordStorePort`에 `isBiometricAvailable()`, `isBiometricEnabled()` 프로토콜 메서드 추가 (기본 구현 제공)

## [1.2.3] - 2026-03-26

- fix: track Derived/ files for CI build

## [1.2.2] - 2026-03-25

- fix: auto-generate TuistBundle+CROSSxCoreSDK.swift in CI

## [1.2.1] - 2026-03-24

- feat: add sessionExpired error for token/refresh expiry
