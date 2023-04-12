#
# Be sure to run `pod lib lint HLTool.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HLTool'
  s.version          = '0.3.0'
  s.summary          = 'iOS开发工具类集合'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/huangchangweng/HLTool'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'huangchangweng' => '599139419@qq.com' }
  s.source           = { :git => 'https://github.com/huangchangweng/HLTool.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'HLTool/Classes/**/*'
  
  s.subspec 'Alert' do |ss|
    ss.source_files = 'HLTool/Classes/Alert/*.{h,m}'
#    ss.dependency 'HLTool/Classes/Core'
  end

  s.subspec 'Core' do |ss|
    ss.source_files = 'HLTool/Classes/Core/*.{h,m}'
  end
  
  s.subspec 'EmptyDataSet' do |ss|
    ss.source_files = 'HLTool/Classes/EmptyDataSet/*.{h,m}'
#    ss.dependency 'HLTool/Classes/Core'
  end
  
  s.subspec 'HUD' do |ss|
    ss.source_files = 'HLTool/Classes/HUD/*.{h,m}'
#    ss.dependency 'HLTool/Classes/Core'
  end
  
  s.subspec 'IBInspectable' do |ss|
    ss.source_files = 'HLTool/Classes/IBInspectable/*.{h,m}'
  end
  
  s.subspec 'LoadingView' do |ss|
    ss.source_files = 'HLTool/Classes/LoadingView/*.{h,m}'
#    ss.dependency 'HLTool/Classes/Core'
  end
  
  s.subspec 'Network' do |ss|
    ss.source_files = 'HLTool/Classes/Network/*.{h,m}'
#    ss.dependency 'HLTool/Classes/Core'
  end
  
  s.subspec 'Photo' do |ss|
    ss.source_files = 'HLTool/Classes/Photo/*.{h,m}'
#    ss.dependency 'HLTool/Classes/Core'
  end
  
  s.subspec 'Popup' do |ss|
    ss.source_files = 'HLTool/Classes/Popup/*.{h,m}'
#    ss.dependency 'HLTool/Classes/Core'
  end
  
  s.subspec 'Refresh' do |ss|
    ss.source_files = 'HLTool/Classes/Refresh/*.{h,m}'
#    ss.dependency 'HLTool/Classes/Core'
  end
    
    # s.resource_bundles = {
    #   'HLTool' => ['HLTool/Assets/*.png']
    # }
  
  # s.resource_bundles = {
  #   'HLTool' => ['HLTool/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  
  s.resources   = 'HLTool/Assets/*.{png,xib,nib,bundle}'
  
  s.dependency 'Toast', '~> 4.0.0'
  s.dependency 'SPAlertController', '~> 4.0.0'
  s.dependency 'MBProgressHUD', '~> 1.2.0'
  s.dependency 'HXPhotoPicker', '~> 3.2.1'
  s.dependency 'HXPhotoPicker/SDWebImage_AF', '~> 3.2.1'
  s.dependency 'YBPopupMenu', '~> 1.1.9'
  s.dependency 'DZNEmptyDataSet', '~> 1.8.1'
  s.dependency 'MJRefresh', '~> 3.7.5'
  s.dependency 'YYCache', '~> 1.0.4'
  s.dependency 'MJRefresh', '~> 3.7.5'
  s.dependency 'JHUD', '~> 0.3.0'
  s.dependency 'AFNetworking', '~> 4.0.1'
  
end
