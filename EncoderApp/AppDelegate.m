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
    
    NSString *path = [[NSBundle mainBundle] pathForImageResource:@"template"];
    NSString *prueba = @"This is a text";
    //NSImage *newimg = [[NSImage alloc] initWithContentsOfFile:path] ;
        
    //get the size of the image
    NSSize imageSize = NSMakeSize(200, 200);
    
    //create a non-alpha RGB image rep with the same dimensions as the image
    NSBitmapImageRep* bitmap = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL pixelsWide:imageSize.width pixelsHigh:imageSize.height bitsPerSample:8 samplesPerPixel:3 hasAlpha:NO isPlanar:NO colorSpaceName:NSCalibratedRGBColorSpace bitmapFormat:NSAlphaNonpremultipliedBitmapFormat bytesPerRow:0 bitsPerPixel:32];
    
    //save the current context
   // NSGraphicsContext* previousContext = [NSGraphicsContext currentContext];
    
   // [NSGraphicsContext saveGraphicsState];
    //lock focus on the bitmap
    NSGraphicsContext *context = [NSGraphicsContext graphicsContextWithBitmapImageRep:bitmap];
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:context];
    
    //draw the image into the bitmap
    [prueba drawAtPoint:NSMakePoint(0, 0) withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSFont systemFontOfSize:24], NSFontAttributeName, nil]];
    /*
    [newimg drawInRect:NSMakeRect(0, 0 , imageSize.width, imageSize.height)  
                fromRect:NSZeroRect
               operation:NSCompositeCopy
                fraction:1.0
          respectFlipped:YES
                   hints:nil];
    */
    //restore the previous context
   // [NSGraphicsContext restoreGraphicsState];
    //[NSGraphicsContext setCurrentContext:previousContext];
    [NSGraphicsContext restoreGraphicsState];
    
    //get the TIFF data
    NSData* tiffData = [bitmap TIFFRepresentation];
    
    //do something with TIFF data

    NSError *error = nil;
    [tiffData writeToFile:@"/Users/Paul/test.tif" options:NSDataWritingAtomic error:&error];
    
    /*NSBitmapImageRep *rep = [[newimg representations] objectAtIndex: 0];
    NSSize size = NSMakeSize ([rep pixelsWide], [rep pixelsHigh]);
    [rep setAlpha:false];
    [rep setBitsPerSample:300];
    [rep drawAtPoint:NSMakePoint(0, 160)];
    */
    /*
     [newimg setBackgroundColor:[NSColor redColor]];
    [newimg lockFocus];
    [[NSColor redColor] set];
    */
     /*
     [[[NSImage alloc] initWithContentsOfFile:path] compositeToPoint:NSZeroPoint operation:NSCompositeCopy];
     */
    /*
    [prueba drawAtPoint:NSMakePoint(0, 0) withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSFont systemFontOfSize:24], NSFontAttributeName, nil]];
    [[NSColor redColor] set];
    [newimg unlockFocus];
    [imageview setImage:newimg];
    NSData *data;
    data = [newimg TIFFRepresentation];
    NSError *error = nil;
    [data writeToFile:@"/Users/Paul/test.tif" options:NSDataWritingAtomic error:&error];
    */
    
    /*
    NSString *prueba = @"This is a text";
    NSImageRep *blabla = [[NSImageRep alloc] init];
    [blabla setAlpha:false];
    [blabla setSize:NSMakeSize(200, 200)];
    [blabla setBitsPerSample:300];
    NSImage *newimg = [[NSImage alloc] initWithSize:NSMakeSize(200, 200)] ;
    [newimg addRepresentation:blabla];
    [newimg lockFocus];
    [[NSColor whiteColor] set];
    [prueba drawAtPoint:NSMakePoint(0, 160) withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSFont systemFontOfSize:24], NSFontAttributeName, nil]];
    [newimg unlockFocus];
    [imageview setImage:newimg];
    NSBitmapImageRep *rep = [[newimg representations] objectAtIndex: 0];
    [rep setAlpha:false];
    [rep setBitsPerSample:300];
    NSError *error = nil;
    NSData *datos = [newimg TIFFRepresentation];
    [datos writeToFile:@"/Users/Paul/test.tif" options:NSDataWritingAtomic error:&error];
     */
    
    /*
    NSString *path = [[NSBundle mainBundle] pathForImageResource:@"template"];
    NSImage *newimg = [[NSImage alloc] initWithContentsOfFile:path] ;
    NSBitmapImageRep *rep = [[newimg representations] objectAtIndex: 0];
     */
}

-(IBAction)saveimage:(id)sender
{
        [imageview setImage:nil];
}

@end
