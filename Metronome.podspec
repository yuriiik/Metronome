#
# Be sure to run `pod lib lint Metronome.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Metronome'
  s.version          = '0.1.0'
  s.summary          = 'A simple metronome.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Metronome view controller that can be embedded into your app and used right away. Metronome implementation itself is based on Apple’s example (https://developer.apple.com/library/content/samplecode/HelloMetronome/Introduction/Intro.html).
                       DESC

  s.homepage         = 'https://github.com/yuriiik/Metronome'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Yurii Kupratsevych' => 'kupratsevich@gmail.com' }
  s.source           = { :git => 'https://github.com/yuriiik/Metronome.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'Metronome/Classes/**/*.{h,m}'

  s.resource_bundles = {
    'Metronome' => ['Metronome/Assets/*.mp3', 'Metronome/Classes/*.xib']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
