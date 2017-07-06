platform :ios, '10.0'
inhibit_all_warnings!

target 'Zero' do
  use_frameworks!

  # Architecture
  pod 'ReactorKit'

  # Networking
  pod 'Moya/RxSwift'
  pod 'MoyaSugar/RxSwift'

  # Rx
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxDataSources'
  pod 'RxOptional'
  pod 'RxReusable'
  pod 'RxKeyboard'
  pod "RxGesture"

  # UI
  pod 'SnapKit'
  pod 'ManualLayout'

  # Logging
  pod 'CocoaLumberjack/Swift'

  # Misc.
  pod 'ReusableKit'
  pod 'SwipeCellKit'
  pod 'UITextView+Placeholder'

  # Testing
  target 'ZeroTests' do
    pod 'RxTest'
    pod 'RxExpect'
    pod 'RxOptional'
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
