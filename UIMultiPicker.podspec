Pod::Spec.new do |s|
  s.name             = 'UIMultiPicker'
  s.version          = '0.1.0'
  s.summary          = 'UIPickerView with multiple selection support.'
  s.homepage         = 'https://cocoapods.org/pods/UIMultiPicker'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Aleks Selivanov' => 'aleks.selivanov@yahoo.com' }
  s.source           = { :git => 'https://github.com/aselivanov/UIMultiPicker.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  
  s.source_files = 'UIMultiPicker/Classes/**/*'
end
