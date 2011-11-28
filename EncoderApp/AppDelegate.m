//
//  AppDelegate.m
//  EncoderApp
//
//  Created by Yo on 26/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize url,shorturl,imageview,receivedData;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [_window setBackgroundColor:[NSColor lightGrayColor]];
}

-(IBAction)shorturl:(id)sender
{
    NSString *stringurl = [url stringValue];
    if ([stringurl length] == 0){
        [shorturl setStringValue:@"It is not valid a empty URL"];
    }
    else {
        if ([stringurl hasPrefix:@"http://"]){
            NSString *prefix = @"http://is.gd/create.php?format=simple&url=";
            NSString *web = [NSString stringWithFormat:@"%@%@", prefix, stringurl];
            NSData *htmlFile = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:web]];
            NSString *htmlString = [[NSString alloc] initWithData:htmlFile encoding:NSUTF8StringEncoding];
            [shorturl setStringValue:htmlString];
        }
        else {
            [shorturl setStringValue:@"URL need start with \"http://\""];
        }
        
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // release the connection, and the data object
    //[connection release];
    // receivedData is declared as a method instance elsewhere
   // [receivedData release];
    
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"Succeeded! Received %@ bytes of data",[receivedData length]);
    
    // release the connection, and the data object
    //[connection release];
    //[receivedData release];
}

-(IBAction)encode:(id)sender
{
    NSString *prueba = @"This is a text";
    NSImage *newimg = [[NSImage alloc] initWithSize:NSMakeSize(100, 100)] ;
    [newimg setBackgroundColor:[NSColor whiteColor]];
    [newimg lockFocus];
    [prueba drawAtPoint:NSMakePoint(10, 10) withAttributes:nil];
    [newimg unlockFocus];
    [imageview setImage:newimg];
    NSError *error = nil;
    NSData *datos = [newimg TIFFRepresentation];
    [datos writeToFile:@"/Users/Paul/test.tif" options:NSDataWritingAtomic error:&error];
}

-(IBAction)saveimage:(id)sender
{
        [imageview setImage:nil];
}

@end
