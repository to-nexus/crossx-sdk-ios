# CROSSx iOS SDK

[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS%2015.0+-lightgrey.svg)](https://developer.apple.com/ios/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

CROSSx iOS SDK는 OAuth 기반 인증과 Embedded Wallet 기능을 제공하는 Swift SDK입니다.

## 특징

- **OAuth 기반 인증**: 간편한 소셜 로그인 (Google, Apple 등)
- **Embedded Wallet**: 사용자가 Private Key를 직접 관리하지 않는 지갑
- **EVM 호환**: CAIP-2 기반 체인 식별 (예: `eip155:612055`)
- **Cloud Backup 마이그레이션**: 이전 네이티브 앱 백업 데이터 확인
- **트랜잭션 컨펌 다이얼로그**: 서명/전송 전 사용자 승인 필수 (우회 불가)
- **안전한 저장소**: iOS Keychain을 사용한 안전한 데이터 저장
- **iOS 최적화**: ASWebAuthenticationSession을 사용한 네이티브 OAuth
- **Clean Architecture**: 테스트 가능하고 유지보수하기 쉬운 구조
- **세션 복원**: 앱 재시작 시 자동 로그인
- **Swift Concurrency**: async/await 지원
- **외부 의존성 없음**: 순수 Swift/Foundation 구현
- **다국어(i18n) 지원**: 영어(기본), 한국어 지원 — `.lproj` 추가만으로 새 언어 확장 가능

## 요구사항

- iOS 15.0+
- Xcode 15.0+
- Swift 5.9+

## 지원 네트워크

### Cross 네트워크
- **Cross Mainnet** (eip155:612055) - 프로덕션 환경
- **Cross Testnet** (eip155:612044) - 개발/테스트 환경 (기본값)

### 기타 EVM 체인
- Ethereum Mainnet, Sepolia
- Polygon Mainnet, Amoy
- BNB Smart Chain Mainnet, Testnet

## 설치

### Swift Package Manager

#### Xcode에서 설치

1. Xcode에서 프로젝트 열기
2. File > Add Packages...
3. 다음 URL 입력:
   ```
   https://github.com/crosstoken/crossy-sdk-ios
   ```
4. 버전 선택 및 설치

#### Package.swift에 추가

```swift
dependencies: [
    .package(url: "https://github.com/crosstoken/crossy-sdk-ios", from: "1.0.0")
]
```

## 빠른 시작

### 1. SDK 초기화

#### 간편 초기화 (권장)

```swift
import CROSSxSDK

// 가장 간단한 초기화
let sdk = try CROSSx(config: SDKConfig(
    projectId: "your-project-id"
))

// 세션 복원 (저장된 토큰이 있으면 자동 로그인)
try await sdk.initialize()
```

#### Info.plist / xcconfig 기반 초기화

```swift
// Info.plist에서 엔드포인트를 읽고, projectId는 직접 전달
let sdk = try CROSSx(config: SDKConfig.fromInfoPlist(projectId: "your-project-id"))
```

### 2. Custom URL Scheme 설정

SDK는 `projectId` 기반으로 URL Scheme을 자동 생성합니다: `crossx-{projectId}`

`Info.plist`에 해당 scheme을 등록하세요:

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

### 3. 로그인

```swift
let result = try await sdk.signIn()
if result.success {
    print("로그인 성공!")
    print("지갑 주소: \(result.address ?? "")")
}
```

### 4. CAIP-2 체인 식별

SDK는 체인을 내부적으로 관리하지 않습니다.
서명/전송 호출 시 CAIP-2 문자열을 직접 사용하세요.

```swift
// ChainId 상수 사용
let chainId = ChainId.crossMainnet   // "eip155:612055"
let chainId = ChainId.ethereumMainnet // "eip155:1"
```

### 5. 트랜잭션 컨펌 다이얼로그

`signTransaction()` / `sendTransaction()` / `sendTransactionAndWait()` 호출 시 SDK가 자동으로 사용자 승인 다이얼로그를 표시합니다. DApp 개발자가 우회할 수 있는 공개 API는 없습니다.

```swift
import CROSSxSDK

do {
    let result = try await sdk.sendTransactionAndWait(
        chainId: ChainId.crossTestnet,
        transaction: tx
    )
    print("txHash: \(result.txHash)")
} catch let error as CROSSxError {
    if case .userRejected = error {
        print("사용자가 취소했습니다")
    }
}
```

> 자세한 내용 → [트랜잭션 컨펌 다이얼로그 가이드](doc/transaction-confirmation.md)

### 6. 로그아웃

```swift
try await sdk.signOut()
```

## OAuth 플로우

SDK는 다음과 같은 OAuth 플로우를 사용합니다:

```
iOS SDK → ASWebAuthenticationSession 열기
  URL: {oauthServiceUrl}/google?redirectScheme={callbackScheme}

OAuth 서버 → Deep Link로 콜백
  {callbackScheme}://{oauthHost}/?status=success&data={base64}

SDK → base64 디코딩 → 토큰 추출 → JWT 검증 → 완료
```

> Web에서는 `window.open()` + `postMessage` 방식을 사용합니다.

## 예제 앱

```bash
cd Examples/CROSSxSample
tuist install
tuist generate
open CROSSxSample.xcworkspace
```

자세한 내용은 [Examples/CROSSxSample/README.md](Examples/CROSSxSample/README.md)를 참고하세요.

## 문서

### 기본 문서
- [요구사항 정의서](doc/requirements.md)
- [아키텍처 가이드](doc/architecture.md)
- [트랜잭션 컨펌 다이얼로그](doc/transaction-confirmation.md)
- [OAuth 연동 가이드](doc/oauth-integration.md)
- [OAuth 엔드포인트](doc/oauth-endpoints.md)
- [JWT 검증 가이드](doc/jwt-validation.md)
- [API 엔드포인트](doc/api-endpoints.md)

### 보안 문서
- [Token Management](doc/token-management.md) - 토큰 저장 및 관리 상세 가이드
- [Token Storage Summary](doc/token-storage-summary.md) - 토큰 저장 구조 요약

### 플랫폼 문서
- [플랫폼별 OAuth 처리 방식](doc/platform-differences.md) - Web vs iOS vs Unity
- [Unity용 Native OAuth Package](doc/native-oauth-package.md) - Unity SDK 연동 가이드

## 아키텍처

CROSSx SDK는 **Clean Architecture + Hexagonal Architecture (Ports & Adapters)** 패턴을 사용합니다.

```
Sources/CROSSxSDK/
 ├─ Core/          # 순수 비즈니스 로직
 │   ├─ UseCases/  # Use Cases
 │   ├─ Ports/     # Protocols (Ports)
 │   └─ Types/     # 도메인 타입
 │
 ├─ Adapters/      # 플랫폼 구현체
 │   ├─ Crypto/
 │   ├─ Storage/
 │   ├─ OAuth/
 │   └─ ...
 │
 └─ SDK/           # 공개 API
     └─ CROSSxSDK.swift
```

## 다국어(i18n) 지원

SDK는 `Bundle.module` 기반의 Apple 표준 `.strings` 리소스를 사용합니다.

### 지원 언어
| 언어 | 코드 | 상태 |
|------|------|------|
| English | `en` | 기본 언어 |
| 한국어 | `ko` | 지원 |

### 새 언어 추가

코드 변경 없이 `.lproj` 폴더만 추가하면 됩니다:

```
Sources/CROSSxCoreSDK/Resources/
  ├── en.lproj/Localizable.strings  (기본)
  ├── ko.lproj/Localizable.strings  (한국어)
  └── ja.lproj/Localizable.strings  (추가할 언어)
```

### 구조

```
L10n.swift (타입-세이프 헬퍼)
  └── NSLocalizedString + Bundle.module
       ├── en.lproj/Localizable.strings (82개 키)
       └── ko.lproj/Localizable.strings (82개 키)
```

## 배포

### 레포지토리 구조

| 레포지토리 | 역할 | 최소 iOS |
|---|---|---|
| `crossy-sdk-ios-develop` | 소스 개발, 테스트, CI/CD | — |
| `crossx-sdk-ios` | xcframework 바이너리 배포 (SPM / CocoaPods) | — |

```
crossy-sdk-ios-develop/          ← 이 레포 (개발)
  Package.swift                  ← CROSSxCoreSDK (iOS 15)
  Sources/CROSSxCoreSDK/
  CrossWebAuthKit/               ← 독립 하위 패키지
    Package.swift                ← CrossWebAuthKit (iOS 13)
    Sources/CrossWebAuthKit/
```

### 릴리즈 절차

#### 1. CHANGELOG.md 업데이트

`[Unreleased]` 섹션의 내용을 릴리즈 버전으로 이동합니다.

```markdown
## [1.x.x] - YYYY-MM-DD
### Added
- ...
```

#### 2. 버전 상수 업데이트 및 커밋

```bash
# Sources/CROSSxCoreSDK/SDK/CROSSxSDK.swift
public static let version = "1.x.x"

# CrossWebAuthKit/Sources/CrossWebAuthKit/CrossWebAuthKit.swift
public static let version = "1.x.x"
```

```bash
git add -A
git commit -m "chore: 버전 1.x.x"
```

#### 3. 릴리즈 태그 생성 및 push

```bash
# 패치 버전 자동 증가 (1.0.0 → 1.0.1)
./scripts/tag-release.sh patch

# 마이너 버전 자동 증가 (1.0.0 → 1.1.0)
./scripts/tag-release.sh minor

# 버전 직접 지정
./scripts/tag-release.sh 1.2.0
```

태그 push 이후 GitHub Actions가 자동으로:
1. 전체 테스트 실행 (`CROSSxCoreSDK` + `CrossWebAuthKit`)
2. xcframework 빌드 (`CROSSxSDK.xcframework`, `CrossWebAuthKit.xcframework`)
3. 배포 레포(`crossx-sdk-ios`)에 xcframework 복사 및 버전 업데이트
4. 양쪽 레포에 GitHub Release 생성

> 자세한 내용 → [DEPLOYMENT.md](DEPLOYMENT.md)

### 스크립트

| 스크립트 | 설명 |
|---|---|
| `./scripts/tag-release.sh [patch\|minor\|major\|x.y.z]` | 릴리즈 태그 생성 및 push |
| `./scripts/update-version.sh <version> <deploy_repo>` | 버전 일괄 업데이트 + xcframework 복사 (CI용) |

## 라이선스

MIT License. 자세한 내용은 [LICENSE](LICENSE) 파일을 참고하세요.

---

**버전**: 1.0.1  
**최종 수정일**: 2026-03-13
