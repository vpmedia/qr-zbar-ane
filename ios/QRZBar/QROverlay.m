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
#import "QROverlay.h"

@implementation QROverlay
@synthesize targetSize;
@synthesize successColor;
@synthesize normalColor;
@synthesize captured;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.autoresizesSubviews=YES;
        self.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        self.backgroundColor = [UIColor clearColor];
        self.targetSize = 100;
        self.successColor = [UIColor colorWithRed:0.0 green:255.0 blue:0.0 alpha:1.0];
        self.normalColor = [UIColor colorWithRed:255.0 green:0.0 blue:0.0 alpha:1.0];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGFloat lineSize= 15;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if(!self.captured){
        NSLog(@"Color:%@",self.normalColor);
        CGContextSetStrokeColorWithColor(context, self.normalColor.CGColor);
    }
    else{
        NSLog(@"Color:%@",self.successColor);
        CGContextSetStrokeColorWithColor(context, self.successColor.CGColor);
    }
    CGContextSetLineWidth(context, 2.0);
    
    CGFloat centerX = self.bounds.size.width/2;
    CGFloat centerY = self.bounds.size.height/2;
    
    //Top-Left
    CGContextMoveToPoint(context, centerX-targetSize/2,centerY-targetSize/2);
    CGContextAddLineToPoint(context ,centerX-targetSize/2 + lineSize, centerY-targetSize/2);
    CGContextMoveToPoint(context, centerX-targetSize/2,centerY-targetSize/2);
    CGContextAddLineToPoint(context ,centerX-targetSize/2, centerY-targetSize/2 + lineSize);
    
    //Top-Right
    CGContextMoveToPoint(context, centerX+targetSize/2,centerY-targetSize/2);
    CGContextAddLineToPoint(context ,centerX+targetSize/2 - lineSize, centerY-targetSize/2);
    CGContextMoveToPoint(context, centerX+targetSize/2,centerY-targetSize/2);
    CGContextAddLineToPoint(context ,centerX+targetSize/2, centerY-targetSize/2 + lineSize);
    
    
    //Bottom-Left
    CGContextMoveToPoint(context, centerX-targetSize/2,centerY+targetSize/2);
    CGContextAddLineToPoint(context ,centerX-targetSize/2 + lineSize, centerY+targetSize/2);
    CGContextMoveToPoint(context, centerX-targetSize/2,centerY+targetSize/2);
    CGContextAddLineToPoint(context ,centerX-targetSize/2, centerY+targetSize/2 - lineSize);
    
    //Bottom-Right
    CGContextMoveToPoint(context, centerX+targetSize/2,centerY+targetSize/2);
    CGContextAddLineToPoint(context ,centerX+targetSize/2 - lineSize, centerY+targetSize/2);
    CGContextMoveToPoint(context, centerX+targetSize/2,centerY+targetSize/2);
    CGContextAddLineToPoint(context ,centerX+targetSize/2, centerY+targetSize/2 - lineSize);
    // and now draw the Path!
    CGContextStrokePath(context);
}


@end
