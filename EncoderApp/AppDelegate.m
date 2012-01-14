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
@synthesize url,shorturl,imageview,receivedData,myView;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    //[_window setBackgroundColor:[NSColor lightGrayColor]];
    NSImage *background = [[NSImage alloc] initByReferencingFile:[[NSBundle mainBundle] pathForImageResource:@"background.png"]];
    [myView lockFocus];
    [background drawInRect:NSMakeRect(0, 0, 500, 435) fromRect:NSMakeRect(0, 0, 500, 435) operation:NSCompositeCopy fraction:1.0];
    [myView unlockFocus];
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
    
    //NSString *path = [[NSBundle mainBundle] pathForImageResource:@"template"];
    //NSString *prueba = @"This is a text";
    //NSImage *newimg = [[NSImage alloc] initWithContentsOfFile:path] ;
        
    //get the size of the image
    NSSize imageSize = NSMakeSize(640.0, 250.0);
    
    
    CGColorSpaceRef colorSpace;
    colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    CGFloat pixelsWidth = imageSize.width;
    CGFloat pixelsHigh = imageSize.height;
    
    bitmapBytesPerRow   = (pixelsWidth * 4);// 1
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    void *          bitmapData;
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        fprintf (stderr, "Memory not allocated!");
    }
    CGContextRef newcontext = CGBitmapContextCreate (bitmapData,// 4
                                                      pixelsWidth,
                                                      pixelsHigh,
                                                      8,      // bits per component
                                                      bitmapBytesPerRow,
                                                      colorSpace,
                                                      kCGImageAlphaNoneSkipLast);
    
    if (newcontext== NULL)
    {
        free (bitmapData);// 5
        fprintf (stderr, "Context not created!");
    }
    
    // Anti-aliasing
    CGContextSetAllowsAntialiasing(newcontext, TRUE);
    
    CGColorSpaceRelease( colorSpace );
    
    //CGContextSetTextMatrix(newcontext, CGAffineTransformIdentity);  // 2
    //CGContextTranslateCTM(newcontext, 0, pixelsHigh);  // 3
    //CGContextScaleCTM(newcontext, 1.0, -1.0);
    
    CGContextSetGrayFillColor(newcontext, 1.0, 1.0);
    CGContextFillRect(newcontext, CGRectMake (0, 0, pixelsWidth, pixelsHigh ));

    
    // Prepare font
    CTFontRef font = CTFontCreateWithName(CFSTR("LucidaSansUnicode"), 16, NULL);
    
    // Create Path
    CGMutablePathRef gpath = CGPathCreateMutable(); //5
    CGPathAddRect(gpath, NULL, CGRectMake(10, 0, pixelsWidth, pixelsHigh)); // 6
    
    //CGContextSetCharacterSpacing (newcontext, 10); // 4
    CGContextSetTextDrawingMode (newcontext, kCGTextFill); 
    CGContextSetGrayFillColor(newcontext, 0.0, 1.0);

    // Create an attributed string
    CFStringRef keys[] = { kCTFontAttributeName };
    CFTypeRef values[] = { font };
    CFDictionaryRef attr = CFDictionaryCreate(NULL, (const void **)&keys, (const void **)&values,
                                              sizeof(keys) / sizeof(keys[0]), &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFAttributedStringRef attrString = CFAttributedStringCreate(NULL, CFSTR("◣◤◢◤◣◢◥◤\n◢◣◥◤◢◣◢◥\n◢◤◣◢◥◤◤◣\n◣◥◢◣◤◥◢◣\n◢◤◤◣◢◣◢◥\n◣◥◥◢◣◢◤◣"), attr);
    NSLog(@"lalal: %@",attrString);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrString); // 7
    //CFIndex start = 0;
    //CFIndex count = CTTypesetterSuggestLineBreak(framesetter, start, 8.0);
    CTFrameRef theFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, CFAttributedStringGetLength(attrString)), gpath, NULL); // 8
    
    //◣◤◢◤◣◢◥◤◢◣◥◤◢◣◢◥◢◤◣◢◥◤◤◣◣◥◢◣◤◥◢◣◢◤◤◣◢◣◢◥◣◥◥◢◣◢◤◣
    //Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus.
    /* Testing test
    ◣◤◢◤◣◢◥◤
    ◢◣◥◤◢◣◢◥
    ◢◤◣◢◥◤◤◣
    ◣◥◢◣◤◥◢◣
    ◢◤◤◣◢◣◢◥
    ◣◥◥◢◣◢◤◣
     */
    
    

    //CTLineRef line = CTLineCreateWithAttributedString(attrString);
    //CGContextSetTextMatrix(newcontext, CGAffineTransformIdentity);  //Use this one when using standard view coordinates
    //CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0, -1.0)); //Use this one if the view's coordinates are flipped
    
    
    
    // Draw the string
    CTFrameDraw(theFrame, newcontext);
    
    // Clean up... CFRelease...
    CFRelease(framesetter); //9
    CFRelease(gpath); //10
    CFRelease(theFrame); //12
    CFRelease(attr);
    //CFRelease(line);
    CFRelease(attrString);
    CFRelease(font);
    
    
    
    
     //CGContextSelectFont (newcontext, // 3
     //                    "ArialUnicodeMS",
      //                   15,
      //                   kCGEncodingFontSpecific);
               
    //CGContextShowTextAtPoint (newcontext, 10, 180, "abcd◣◥◥◤◢◤◤◣", 8); 
    //CGContextShowTextAtPoint (newcontext, 10, 100, "◥", 1);
    
    CGImageRef myImage = CGBitmapContextCreateImage (newcontext);
    
    //NSSize imageViewSize = [imageview intrinsicContentSize];
    CGImageRef cropImage = CGImageCreateWithImageInRect(myImage, CGRectMake(0, 0, 115, 152));
    NSSize imagePreviewSize = NSMakeSize(200, 200);
    NSImage *codePreview = [[NSImage alloc] initWithCGImage:cropImage size:imagePreviewSize];
    [imageview setImage:codePreview];
    
    NSBitmapImageRep *myrep = [[NSBitmapImageRep alloc] initWithCGImage:myImage];
    
    NSData *tiffData = [myrep TIFFRepresentation];
    NSError *error = nil;

    [tiffData writeToFile:@"/Users/Paul/test.tif" options:NSDataWritingAtomic error:&error];

    //CGContextDrawImage(myContext, myBoundingBox, myImage);
    char *newbitmapData = CGBitmapContextGetData(newcontext);
    CGContextRelease (newcontext);
    if (newbitmapData) free(newbitmapData);
    CGImageRelease(myImage);
}

-(IBAction)saveimage:(id)sender
{
        [imageview setImage:nil];
}

@end
