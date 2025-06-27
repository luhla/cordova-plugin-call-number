#import <Cordova/CDVPlugin.h>
#import "CFCallNumber.h"

@implementation CFCallNumber

- (void) callNumber:(CDVInvokedUrlCommand*)command {

    [self.commandDelegate runInBackground:^{

        CDVPluginResult* pluginResult = nil;
        NSString* number = [command.arguments objectAtIndex:0];
        number = [number stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        if( ! [number hasPrefix:@"tel:"]){
            number =  [NSString stringWithFormat:@"tel:%@", number];
        }

        if(![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:number]]) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"NoFeatureCallSupported"];
            // return result
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        else {
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:number] options:@{} completionHandler:^(BOOL success) {
                    CDVPluginResult* result;
                    if (success) {
                        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                    } else {
                        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"CouldNotCallPhoneNumber"];
                    }
                    // return result
                    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
                }];
            } else {
                // Fallback on earlier versions
                if([[UIApplication sharedApplication] openURL:[NSURL URLWithString:number]]) {
                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                } else {
                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"CouldNotCallPhoneNumber"];
                }
                // return result
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        }

    }];
}

@end
