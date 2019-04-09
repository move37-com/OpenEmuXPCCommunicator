#
#  Be sure to run `pod spec lint OpenEmuXPCCommunicator.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "OpenEmuXPCCommunicator"
  spec.version      = "1.0.0"
  spec.summary      = "A short description of OpenEmuXPCCommunicator."
  spec.description  = <<-DESC
  OpenEmuXPCCommunicator. That's it.
                   DESC
  spec.homepage     = "http://EXAMPLE/OpenEmuXPCCommunicator"
  spec.license      = "MIT"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "Konstantin Gonikman" => "info@alstertouch.de" }
  spec.platform     = :osx, '10.13'
  spec.source       = { :git => "https://github.com/move37-com/OpenEmuXPCCommunicator", :tag => "#{spec.version}" }
  spec.source_files  = "OpenEmuXPCCommunicator/**/*.{h,m}", "OpenEmuXPCCommunicatorAgent/OEXPCCMatchMaking.h"
  spec.resource = 'bin/OpenEmuXPCCommunicatorAgent'
end
