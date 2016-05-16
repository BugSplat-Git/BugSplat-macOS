Pod::Spec.new do |s|
  s.name         = 'BugsplatMac'
  s.version      = '0.9.9'
  s.license      = 'MIT'
  s.homepage	 = 'http://bugsplatsoftware.com'
  s.summary      = 'Bugsplat OS X framework'
  s.author       = 'Geoff Raeder'
  s.source 		 = { :http => "https://github.com/BugSplatGit/BugsplatMac/releases/download/#{s.version}/BugsplatMac-0.9.9.zip" }
  s.platform     = :osx, '10.7'
  s.requires_arc = true
  s.vendored_frameworks = 'BugsplatMac/BugsplatMac.framework'
  s.resource = 'BugsplatMac/BugsplatMac.framework'
  s.xcconfig = { 'LD_RUNPATH_SEARCH_PATHS' => '@executable_path/../Frameworks' }
  s.dependency 'HockeySDK-Mac', '~> 3.2.1'
end