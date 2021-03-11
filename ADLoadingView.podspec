Pod::Spec.new do |spec|
  spec.name         = 'ADLoadingView'
  spec.version      = '2.5.1'
  spec.authors      = 'Applidium'
  spec.license      = 'none'
  spec.homepage     = 'http://applidium.com'
  spec.summary      = 'Applidium\'s loading view category on UIView'
  spec.ios.deployment_target = '6.0'
  spec.tvos.deployment_target = '9.0'
  spec.license      = { :type => 'Commercial', :text => 'Created and licensed by Applidium. Copyright 2016 Applidium. All rights reserved.' }
  spec.source       = { :git => 'ssh://git@gerrit.applidium.net:29418/ADLoadingView.git', :tag => "v#{spec.version}" }
  spec.source_files = 'Modules/ADLoadingView/Classes/*.{h,m}'
  spec.framework    = 'Foundation', 'UIKit'
  spec.requires_arc = true
end
