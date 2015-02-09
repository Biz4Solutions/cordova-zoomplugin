//
//  zoom.h
//  zoomplugin
//
//  Created by Biz4Solutions on 04/02/15.
//
//

#ifndef zoomplugin_zoom_h
#define zoomplugin_zoom_h


#endif

#import <Cordova/CDV.h>

@interface ZoomPlugin : CDVPlugin <ZoomSDKAuthDelegate, ZoomSDKMeetingServiceDelegate>
    @property (strong, nonatomic) UIWindow *zoomWindow;
    @property (strong, nonatomic) CDVInvokedUrlCommand *command;

    - (void)joinMeeting:(CDVInvokedUrlCommand*)command;
    - (NSString*)returnErrorDescription:(ZoomSDKMeetError)zoomError;
    - (NSString*)returnAuthErrorDescription:(ZoomSDKAuthError)authError;

@end