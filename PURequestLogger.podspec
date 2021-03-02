#
#  Be sure to run `pod spec lint RequestLogger.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  spec.platform     = :ios
  spec.name         = "PURequestLogger"
  spec.version      = "1.0.1"
  spec.summary      = "PURequestLogger is a handy iOS tool for viewing app's network activity."
  
  spec.homepage     = "https://github.com/PUnknown/PURequestLogger"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = "PUnknown"
  spec.source       = { :git => "https://github.com/PUnknown/PURequestLogger.git", :tag => spec.version.to_s }
  
  spec.ios.deployment_target = "10.0"
  spec.source_files = "PURequestLogger/Sources/**/*.{swift}"
  spec.resources = "PURequestLogger/Resources/**/*.{xcdatamodeld}"
  spec.frameworks = "UIKit", "CoreData"
  spec.swift_version = "5.3.2"
  
  spec.description  = <<-DESC
  PURequestLogger
  1.0.1
  	Fixed cURL body composing.
  	Any request/response data larger than 1 MB or that can't be displayed as a JSON is now displayed raw.
  	Minor UI improvements.
  1.0.0
    Initial release
                   DESC

end
