Pod::Spec.new do |s|
  s.name         = 'BugsplatMac'
  s.version      = '1.1.2'
  s.license      = { :type => 'MIT', :file => 'LICENSE.txt' }
  s.homepage	 	 = 'http://bugsplat.com'
  s.summary      = 'Bugsplat macOS framework'
  s.author       = 'Geoff Raeder'
  s.source			 = { :git => 'https://github.com/BugSplat-Git/BugSplat-macOS.git', :tag => '1.1.2' }
  s.source_files = 'BugsplatMac/**/*.{h,m,mm}'
  s.platform     = :osx, '10.9'
  s.requires_arc = true
  s.vendored_frameworks = '${PODS_ROOT}/BugsplatMac/Vendor/PLCrashReporter/CrashReporter.framework'
  s.xcconfig = { "BUILD_NUMBER" => 1, "VERSION_STRING" => 1.1, 
  	"GCC_PREPROCESSOR_DEFINITIONS" => '$(inherited) FRAMEWORK_VERSION="@\""$(VERSION_STRING)"\"" FRAMEWORK_BUILD="@\""$(BUILD_NUMBER)"\"" $(XCODEBUILD_GCC_PREPROCESSOR_DEFINITIONS)' }
end
