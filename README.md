# cordova-zoomplugin
Apache Cordova Plugin for Zoom Video conferencing


The plugin allows a phone gap application to launch zoom meeting directly from the application without having to install zoom mobile application on the device.

Currently Implemented functions:

1. Join Meeting: This is the only function implemented till now. Requires meeting number and user display name as parameters

Pre-requisites

1. A valid account on Zoom (http://zoom.us) is required, account should have access to zoom mobile sdk. Free account may not have this access. 

2. Zoom SDK and Dropbox SDK (required by Zoom SDK) for iOS are not bundled. They will have to be added. 

3. All other dependencies (check sample project included with zoom mobile sdk) will also have to be added to the project. Current list is:

     a. libstdc++6.0.9.dylib
     b. libz1.2.5.dylib
     c. libsqlite3.dyblib
     d. CorGraphics.framework
     e. UIKit.framework
     f. Foundation.framework



 Know Issues:

 Photo Sharing does not work. Plugin crashes. It does not work in sample application provided by zoom though.
