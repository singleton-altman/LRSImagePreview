#
# Be sure to run `pod lib lint LRSImagePreview.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LRSImagePreview'
  s.version          = '0.1.0'
  s.summary          = 'A short description of LRSImagePreview.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  图片预览
                       DESC

  s.homepage         = 'https://aioser.github.io'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '刘sama' => 'junchen.liu@jiamiantech.com' }
  s.source           = { :git => 'https://github.com/aioser/LRSImagePreview.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'
  s.subspec 'Extern' do |extern|
    extern.source_files = 'LRSImagePreview/Classes/Extern/**/*'
  end
  s.subspec 'Helper' do |helper|
    helper.source_files = 'LRSImagePreview/Classes/Helper/**/*'
    helper.frameworks = 'Photos'
  end
  s.subspec 'Core' do |core|
    core.source_files = 'LRSImagePreview/Classes/Core/**/*'
    # loader.resource_bundles = {
    #   'LRSEntranceSourceLoader' => ['LRSEntranceSourceLoader/Assets/*']
    # }
    core.dependency 'SDWebImage', '~> 5.0'
    # loader.dependency 'BlocksKit/Core', '~> 2.2.5'
    core.dependency 'LRSImagePreview/Extern'
    core.dependency 'LRSImagePreview/Helper'
  end
  # s.resource_bundles = {
  #   'LRSImagePreview' => ['LRSImagePreview/Assets/*.png']
  # }
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
