#
# Be sure to run `pod lib lint Canvas.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

    Pod::Spec.new do |s|
    s.name             = '+Canvas+'
    s.version          = '1.1.6'
    s.summary          = 'Create artistic applications extremely easily.'

    # This description is used to generate tags and improve search results.
    #   * Think: What does it do? Why did you write it? What is the focus?
    #   * Try to keep it short, snappy and to the point.
    #   * Write the description between the DESC delimiters below.
    #   * Finally, don't worry about the indent, CocoaPods strips it!

    s.description      = <<-DESC
    Canvas provides a simple solution to creating freeform drawings in iOS applications. This means that the user no longer needs to write messy code when trying to create something like a simple painting application.
    DESC

    s.homepage         = 'https://github.com/authman2/Canvas'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'authman2' => 'authman2@gmail.com' }
    s.source           = { :git => 'https://github.com/authman2/Canvas.git', :tag => s.version.to_s }
    # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

    s.ios.deployment_target = '9.0'

    s.source_files = 'Canvas/Classes/**/*'

    # s.resource_bundles = {
    #   'Canvas' => ['Canvas/Assets/*.png']
    # }

    # s.public_header_files = 'Pod/Classes/**/*.h'
    # s.frameworks = 'UIKit', 'MapKit'
    # s.dependency 'AFNetworking', '~> 2.3'
end
