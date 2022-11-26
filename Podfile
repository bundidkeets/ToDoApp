# Uncomment the next line to define a global platform for your project
 platform :ios, '12.0'

target 'ToDoApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

# Fix Warning Pod IPHONEOS_DEPLOYMENT_TARGET
post_install do |installer|
 installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
  end
 end
end
  
  # Pods for ToDoApp
  pod 'Moya'
  pod 'Moya/RxSwift'
  pod 'RxGesture'
  pod 'RxCocoa'
  pod 'Moya-ObjectMapper/RxSwift'
  pod 'SwipeCellKit'
  pod 'PKHUD'
  pod 'IQKeyboardManagerSwift'
  pod 'UIColor_Hex_Swift'
  pod 'IQActionSheetPickerView'
end
