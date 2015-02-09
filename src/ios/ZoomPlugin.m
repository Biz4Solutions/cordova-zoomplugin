//
//  zoom.m
//  zoomplugin
//
//  Created by Biz4Solutions on 04/02/15.
//
//

#import <Foundation/Foundation.h>
#import <ZoomSDK/ZoomSDK.h>
#import "ZoomPlugin.h"

#define zoomSDKAppKey      @"client_keu"  //client key. replace with your client key
#define zoomSDKAppSecret   @"client_secret"  //client secret. replace with client secret
#define zoomSDKDomain      @"zoom.us" //zoom domain, such as "zoom.us"



@implementation ZoomPlugin



-(void) pluginInitialize {
    
    [[ZoomSDK sharedSDK] setZoomDomain:zoomSDKDomain];
    ZoomSDKAuthService *authService = [[ZoomSDK sharedSDK] getAuthService];
    
    if (authService)
    {
        authService.delegate = self;
        
        authService.clientKey = zoomSDKAppKey;
        authService.clientSecret = zoomSDKAppSecret;
        
        [authService sdkAuth];
    }

}

- (void) joinMeeting :(CDVInvokedUrlCommand*)command {
    //store the command argument because it is referenced in
    //other events to send back result
    self.command = command;
    
    CDVPluginResult* pluginResult = nil;
    
    NSString* meetingNumber = [command.arguments objectAtIndex:0];
    NSString* userDisplayName = [command.arguments objectAtIndex:1];
    
    self.zoomWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.zoomWindow.backgroundColor = [UIColor clearColor];
    
    
    UINavigationController *navController = [[UINavigationController alloc] init];
    [navController setNavigationBarHidden:YES];
   
    self.zoomWindow.rootViewController = navController;
    self.zoomWindow.windowLevel = UIWindowLevelStatusBar;
    self.zoomWindow.hidden = NO;
    
    [navController setNavigationBarHidden:YES];
    [[ZoomSDK sharedSDK] setZoomRootController:navController];
    
    ZoomSDKMeetingService *ms = [[ZoomSDK sharedSDK] getMeetingService];
    
    if (ms)
    {
        ms.delegate = self;
        
        ZoomSDKMeetError ret = [ms joinMeeting:meetingNumber displayName:userDisplayName];
        
        NSLog(@"onJoinaMeeting ret:%d", ret);
    }
    else{
        //return error
        // Check command.arguments here.
        [self.commandDelegate runInBackground:^{
            NSString* payload = @"Unable to instantiate Zoom meeting service";
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:payload];
            // The sendPluginResult method is thread-safe.
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
    }
}

//simple look up for meeting error codes
- (NSString*)returnErrorDescription:(ZoomSDKMeetError)zoomError {
    NSString *result = nil;
    
    switch(zoomError) {
        case ZoomSDKMeetError_IncorrectMeetingNumber:
            result = @"Incorrect meeting no";
            break;
        case ZoomSDKMeetError_InvalidArguments:
            result = @"Invalid arguments";
            break;
        case ZoomSDKMeetError_MeetingClientIncompatible:
            result = @"Incompatible client";
            break;
        case ZoomSDKMeetError_MeetingNotExist:
            result = @"Meeting does not exist";
            break;
        case ZoomSDKMeetError_MeetingLocked:
            result = @"Meeting locked";
            break;
        case ZoomSDKMeetError_MeetingOver:
            result = @"Meeting over";
            break;
        case ZoomSDKMeetError_MeetingTimeout:
            result = @"Connection timed out";
            break;
        case ZoomSDKMeetError_NetworkUnavailable:
            result = @"Network not available";
            break;
        case ZoomSDKMeetError_MeetingRestricted:
            result = @"Meeting restricted";
            break;
        case ZoomSDKMeetError_MeetingJBHRestricted:
            result = @"Meeting restricted";
            break;
        default:
            result = @"Unknown error";
    }
    
    return result;
}

//simple look up for auth error codes

- (NSString*)returnAuthErrorDescription:(ZoomSDKAuthError)authError {
    NSString *result = nil;
    
    switch(authError) {
        case ZoomSDKAuthError_AccountNotEnableSDK:
            result = @"Account not enabled for mobile SDK";
            break;
        case ZoomSDKAuthError_AccountNotSupport:
            result = @"Account not supported";
            break;
        case ZoomSDKAuthError_KeyOrSecretEmpty:
            result = @"Empty auth key or auth secret";
            break;
        case ZoomSDKAuthError_KeyOrSecretWrong:
            result = @"Incorrect auth key or auth secret";
            break;
        default:
            result = @"Unknown error";
    }
    
    return result;
}



#pragma mark - Meeting Service Delegate

- (void)onMeetingReturn:(ZoomSDKMeetError)error internalError:(NSInteger)internalError
{
    //NSLog(@"========= onMeetingReturn =================:%d, internalError:%d", error, internalError);
    if (error != ZoomSDKMeetError_Success)
    {
        [self.commandDelegate runInBackground:^{
            NSString* payload = [self returnErrorDescription: error];
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:payload];
            // The sendPluginResult method is thread-safe.
            [self.commandDelegate sendPluginResult:pluginResult callbackId:self.command.callbackId];
        }];
    }
}

- (void)onMeetingStateChange:(ZoomSDKMeetingState)state
{

    //NSLog(@"++++++++++++++ onMeetingStateChange +++++++++++++++++++:%d", state);
    
}



#pragma mark - Auth Delegate

- (void)onZoomSDKAuthReturn:(ZoomSDKAuthError)returnValue
{
    NSLog(@"onZoomSDKAuthReturn %d", returnValue);
    
    if (returnValue !=ZoomSDKAuthError_Success){
        [self.commandDelegate runInBackground:^{
            NSString* payload = [self returnAuthErrorDescription: returnValue];
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:payload];
            // The sendPluginResult method is thread-safe.
            [self.commandDelegate sendPluginResult:pluginResult callbackId:self.command.callbackId];
        }];
    }
    
    
}


@end