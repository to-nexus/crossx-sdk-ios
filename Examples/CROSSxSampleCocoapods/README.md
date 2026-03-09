# CROSSx SDK CocoaPods Sample App

CocoaPods를 사용하여 CROSSx iOS SDK를 연동하는 샘플 애플리케이션입니다.

## 요구사항

- Xcode 15.0+
- iOS 15.0+
- Swift 5.9+
- [CocoaPods](https://cocoapods.org/) 설치

## CocoaPods 설치

```bash
sudo gem install cocoapods
```

또는 Homebrew로 설치:

```bash
brew install cocoapods
```

## 프로젝트 설정

### 1. Xcode 프로젝트 생성

`xcodeproj` Ruby gem(CocoaPods 의존성으로 자동 설치됨)을 활용한 스크립트로 프로젝트를 생성합니다:

```bash
cd Examples/CROSSxSampleCocoapods
ruby setup.rb
```

### 2. Pod 설치

```bash
pod install
```

### 3. Workspace 열기

```bash
open CROSSxSampleCocoapods.xcworkspace
```

> **주의**: `.xcodeproj`가 아닌 **`.xcworkspace`**를 열어야 합니다.

## 실행 방법

1. Xcode에서 `CROSSxSampleCocoapods` 타겟 선택
2. 시뮬레이터 또는 실제 기기 선택
3. `Cmd + R` 또는 Run 버튼 클릭

## 기능

샘플 앱은 다음 기능을 제공합니다:

| 기능 | 설명 |
|------|------|
| SDK 초기화 | `SDKConfig.fromInfoPlist(projectId:)` |
| 세션 복원 | `sdk.initialize()` |
| OAuth 로그인 | `sdk.signIn()` |
| 로그아웃 | `sdk.signOut()` |
| 지갑 생성 | `sdk.createWallet()` |
| 지갑 조회 | `sdk.getAddresses()`, `sdk.getBalance()` |
| 트랜잭션 서명 | `sdk.signTransaction()` |
| 메시지 서명 | `sdk.signMessage()`, `sdk.signTypedData()` |
| ERC20 전송 | `sdk.sendTransactionAndWait()` |
| 네이티브 전송 | `sdk.sendTransactionAndWait()` |

## Podfile

```ruby
platform :ios, '15.0'

target 'CROSSxSampleCocoapods' do
  use_frameworks!

  pod 'CrossWebAuthKit', :path => '../../'
  pod 'CROSSxSDK', :path => '../../'
end
```

실제 프로젝트에서는 `:path` 대신 버전을 지정합니다:

```ruby
pod 'CROSSxSDK', '~> 1.0'
```

## 설정

### Project ID 설정

`Configurations/Debug.xcconfig`에서 Project ID를 변경합니다:

```
CROSSX_PROJECT_ID = your-project-id
```

### 환경 설정 (Staging vs Production)

| Configuration | 환경 | 설명 |
|---------------|------|------|
| Debug | Staging | 개발/테스트용, URL 명시적 설정 |
| Release | Production | URL 미설정시 자동 Production |

## 디렉토리 구조

```
CROSSxSampleCocoapods/
├── Podfile                       # CocoaPods 의존성 정의
├── setup.rb                      # Xcode 프로젝트 생성 스크립트
├── README.md
├── Configurations/
│   ├── Debug.xcconfig            # Staging 환경 설정
│   └── Release.xcconfig          # Production 환경 설정
├── Sources/
│   ├── AppDelegate.swift         # 앱 진입점, URL 핸들링
│   └── MainViewController.swift  # SDK 사용 예제 UI
└── Resources/
    ├── Info.plist                # URL Scheme, SDK 설정
    └── LaunchScreen.storyboard
```

## Custom URL Scheme

OAuth 콜백을 위해 다음 URL Scheme이 Info.plist에 설정됩니다:

- `crossx-{PROJECT_ID}://`

## 문제 해결

### Pod Install 실패

```bash
pod repo update
pod install
```

### 빌드 에러

1. `.xcworkspace`를 열었는지 확인
2. Derived Data 삭제 후 재빌드:
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData
   ```
3. Pod 재설치:
   ```bash
   pod deintegrate
   ruby setup.rb
   pod install
   ```

## 참고 문서

- [CROSSx SDK README](../../README.md)

---

**버전**: 1.0
