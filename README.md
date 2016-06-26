## Introduction

The BugsplatMac OS X framework enables posting crash reports from Cocoa applications to Bugsplat. Visit http://www.bugsplat.com to sign up. 

## 1. Requirements

1. BugsplatMac supports OS X 10.7 and later.
2. BugsplatMac supports x86_64 applications only.

## 2. Integration

BugsplatMac supports multiple methods for installing the library in a project.

### Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like BugsplatMac in your projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

#### Podfile

To integrate AFNetworking into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
target 'TargetName' do
pod 'BugsplatMac'
end
```

Then, run the following command:

```bash
$ pod install
```

### Installation with Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate BugsplatMac into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "BugsplatGit/BugsplatMac"
```

Run `carthage` to build the framework and drag the built `BugsplatMac.framework` into your Xcode project.

### Manual

To use this library in your project manually you may:  

1. Download the latest release from https://github.com/BugSplatGit/BugsplatMac/releases which is provided as a zip file
2. Unzip the archive Add BugsplatMac.framework to your Xcode project
3. Drag & drop `BugsplatMac.framework` from your window in the `Finder` into your project in Xcode and move it to the desired location in the `Project Navigator`
4. A popup will appear. Select `Create groups for any added folders` and set the checkmark for your target. Then click `Finish`.
5. Configure the framework to be copied into your app bundle:
- Click on your project in the `Project Navigator` (⌘+1).
- Click your target in the project editor.
- Click on the `Build Phases` tab.
- Click the `Add Build Phase` button at the bottom and choose `Add Copy Files`.
- Click the disclosure triangle next to the new build phase.
- Choose `Frameworks` from the Destination list.
- Drag `BugsplatMac` from the Project Navigator left sidebar to the list in the new Copy Files phase.

## Usage

####Configuration

BugsplatMac requires a few configuration steps in order integrate the framework with your Bugsplat account

1. Add the following key to your app's Info.plist replacing DATABASE_NAME with your account name

```
<key>BugsplatServerURL</key>
<string>https://DATABASE_NAME.bugsplatsoftware.com/</string>
```

2. You must upload an xcarchive containing your app's binary and symbols to the Bugsplat server in order to symbolicate crash reports.  
    1. Create a ~/.bugsplat.conf file to store your Bugsplat credentials
    ```
    BUGSPLAT_USER=<username>
    BUGSPLAT_PASS=<password>
    ```    
    2. Add the upload-archive.sh script located in Bugsplat.framework/Versions/A/Resources as an Archive post-action in your build scheme. The script will be invoked when archiving completes which will upload the xcarchive to Bugsplat for processing.  You can view the script output in `/tmp/bugsplat-upload.log`


####Initialization
```objc
@import BugsplatMac;
```
```objc
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[BugsplatStartupManager sharedManager] start];
}
```
