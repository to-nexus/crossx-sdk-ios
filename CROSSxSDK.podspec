Pod::Spec.new do |s|
  s.name             = 'CROSSxSDK'
  s.version          = '1.0.1'
  s.summary          = 'CROSSx SDK for iOS'
  s.description      = <<-DESC
                       CROSSx SDK provides secure authentication and blockchain functionality for iOS applications.
                       DESC

  s.homepage         = 'https://github.com/to-nexus/crossx-sdk-ios'
  s.license          = { :type => 'MIT' }
  s.author           = { 'to-nexus' => 'contact@to-nexus.com' }
  s.source           = { :git => 'https://github.com/to-nexus/crossx-sdk-ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '15.0'
  s.osx.deployment_target = '12.0'
  
  s.vendored_frameworks = 'CROSSxSDK.xcframework'
  
  s.dependency 'CrossWebAuthKit', '~> 1.0.1'
end
