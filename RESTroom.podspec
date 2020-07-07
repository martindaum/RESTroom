Pod::Spec.new do |s|
  s.name             = 'RESTroom'
  s.version          = '0.0.9'
  s.summary 		     = 'Easy APIClient written in Swift'
  s.homepage         = 'https://github.com/martindaum/RESTroom'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'martindaum' => 'office@martindaum.com' }
  s.source           = { :git => 'https://github.com/martindaum/RESTroom.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = '10.12'
  s.tvos.deployment_target = '10.0'
  s.watchos.deployment_target = '3.0'

  s.default_subspec = "Core"
  s.swift_version = '5.0'

  s.subspec "Core" do |ss|
    ss.source_files = 'RESTroom/*.{swift}'
    ss.dependency "Alamofire", "~> 5.0"
    ss.framework  = "Foundation"
  end

  s.subspec "RxSwift" do |ss|
    ss.source_files = 'RxRESTroom/*.{swift}'
    ss.dependency "RESTroom/Core"
    ss.dependency "RxSwift", "~> 5.0"
  end
end
