Pod::Spec.new do |s|
  s.name = 'ReaderSDK'
  s.version = '2.42.2'
  s.summary = 'ReaderSDK is a propietary SDK for reading magazines in mobile platforms.'
  
  s.description  = <<-DESC
  The SDK provides access to the following use cases:
  * Download and delete issues.
  * Open the reader for an issue.
  * Open the reader for an article.
  * Manage Bookmarks.
  DESC
  
  s.homepage = 'http://www.zinio.com'
  s.license = { type: 'Copyright', file: 'LICENSE.md' }
  s.author = 'Zinio LLC'
  
  s.platform = :ios, '12.0'
  s.ios.deployment_target = '12.0'

  s.source = { git: 'git@bitbucket.org:ziniollc/ios-reader-demo.git', tag: "#{s.version}" }
  
  s.vendored_frameworks = 'ReaderSDK.xcframework'
  s.swift_version = '5.6'
  
  s.requires_arc = true
  
  # dependencies
  s.dependency 'Zip', '2.1.2'
  s.dependency 'RealmSwift', '10.28.0'
  s.dependency 'RxRelay', '~>5.1.0'
  s.dependency 'KeychainAccess', '~>4.1.0'
  s.dependency 'SnapKit', '5.6.0'
  s.dependency 'Kingfisher', '~>7.3.0'
end
