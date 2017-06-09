platform :ios, '10.0'

target 'Zero' do
  use_frameworks!

  # Architecture
  pod 'ReactorKit'

  # Rx
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxDataSources'
  pod 'RxOptional'
  pod 'RxReusable'

  # UI
  pod 'SnapKit'
  pod "ManualLayout"

  # Misc.
  pod 'ReusableKit'
  pod 'URLNavigator'
  pod 'SwiftyImage'

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
