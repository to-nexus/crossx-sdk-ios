import ProjectDescription

let project = Project(
    name: "CROSSxSample",
    organizationName: "io.crosstoken",
    packages: [
        // 로컬 Swift Package 참조
        .local(path: "../../")
    ],
    settings: .settings(
        configurations: [
            .debug(
                name: "Debug",
                xcconfig: "Configurations/Debug.xcconfig"
            ),
            .release(
                name: "Release",
                xcconfig: "Configurations/Release.xcconfig"
            )
        ]
    ),
    targets: [
        .target(
            name: "CROSSxSample",
            destinations: .iOS,
            product: .app,
            bundleId: "com.nexus.crossxsample",
            deploymentTargets: .iOS("15.0"),
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchStoryboardName": "LaunchScreen",
                    "UISupportedInterfaceOrientations": [
                        "UIInterfaceOrientationPortrait",
                        "UIInterfaceOrientationLandscapeLeft",
                        "UIInterfaceOrientationLandscapeRight"
                    ],
                    // xcconfig에서 설정 읽어오기
                    "CROSSxOAuthServiceURL": "$(CROSSX_OAUTH_SERVICE_URL)",
                    "CROSSxAPIBaseURL": "$(CROSSX_API_BASE_URL)",
                    "CROSSxWalletAPIBaseURL": "$(CROSSX_WALLET_API_BASE_URL)",
                    "CROSSxStorageServerAURL": "$(CROSSX_STORAGE_SERVER_A_URL)",
                    "CROSSxStorageServerBURL": "$(CROSSX_STORAGE_SERVER_B_URL)",
                    // URL Scheme (projectId 기반 자동 생성 — SDK가 런타임에 처리)
                    "CFBundleURLTypes": [
                        [
                            "CFBundleTypeRole": "Editor",
                            "CFBundleURLName": "com.nexus.crossxsample",
                            "CFBundleURLSchemes": ["crossx-$(CROSSX_PROJECT_ID)"]
                        ]
                    ]
                ]
            ),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .package(product: "CROSSxSDK", type: .runtime)
            ]
        )
    ]
)
