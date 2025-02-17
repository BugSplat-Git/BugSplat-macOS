[![bugsplat-github-banner-basic-outline](https://user-images.githubusercontent.com/20464226/149019306-3186103c-5315-4dad-a499-4fd1df408475.png)](https://bugsplat.com)
<br/>
# <div align="center">BugSplat</div> 
### **<div align="center">Crash and error reporting built for busy developers.</div>**
<div align="center">
    <a href="https://twitter.com/BugSplatCo">
        <img alt="Follow @bugsplatco on Twitter" src="https://img.shields.io/twitter/follow/bugsplatco?label=Follow%20BugSplat&style=social">
    </a>
    <a href="https://discord.gg/K4KjjRV5ve">
        <img alt="Join BugSplat on Discord" src="https://img.shields.io/discord/664965194799251487?label=Join%20Discord&logo=Discord&style=social">
    </a>
</div>
<br>

> [!WARNING]  
> This SDK has been deprecated. Please use BugSplat's new unified macOS/iOS SDK [bugsplat-apple](https://github.com/BugSplat-Git/bugsplat-apple).

## Introduction

The BugsplatMac macOS framework enables posting crash reports from Cocoa applications to Bugsplat. Visit http://www.bugsplat.com for more information and to sign up for an account. 

## 1. Requirements

* BugsplatMac supports macOS 10.13 and later.
* BugsplatMac supports x86_64 and Apple silicon applications.

## 2. Integration

BugsplatMac supports multiple methods for installing the library in a project.

### Swift Package Manager

We recommend you install BugSplat via Swift Package Manager. You can add `BugsplatMac` as a dependency in the Swift Packages configuration in your Xcode project by pointing to <https://github.com/BugSplat-Git/bugsplat-macos>.

### CocoaPods, Carthage, or Manual Installation

For instructions on how to install via CocoaPods, Carthage, or install manually, please see this repo's [Wiki](https://github.com/BugSplat-Git/BugSplat-macOS/wiki/Installation).

## 3. Usage

### Configuration

BugsplatMac requires a few configuration steps in order integrate the framework with your Bugsplat account

- Add the following key to your app's Info.plist replacing `DATABASE_NAME` with your BugSplat database name

    ```
    <key>BugsplatServerURL</key>
    <string>https://DATABASE_NAME.bugsplat.com/</string>
    ```
    
- Enable `Outgoing Connections (client)` if you're using the App Sandbox

#### Symbol Upload

- You must upload an archive containing your app's binary and symbols to the Bugsplat server in order to symbolicate crash reports. There are scripts to help  with this.  
    - Create a ~/.bugsplat.conf file to store your Bugsplat credentials

        ```
        BUGSPLAT_USER='<username>'
        BUGSPLAT_PASS='<password>'
        ```    
    - One option is to use `upload-symbols.sh` to upload a zip containing the app and dSYM files. This can be run on the command line or integrated into your build/CI process.
    - Another option is to upload an xcarchive generated by Xcode by adding the upload-archive.sh script located in `${PROJECT_DIR}/Pods/BugsplatMac/BugsplatMac/Bugsplat.framework/Versions/A/Resources` as an Archive post-action in your build scheme. Set the "Provide build settings from" target in the dropdown so that the `${PROJECT_DIR}` environment variable can be used to locate upload-archive.sh. The script will be invoked when archiving completes which will upload the xcarchive to Bugsplat for processing. You can view the script output in `/tmp/bugsplat-upload.log`.  To share amongst your team, mark the scheme as 'Shared'.

        ![xcode archive post action](/BugsplatTester/post-archive-script.png?raw=true)

### Initialization
```objc
@import BugsplatMac;
```
```objc
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[BugsplatStartupManager sharedManager] start];
}
```
#### Crash Reporter UI Customization
1. Custom banner image
	- Bugsplat provides the ability to configure a custom image to be displayed in the crash reporter UI for branding purposes.  The image view dimensions are 440x110 and will scale down proportionately. There are 2 ways developers can provide an image:
		1. Set the image property directly on BugsplatStartupManager 
		2. Provide an image named `bugsplat-logo` in the main app bundle or asset catalog

2. User details
	- Set `askUserDetails` to `NO` in order to prevent the name and email fields from displaying in the crash reporter UI. Defaults to `YES`.

	```objc
	- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
	{
		[BugsplatStartupManager sharedManager].delegate = self
		[BugsplatStartupManager sharedManager].askUserDetails = NO;
   		[[BugsplatStartupManager sharedManager] start];
	}
	```

3. Auto submit
	- Set `autoSubmitCrashReport` to `YES` in order to send crash reports to the server automatically without presenting the crash reporter dialogue. Defaults to `NO`.
	
	```objc
	- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
	{
		[BugsplatStartupManager sharedManager].delegate = self
		[BugsplatStartupManager sharedManager].autoSubmitCrashReport = YES;
   		[[BugsplatStartupManager sharedManager] start];
	}
	```

4. Persist user details
	- Set `persistUserDetails` to `YES` to save and restore the user's name and email when presenting the crash reporter dialogue. Defaults to `NO`.

	```objc
	- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
	{
		[BugsplatStartupManager sharedManager].delegate = self
		[BugsplatStartupManager sharedManager].persistUserDetails = YES;
   		[[BugsplatStartupManager sharedManager] start];
	}
	```

5. Expiration time
	- Set `expirationTimeInterval` to a desired value (in seconds) whereby if the difference in time between when the crash occurred and next launch is greater than the set expiration time, auto send the report without presenting the crash reporter dialogue. Defaults to `-1`, which represents no expiration.

	```objc
	- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
	{
		[BugsplatStartupManager sharedManager].delegate = self
		[BugsplatStartupManager sharedManager].expirationTimeInterval = 2200;
   		[[BugsplatStartupManager sharedManager] start];
	}
	```

#### Attachments
1. Bugsplat supports uploading attachments with crash reports. There's a delegate method provided by `BugsplatStartupManagerDelegate` that can be implemented to provide attachments to be uploaded.

	```objc	
	- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
	{
		//set delegate
		[BugsplatStartupManager sharedManager].delegate = self
   		[[BugsplatStartupManager sharedManager] start];
	}

	- (NSArray<BugsplatAttachment *> *)attachmentsForBugsplatStartupManager:(BugsplatStartupManager *)bugsplatStartupManager
	{
	    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"generated" withExtension:@"json"];
	    NSData *data = [NSData dataWithContentsOfURL:fileURL];
	    
	    NSMutableArray *attachments = [[NSMutableArray alloc] init];
	    
	    for (NSUInteger i = 0; i < 4; i++)
	    {
	        BugsplatAttachment *attachment = [[BugsplatAttachment alloc] initWithFilename:[NSString stringWithFormat:@"generated%@.json", @(i)]

			attachmentData:data

			contentType:@"application/json"];
	        
	        [attachments addObject:attachment];
	    }
	      
	    return attachments;
	}
	
	```	
	
#### Localization
The Bugsplat crash dialogue can be localized and supports 8 languages out of the box.

1. English
2. Finnish
3. French
4. German
5. Italian
6. Japanese
7. Norwegian
8. Swedish

Additional languages may be supported by adding the language bundle and strings file to `BugsplatMac.framework/Versions/A/Frameworks/HockeySDK.framework/Versions/A/Resources/`

#### Command line utility support
1. Add "Other Linker Flags" build setting to embed Info.plist

	```
	-sectcreate __TEXT __info_plist "$(SRCROOT)/BugsplatTesterCLI/Info.plist"
	```

2. Add `@executable_path/` to "Runtime Search Paths" build setting
3. Follow main configuration steps listed above, however, use upload-archive-cl.sh for uploading archives
4. Initialize as follows:

	```objc
	[BugsplatStartupManager sharedManager].autoSubmitCrashReport = YES;
	[BugsplatStartupManager sharedManager].askUserDetails = NO;
	[[BugsplatStartupManager sharedManager] start];
	```
5. Given the "Runtime Search Paths" setting change in step 2, be sure any 3rd party dependencies are located in the same directory as the CLI program so they can be found at runtime.
	
## 4. Sample Application

We have provided BugsplatTester as a sample application for you to test BugSplat. There are 2 targets - an ObjC version and a Swift version. The quickest way to test BugSplat is to do the following:

1. Clone the [BugsplatMac repo](https://github.com/BugSplat-Git/BugSplatMac.git).

1. Open the BugsplatTester.xcworkspace file in Xcode. Select the scheme based on which target you want to run.  Edit the scheme and uncheck "Debug executable" in the Run section, close the scheme editor and run the application.

2. Click the "crash" button when prompted.

3. Click the run button a second time in Xcode. The BugSplat crash dialog will appear the next time the app is launched.

4. Fill out the crash dialog and submit the crash report.

5. Visit BugSplat's [Crashes](https://app.bugsplat.com/v2/crashes) page. When prompted for credentials enter user "fred@bugsplat.com" and password "Flintstone". The crash you posted from BugsplatTester should be at the top of the list of crashes.

6. Click the link in the "Crash Id" column to view more details about your crash.

7. You will notice there are no function names or line numbers, this is because you need to upload the application's xcarchive. See step 2 in the "Configuration" section above for more information.

8. Repeat this process with the executable from the xcarchive you created with BugsplatTester. To find the executable within the xcarchive, right click the xcarchive in finder and select "Show Package Contents". The executable should be located in .../Products/Applications/. BugSplat will display function names and line numbers for all crashes posted from this executable.
