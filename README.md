
# Readme 
## Introduction
This booking room project is written in Swift 5 using XCode 11.2.1 and tested on iPhone simulator 11 and iPhone (iOS 13). It follows the user story given in (https://gist.github.com/yuhong90/7ff8d4ebad6f759fcc10cc6abdda85cf) and try to be as similar to the mockup.


## Build Instruction
**Using Xcode**
Open in Xcode 11.2.1 or higher or higher. As this project is created using Xcode 11.2.1, it might required to resolve project setting from higher version of Xcode.
Command B to build the project, Command R to run the project in iPhone Simulator, Command U to run the test in Simulator 
As the project contains Camera feature, a real iPhone device is needed, switch the device in Xcode and Command R to run the project in the device.

**Using Xcodebuild**
Open terminal and execute the below code to build 

With code signing
 ```
 xcodebuild clean build -project BookRoom.xcodeproj
```

Without code signing
```
 xcodebuild clean build  CODE_SIGNING_REQUIRED=NO CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED="NO" CODE_SIGN_ENTITLEMENTS="" CODE_SIGNING_ALLOWED="NO"
 ```
 
Run test (using iPhone 11 simulator as example)
```
xcodebuild test -scheme BookRoom CODE_SIGNING_REQUIRED=NO CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED="NO" CODE_SIGN_ENTITLEMENTS="" CODE_SIGNING_ALLOWED="NO"  -destination "name=iPhone 11"
```
## Application Test
Automation test is only done for Room List scene to test the functionality
- tapping of the buttons 
- choosing the date pickers
- revealing of the table view
- choosing the sort selection
- revealing the drawer
- room class whether it can read the json data correctly

Manual test on the device to test if it can read the QR code and navigate to the web view

## Design
It contains of mainly 4 View Controllers and 1 Table View Cell that are attached to the storyboard. 
There is a Room class to deserialize as object from the json data and CodeReader to read the QR code type
There are Addon UI classes to construct Radio button and Underline Textfield

### RoomListViewController.swift
- The controller class that is attached to Book A Room Scene in Storyboard
It is to display the room listing based on the date and time selected and the sort field selected

### QrCameraViewController
- The controller class that is attached to Read QR Scene in Storyboard
It is to display the camera and able to read the QR Code 
It will go to Book Successfully Scene when it read the QR code

### SortFieldsViewController
-  The controller class that is attached to Sort fields view controller Scene in Storyboard 
It is to display the sort fields (Capacity, Location and Availability) when press the Sort button in the Room Listing

### BookSuccessViewController
- The controller class that is attached to Book Successfully Scene in Storyboard
It is to display a web view (that show successfully booked) and go back to the Room Listing scene
It will be triggered by Qr Camera controller

### RoomCell
-  The table cell class that is attached to table in Book A Room scene in Storyboard
It is store the level, name, capacity and availability label
