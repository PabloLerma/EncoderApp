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
}

@property (assign) IBOutlet NSWindow *window;
@property (retain, atomic) IBOutlet NSTextField *url;
@property (retain, atomic) IBOutlet NSTextField *shorturl;
@property (retain, atomic) IBOutlet NSImageView *imageview;


-(IBAction)encode:(id)sender;
-(IBAction)shorturl:(id)sender;
-(IBAction)saveimage:(id)sender;

@end
