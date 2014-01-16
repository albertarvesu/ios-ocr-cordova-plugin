//
//  OCRPlugin.m
//  pruebaTesseract
//
//  Created by Admin on 09/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OCRPlugin.h"
#import "claseAuxiliar.h"
#import <Cordova/CDVPluginResult.h>

@implementation OCRPlugin
@synthesize callbackID;


- (void)recogniseOCR:(CDVInvokedUrlCommand*)command
    {

        NSArray *arguments = command.arguments;
        NSDictionary *options = [arguments objectAtIndex:0];
        
        NSString *url_string = [options objectForKey:@"url_imagen"];
        
        claseAuxiliar *cA = [[claseAuxiliar alloc]init];
        
        self.callbackID = command.callbackId;
        
        NSURL *url = [NSURL URLWithString:url_string];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *Realimage = [[UIImage alloc] initWithData:data];
        
        UIImage *newImage = [cA resizeImage:Realimage];
        NSString *text = [cA ocrImage:newImage];
        
        [self performSelectorOnMainThread:@selector(ocrProcessingFinished:)
                               withObject:text
                            waitUntilDone:NO];
    
    }



- (void)ocrProcessingFinished:(NSString *)result
{
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
 
    result = [result stringByReplacingOccurrencesOfString:@"\n" withString:@" "];

    if (result == nil
        || ([result respondsToSelector:@selector(length)]
            && [(NSData *)result length] == 0)
        || ([result respondsToSelector:@selector(count)]
            && [(NSArray *)result count] == 0))
        
    {
        [self writeJavascript: [pluginResult toErrorCallbackString:self.callbackID]];
        
                
    } else
        
    {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:result];
        javaScript = [pluginResult toSuccessCallbackString:self.callbackID];

        [self writeJavascript:javaScript];
    }
}

@end
