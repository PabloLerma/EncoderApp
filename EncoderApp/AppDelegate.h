//
//  AppDelegate.h
//  EncoderApp
//
//  Created by Yo on 26/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    IBOutlet NSTextField *url;
    IBOutlet NSTextField *shorturl;
    IBOutlet NSImageView *imageview;
    NSMutableData *receivedData;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSView *myView;
@property (retain, nonatomic) IBOutlet NSTextField *url;
@property (retain, nonatomic) IBOutlet NSTextField *shorturl;
@property (retain, nonatomic) IBOutlet NSImageView *imageview;
@property (retain, nonatomic)  NSMutableData *receivedData;


-(IBAction)encode:(id)sender;
-(IBAction)shorturl:(id)sender;
-(IBAction)saveimage:(id)sender;
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end
