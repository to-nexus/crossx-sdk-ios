# CROSSx iOS SDK - xcframework 배포

이 디렉토리는 CROSSx iOS SDK의 xcframework 빌드 결과물입니다.

## 포함된 프레임워크

### 1. CROSSxSDK.xcframework
메인 SDK - OAuth 인증, Embedded Wallet 기능 제공

### 2. CrossWebAuthKit.xcframework
웹 인증 라이브러리 - ASWebAuthenticationSession 래퍼 (독립 사용 가능)

## 설치 방법

### Xcode 프로젝트에 추가

1. Xcode에서 프로젝트 열기
2. 타겟 선택 → General 탭
3. "Frameworks, Libraries, and Embedded Content" 섹션
4. '+' 버튼 클릭 → "Add Other..." → "Add Files..."
5. `CROSSxSDK.xcframework` 선택
6. (필요시) `CrossWebAuthKit.xcframework` 선택
7. "Embed & Sign" 선택

### Swift Package Manager로 로컬 추가

```swift
// Package.swift
dependencies: [
    .package(path: "../crossx-sdk-ios/CROSSxSDK.xcframework")
]
```

## 사용 예시

```swift
import CROSSxSDK

let sdk = CROSSxSDK(config: SDKConfig(
    oauthServiceUrl: "https://stg-cross-wallet-oauth.crosstoken.io",
    clientId: "your-client-id"
))

// 로그인
let result = try await sdk.signIn()
print("지갑 주소: \(result.walletAddress ?? "")")
```

## 지원 플랫폼

- iOS 15.0+
- macOS 12.0+
- iOS Simulator (arm64, x86_64)

## 의존성

✅ 외부 의존성 없음 (100% 순수 Swift)

## 아키텍처

각 xcframework는 다음 아키텍처를 지원합니다:
- `ios-arm64`: iOS Device (iPhone, iPad)
- `ios-arm64_x86_64-simulator`: iOS Simulator (M1/M2 Mac + Intel Mac)

---

**빌드 날짜**: $(date '+%Y-%m-%d %H:%M:%S')  
**소스**: crossy-sdk-ios-develop
