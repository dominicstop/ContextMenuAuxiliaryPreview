
Pod::Spec.new do |s|
  s.name             = 'ContextMenuAuxiliaryPreview'
  s.version          = '0.2.2'
  s.summary          = 'TBA'

  
  s.source           = { :git => 'https://github.com/dominicstop/ContextMenuAuxiliaryPreview.git', :tag => s.version.to_s }
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
 
  s.homepage         = 'https://github.com/dominicstop/ContextMenuAuxiliaryPreview'
  s.author           = { 'Dominic Go' => 'dominic@dominicgo.dev' }
  s.social_media_url = 'https://twitter.com/@GoDominic'

  s.dependency 'DGSwiftUtilities', '~> 0'

  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'
  s.frameworks = 'UIKit'

  s.source_files = 'Sources/**/*'
end
