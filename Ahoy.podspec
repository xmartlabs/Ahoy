Pod::Spec.new do |s|
  s.name             = "Ahoy"
  s.version          = "1.0.0"
  s.summary          = "A lightweight swift library to build onboardings."
  s.homepage         = "https://github.com/xmartlabs/Ahoy"
  s.license          = { type: 'MIT', file: 'LICENSE' }
  s.author           = { "Xmartlabs SRL" => "swift@xmartlabs.com" }
  s.source           = { git: "https://github.com/xmartlabs/Ahoy.git", tag: s.version.to_s }
  s.social_media_url = 'https://twitter.com/xmartlabs'
  s.ios.deployment_target = '9.0'
  s.requires_arc = true
  s.ios.source_files = ['Sources/**/*.xib', 'Sources/**/*.{swift}']
  s.ios.frameworks = 'UIKit', 'Foundation'
end
