platform :ios, '9.0'
inhibit_all_warnings!

target 'Zero' do
  use_frameworks!

  # Architecture
  pod 'ReactorKit'

  # Networking
  pod 'Moya/RxSwift', :git => 'https://github.com/Moya/Moya.git', :branch => '10.0.0-dev'
  pod 'MoyaSugar/RxSwift', :git => 'https://github.com/devxoul/MoyaSugar.git', :branch => 'master'

  # Rx
  pod 'RxSwift', '4.0.0-beta.0'
  pod 'RxCocoa', '4.0.0-beta.0'
  pod 'RxDataSources', :git => 'https://github.com/RxSwiftCommunity/RxDataSources.git', :branch => 'swift4.0'
  pod 'Differentiator', :git => 'https://github.com/RxSwiftCommunity/RxDataSources.git', :branch => 'swift4.0'
  pod 'RxOptional'
  pod 'RxKeyboard'
  pod 'RxGesture', :git => 'https://github.com/sidmani/RxGesture.git', :branch => 'swift-4'

  # UI
  pod 'SnapKit', '~> 4.0.0'
  pod 'ManualLayout'

  # Logging
  pod 'CocoaLumberjack/Swift'

  # Misc.
  pod 'ReusableKit'
  pod 'SwipeCellKit', :git => 'https://github.com/SwipeCellKit/SwipeCellKit.git', :branch => 'swift4'
  pod 'UITextView+Placeholder'

  # Testing
  target 'ZeroTests' do
    pod 'RxTest', '4.0.0-beta.0'
    pod 'RxExpect'
    pod 'RxOptional'
  end

end

post_install do |installer|
  pods_dir = File.dirname(installer.pods_project.path)
end
