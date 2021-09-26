Pod::Spec.new do |s|
  s.name         = 'BugsplatMac'
  s.version      = '1.1.1'
  s.license      = { :type => 'MIT', :file => 'LICENSE.txt' }
  s.homepage	 	 = 'http://bugsplat.com'
  s.summary      = 'Bugsplat macOS framework'
  s.author       = 'Geoff Raeder'
  s.source 		   = { :http => "https://github.com/BugSplatGit/BugsplatMac/releases/download/#{s.version}/BugsplatMac.framework.zip" }
  s.platform     = :osx, '10.9'
  s.requires_arc = true
  s.vendored_frameworks = 'Carthage/Build/Mac/BugsplatMac.framework'
  s.resource = 'Carthage/Build/Mac/BugsplatMac.framework'
  s.xcconfig = { 'LD_RUNPATH_SEARCH_PATHS' => '@executable_path/../Frameworks' }
end
