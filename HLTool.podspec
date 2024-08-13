#
# Be sure to run `pod lib lint HLTool.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HLTool'
  s.version          = '1.2.5'
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
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'huangchangweng' => '599139419@qq.com' }
  s.source           = { :git => 'https://github.com/huangchangweng/HLTool.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.source_files = 'HLTool/Classes/HLTool.h'
  
  # Core
  s.subspec 'Core' do |ss|
    ss.source_files = 'HLTool/Classes/Core/*.{h,m}'
    ss.resources   = 'HLTool/Assets/*.{png,xib,nib,bundle}'
  end
  
  # Alert
  s.subspec 'Alert' do |ss|
    ss.source_files = 'HLTool/Classes/Alert/*.{h,m}'
    ss.dependency 'HLTool/Core'
    ss.dependency 'SPAlertController', '~> 4.0.0'
  end

  # EmptyDataSet
  s.subspec 'EmptyDataSet' do |ss|
    ss.source_files = 'HLTool/Classes/EmptyDataSet/*.{h,m}'
    ss.dependency 'HLTool/Core'
    ss.dependency 'DZNEmptyDataSet', '~> 1.8.1'
  end

  # HUD
  s.subspec 'HUD' do |ss|
    ss.source_files = 'HLTool/Classes/HUD/*.{h,m}'
    ss.dependency 'HLTool/Core'
    ss.dependency 'Toast', '~> 4.0.0'
    ss.dependency 'MBProgressHUD', '~> 1.2.0'
  end

  # IBInspectable
  s.subspec 'IBInspectable' do |ss|
    ss.source_files = 'HLTool/Classes/IBInspectable/*.{h,m}'
  end

  # LoadingView
  s.subspec 'LoadingView' do |ss|
    ss.source_files = 'HLTool/Classes/LoadingView/*.{h,m}'
    ss.dependency 'HLTool/Core'
    ss.dependency 'JHUD', '~> 0.3.0'
  end

  # Network
  s.subspec 'Network' do |ss|
    ss.source_files = 'HLTool/Classes/Network/*.{h,m}'
    ss.dependency 'HLTool/Core'
    ss.dependency 'YYCache', '~> 1.0.4'
    ss.dependency 'AFNetworking', '~> 4.0.1'
  end

  # Photo
  s.subspec 'Photo' do |ss|
    ss.source_files = 'HLTool/Classes/Photo/*.{h,m}'
    ss.dependency 'HLTool/Alert'
    ss.dependency 'HLTool/HUD'
    ss.dependency 'HXPhotoPickerObjC', '~> 3.3.4'
    ss.dependency 'HXPhotoPickerObjC/SDWebImage_AF', '~> 3.3.4'
  end

  # Popup
  s.subspec 'Popup' do |ss|
    ss.source_files = 'HLTool/Classes/Popup/*.{h,m}'
    ss.dependency 'HLTool/Alert'
    ss.dependency 'YBPopupMenu', '~> 1.1.9'
  end

  # Refresh
  s.subspec 'Refresh' do |ss|
    ss.source_files = 'HLTool/Classes/Refresh/*.{h,m}'
    ss.dependency 'HLTool/Core'
    ss.dependency 'MJRefresh', '~> 3.7.5'
  end

end
