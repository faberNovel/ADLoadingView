source 'git@scm.applidium.net:CocoaPodsSpecs.git'
source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!

pod 'CocoaLumberjack/Swift', '~>  3.0', :inhibit_warnings => true
pod 'ADDynamicLogLevel', '~>  2.0', :inhibit_warnings => true

abstract_target 'ADLoadingViewSample_Apps' do
  pod 'ADLoadingView', :path => './'
  pod 'Alamofire', '~> 4.0'

  target 'ADLoadingViewSample' do
    platform :ios, '8.0'
  end
  target 'ADLoadingViewSample_TV' do
    platform :tvos, '9.0'
  end
end

target 'ADLoadingViewSampleTests' do
  platform :ios, '8.0'
  pod 'Quick', '~>  1.1'
  pod 'Nimble', '~>  6.0'
  pod 'Nimble-Snapshots', '~>  4.4'
  pod 'OCMock', '~>  3.4'
  pod 'FBSnapshotTestCase', '~>  2.1'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
            config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
            config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
        end
    end
end
