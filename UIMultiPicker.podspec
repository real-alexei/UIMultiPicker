Pod::Spec.new do |s|
  s.name             = 'UIMultiPicker'
  s.version          = '0.1.0'
  s.summary          = 'UIPickerView with multiple selection support.'
  s.homepage         = 'https://cocoapods.org/pods/UIMultiPicker'
  s.license          = { :type => 'MIT' }
  s.author           = { 'Alexei Selivanov' => 'alexei@slowmotion.io' }
  s.source           = { :git => 'https://github.com/aselivanov/UIMultiPicker.git', :tag => s.version.to_s }
  s.swift_version    = '4.2'

  s.ios.deployment_target = '8.0'
  
  s.source_files = 'Classes/**/*'
end
