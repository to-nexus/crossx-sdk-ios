# CROSSx SDK Sample App

CROSSx iOS SDK를 사용하는 샘플 애플리케이션입니다.

## 요구사항

- Xcode 15.0+
- iOS 15.0+
- Swift 5.9+
- [Tuist](https://tuist.io) 설치

## Tuist 설치

```bash
curl -Ls https://install.tuist.io | bash
```

또는 Homebrew로 설치:

```bash
brew install --cask tuist
```

## 프로젝트 생성

Tuist를 사용하여 Xcode 프로젝트를 생성합니다:

```bash
cd Examples/CROSSxSample
tuist install
tuist generate
```

이 명령어는 다음 작업을 수행합니다:
1. 의존성 설치 (SPM 패키지)
2. Xcode 프로젝트 생성
3. `CROSSxSample.xcodeproj` 및 `CROSSxSample.xcworkspace` 생성

## 프로젝트 열기

```bash
open CROSSxSample.xcworkspace
```

또는 Xcode에서 직접 `CROSSxSample.xcworkspace`를 엽니다.

## 실행 방법

1. Xcode에서 `CROSSxSample` 타겟 선택
2. 시뮬레이터 또는 실제 기기 선택
3. `Cmd + R` 또는 Run 버튼 클릭

## 기능

샘플 앱은 다음 기능을 제공합니다:

### 1. SDK 초기화
- SDK 설정 및 초기화
- 세션 복원

### 2. 로그인 (Sign In)
- OAuth 기반 로그인
- JWT 검증
- 지갑 생성/로드

### 3. 로그아웃 (Sign Out)
- 세션 제거
- 로컬 데이터 삭제

### 4. 로그 출력
- 모든 SDK 작업의 로그 표시
- 타임스탬프 포함

## Custom URL Scheme

앱은 OAuth 콜백을 위해 다음 Custom URL Scheme을 사용합니다:

- `crossxsample://callback`

이는 `Info.plist`에 자동으로 설정됩니다.

## 설정

### Client ID 설정 (필수)

샘플 앱을 실행하려면 Client ID를 설정해야 합니다:

1. `Configurations/Debug.xcconfig` 파일 열기
2. `CROSSX_CLIENT_ID` 값을 본인의 Client ID로 변경:

```
CROSSX_CLIENT_ID = your-client-id
```

3. Tuist로 프로젝트 재생성:

```bash
tuist generate
```

> ⚠️ **주의**: Client ID가 설정되지 않으면 앱이 crash됩니다.

### 환경 설정 (Staging vs Production)

샘플 앱은 개발/테스트 목적으로 **Staging 환경**을 기본으로 사용합니다:

#### Debug Configuration (Staging)
`Configurations/Debug.xcconfig`:
```
CROSSX_OAUTH_SERVICE_URL = https://stg-cross-wallet-oauth.crosstoken.io
CROSSX_API_BASE_URL = https://stg-cross-auth.crosstoken.io
CROSSX_CLIENT_ID = your-client-id
```

#### Release Configuration (Production)
`Configurations/Release.xcconfig`:
```
CROSSX_CLIENT_ID = your-client-id
```
- URL은 설정하지 않으면 자동으로 Production 환경 사용

> 💡 **참고**: 
> - Debug 빌드 → Staging 서버
> - Release 빌드 → Production 서버
> - 일반 사용자 앱에서는 URL 설정 불필요 (자동 Production)

## 디렉토리 구조

```
CROSSxSample/
├── Project.swift                  # Tuist 프로젝트 정의
├── Tuist/
│   ├── Config.swift              # Tuist 설정
│   └── ProjectDescriptionHelpers/
│       └── Path+Extensions.swift # 헬퍼 함수
└── CROSSxSample/
    ├── Sources/                  # 앱 소스 코드
    │   ├── AppDelegate.swift
    │   └── MainViewController.swift
    ├── Resources/                # 리소스 파일
    │   └── LaunchScreen.storyboard
    └── Tests/                    # 단위 테스트
```

## 문제 해결

### Tuist 관련

**문제**: `tuist generate` 실패

**해결**:
```bash
tuist clean
tuist install
tuist generate
```

### 의존성 관련

**문제**: CROSSx를 찾을 수 없음

**해결**:
1. 루트 디렉토리에 `Package.swift`가 있는지 확인
2. Tuist 프로젝트 재생성:
   ```bash
   tuist clean
   tuist generate
   ```

### 빌드 관련

**문제**: 빌드 에러

**해결**:
1. Xcode를 완전히 종료
2. Derived Data 삭제:
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData
   ```
3. 프로젝트 재생성 후 다시 빌드

## 참고 문서

- [CROSSx SDK 문서](../../doc/)
- [Tuist 문서](https://docs.tuist.io)
- [아키텍처 가이드](../../doc/architecture.md)
- [OAuth 연동 가이드](../../doc/oauth-integration.md)

---

**버전**: 1.0  
**최종 수정일**: 2026-02-06
