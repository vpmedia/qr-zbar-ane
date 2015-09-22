/*
 * =BEGIN MIT LICENSE
 * 
 * The MIT License (MIT)
 *
 * Copyright (c) 2013 Saumitra Bhave
 * Copyright (c) 2014 Andras Csizmadia
 * http://www.vpmedia.hu
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 * 
 * =END MIT LICENSE
 *
 */
#import "CallZBar.h"
#import "QROverlay.h"

@implementation CallZBar

@synthesize reader;
@synthesize isRunning;

- (id)initWithFREContext:(FREContext*)ctx {
    self = [super init];
    if (self) {
        context = *ctx;
        [self resetZBarController];
        doOnce = NO;
    }
    return self;
}

-(void) resetZBarController
{
    if(reader != nil)
    {
        [reader release];
        reader = nil;
    }
    
    reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMask(UIInterfaceOrientationPortrait);
    reader.showsZBarControls = YES;
    QROverlay* overlay = [[QROverlay alloc] initWithFrame:CGRectMake(0, 0, reader.view.bounds.size.width, reader.view.bounds.size.height)];
        reader.cameraOverlayView = overlay;
    [overlay setContentMode:UIViewContentModeRedraw];
    [overlay release];
    isRunning = NO;
    singleScan =YES;
}

- (void) scanWithMode:(uint32_t)mode andCamera:(NSString *)cameraPosition;
{
    NSLog(@"call scan With Mode %u",mode);
    UIButton* scanButton = nil;
    //[[[[[[UIApplication sharedApplication] windows] objectAtIndex:0] rootViewController] view] addSubview:[self view]];
    singleScan = mode;
    isRunning = YES;
    
    if ([cameraPosition isEqualToString:@"front"] && [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
        reader.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }else{
        reader.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
    
    id delegate = [[UIApplication sharedApplication] delegate];
    [[[delegate window] rootViewController] presentModalViewController:reader animated:YES];
    
    QROverlay* o = (QROverlay*)reader.cameraOverlayView;
    o.captured = NO;
    [o setNeedsDisplay];
    
    if(!doOnce)
    {
        
        UIView* holder = [[[reader.view.subviews objectAtIndex:2] subviews] objectAtIndex:0];
         NSLog(@"3");
        
        UIView* btn = [[[[[reader.view.subviews objectAtIndex:2] subviews] objectAtIndex:0] subviews] objectAtIndex:3];
        if(btn != nil)
            [btn removeFromSuperview];
        
        scanButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [scanButton setTitle:@"Scan" forState:UIControlStateNormal];
        [scanButton setFrame:CGRectMake(holder.frame.size.width-80, 12, 70, 30)];
        [scanButton setHidden:YES];
        [scanButton addTarget:self
                       action:@selector(rescan:)
         forControlEvents:UIControlEventTouchDown];
        
        NSLog(@"DONE: Adding button for multiscan and hiding it");
        //[[[[[reader.view.subviews objectAtIndex:1] subviews] objectAtIndex:0] subviews] objectAtIndex:2];
        [[[[reader.view.subviews objectAtIndex:2] subviews] objectAtIndex:0] insertSubview:scanButton atIndex:3];
        
        
        //NSLog(@"Adding button for multiscan and hiding it");
      
        //UIView * infoButton = [[[[[reader.view.subviews objectAtIndex:2] subviews] objectAtIndex:0] subviews] objectAtIndex:3];
        //if(infoButton != nil)
        //    [infoButton removeFromSuperview];
        //[infoButton setHidden:YES];
        NSLog(@"2");
        
        doOnce = YES;
    }
}

-(void) rescan:(id)btn
{
    NSLog(@"Rescanning");
    QROverlay* o = (QROverlay*)reader.cameraOverlayView;
    o.captured = NO;
    [o setNeedsDisplay];
    [btn setHidden:YES];
    [reader.readerView start];
}

- (void) imagePickerController: (UIImagePickerController*) reader2
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    NSLog(@"Barcode scanned event");
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
    {
        NSLog(@"Found: %@",[symbol data]);
        NSString *event_name = @"data";
        FREDispatchStatusEventAsync(context, (uint8_t*)[event_name UTF8String], (uint8_t*)[[symbol data] UTF8String]);
    }
    
    QROverlay* o = (QROverlay*)reader.cameraOverlayView;
    o.captured = YES;
    [o setNeedsDisplay];
    
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    if(singleScan){
        [reader2 dismissModalViewControllerAnimated: YES];
        doOnce = NO;
        isRunning = NO;
    }else{
        NSLog(@"In Multiscan. Pausing and enabling button");
        UIView* btn = [[[[[reader.view.subviews objectAtIndex:2] subviews] objectAtIndex:0] subviews] objectAtIndex:3];  
        [btn setHidden:NO];
        [reader.readerView stop];
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)reader
{
    NSLog(@"Scanner Dismissed");
    isRunning = NO;
    doOnce = NO;
    [reader dismissModalViewControllerAnimated: YES];
}

- (void) cancelScan:(FREContext *)ctx
{
    NSLog(@"JAMES RANCON Cancel Scan");
    if(isRunning){
        [reader dismissModalViewControllerAnimated: YES];
        isRunning = NO;
    }
}

-(void)dealloc {
    [reader release];
    [super dealloc];
}

@end
