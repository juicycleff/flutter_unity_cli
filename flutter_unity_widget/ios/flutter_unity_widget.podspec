#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_unity_widget'
  s.version          = '0.0.1'
  s.summary          = 'Flutter unity 3D widget for embedding unity in flutter'
  s.description      = <<-DESC
Flutter unity 3D widget for embedding unity in flutter
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.frameworks = 'UnityFramework'

  s.ios.deployment_target = '8.0'
     spec.xcconfig = {
    'FRAMEWORK_SEARCH_PATHS' => '"${PODS_ROOT}/../.symlinks/plugins/flutter_unity_widget/ios" "${PODS_ROOT}/../.symlinks/flutter/ios-release" "${PODS_CONFIGURATION_BUILD_DIR}"',
    'OTHER_LDFLAGS' => '$(inherited) -framework UnityFramework ${PODS_LIBRARIES}'
  }

   # Extract precompiled framework from tarball before compiling
   spec.prepare_command     = "tar -xvjf UnityFramework.tar.bz2"
   spec.vendored_frameworks = "UnityFramework.framework"
  
end
