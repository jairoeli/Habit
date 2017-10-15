platform :ios, '9.0'
inhibit_all_warnings!

target 'Zero' do
  use_frameworks!

  # Architecture
  pod 'ReactorKit'

  # Networking
  pod 'Moya/RxSwift', '10.0.0-beta.1'
  pod 'MoyaSugar/RxSwift', '10.0.0-beta.1'

  # Rx
  pod 'RxSwift', '4.0.0-rc.0'
  pod 'RxCocoa', '4.0.0-rc.0'
  pod 'RxDataSources', '3.0.0-rc.0'
  pod 'Differentiator', '3.0.0-rc.0'
  pod 'RxOptional'
  pod 'RxKeyboard'
  pod 'RxGesture', :git => 'https://github.com/RxSwiftCommunity/RxGesture.git', :branch => 'swift-4'

  # UI
  pod 'SnapKit', '~> 4.0.0'
  pod 'ManualLayout'

  # Logging
  pod 'CocoaLumberjack/Swift'

  # Misc.
  pod 'ReusableKit'
  pod 'SwipeCellKit'
  pod 'UITextView+Placeholder'

  # Testing
  target 'ZeroTests' do
    pod 'RxTest', '4.0.0-rc.0'
    pod 'RxExpect', :git => 'https://github.com/devxoul/RxExpect.git', :branch => 'swift-4.0'
    pod 'RxOptional'
  end

end

post_install do |installer|
  pods_dir = File.dirname(installer.pods_project.path)
end
