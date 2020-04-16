# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'MyHealth' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MyHealth
  pod "Comets"
  pod 'Cards'
  pod 'Charts'
  pod 'Alamofire', '~> 4.5'
  pod 'SkyFloatingLabelTextField'
  pod 'FontAwesome.swift', '~> 1.9.0'
  pod "LetterAvatarKit"

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings['LD_RUNPATH_SEARCH_PATHS'] = [
      '$(FRAMEWORK_SEARCH_PATHS)'
    ]
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
   end
end
end

end
