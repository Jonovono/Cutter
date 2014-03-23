
/*
 File: DrawMouseBoxView.m
 Abstract: Dims the screen and allows user to select a rectangle with a cross-hairs cursor
 Version: 2.0
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2012 Apple Inc. All Rights Reserved.
 
 */

#import "DrawMouseBoxView.h"
#import "ScreenRecorder.h"

#define LogRect(RECT) NSLog(@"%s: (%0.0f, %0.0f) %0.0f x %0.0f", #RECT, RECT.origin.x, RECT.origin.y, RECT.size.width, RECT.size.height)


@implementation DrawMouseBoxView
{
	NSPoint _mouseDownPoint;
	NSRect _selectionRect;
    BOOL recording;
    ScreenRecorder *recorder;
    CGRect globalRect;
    NSWindow *controlWindow;
    BOOL selectionSet;
    NSButton *selectionSetRecordButton;
    NSView *closeView;
}


- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent
{
	return YES;
}

- (BOOL)acceptsFirstResponder
{
	return YES;
}

- (void)mouseDown:(NSEvent *)theEvent
{
    if (controlWindow) {
//        [controlWindow close];
        [selectionSetRecordButton setHidden:YES];
    }
	_mouseDownPoint = [theEvent locationInWindow];
}


- (void)mouseUp:(NSEvent *)theEvent
{
    
    int buttonWidth = 150;
    int buttonHeight = 25;
    recording = NO;
    
	NSPoint mouseUpPoint = [theEvent locationInWindow];
	NSRect selectionRect = NSMakeRect(
                                      MIN(_mouseDownPoint.x, mouseUpPoint.x),
                                      MIN(_mouseDownPoint.y, mouseUpPoint.y),
                                      MAX(_mouseDownPoint.x, mouseUpPoint.x) - MIN(_mouseDownPoint.x, mouseUpPoint.x),
                                      MAX(_mouseDownPoint.y, mouseUpPoint.y) - MIN(_mouseDownPoint.y, mouseUpPoint.y));
    
    globalRect = selectionRect;
    [self.delegate drawMouseBoxView:self didSelectRect:selectionRect];
    
     int x = selectionRect.origin.x;
    int y = selectionRect.origin.y;
    int width = selectionRect.size.width;
    int height = selectionRect.size.height;
    int xCenter = (x + (width + x))/2;
    int yCenter = (y + (height + y)) / 2;
    int bottom = y - 30;
    
    xCenter = xCenter - (buttonWidth / 2);
    yCenter = yCenter - (buttonHeight / 2);
    
    NSRect frame = NSMakeRect(0, 0, buttonWidth, buttonHeight);
    selectionSetRecordButton = [[NSButton alloc] initWithFrame: frame];
    selectionSetRecordButton.bezelStyle = NSRoundedBezelStyle;
    [selectionSetRecordButton setTitle:@"Set Selection"];
//
    int wl = CGShieldingWindowLevel();
    NSRect wr = [[NSScreen mainScreen] frame];
    wr.size.height = buttonHeight;
    wr.size.width = buttonWidth;
    wr.origin.x = xCenter;
//    wr.origin.y = yCenter;   THIS WILL POSITION IN THE MIDDLE BUT THEN IT GETS IN THE WAY OF THE CAMERA (workaroun?)
    wr.origin.y = bottom;
//    //    windowRect.size.height = windowRect.size.height - 20;
    
    controlWindow = [[NSWindow alloc] initWithContentRect:wr
                                               styleMask:NSBorderlessWindowMask
                                                 backing:NSBackingStoreBuffered
                                                   defer:NO
                                                  screen:[NSScreen mainScreen]];
//
//    
    [controlWindow setReleasedWhenClosed:YES];
    [controlWindow setLevel:wl];
    [controlWindow setBackgroundColor:[NSColor colorWithCalibratedRed:0.0
                                                     green:1.0
                                                      blue:1.0
                                                     alpha:0.0]];
    [controlWindow setAlphaValue:1.0];
    [controlWindow setOpaque:NO];
    [controlWindow setIgnoresMouseEvents:NO];
    [controlWindow makeKeyAndOrderFront:nil];
    [controlWindow.contentView addSubview:selectionSetRecordButton];
    
    [selectionSetRecordButton setTarget:self];
    [selectionSetRecordButton setAction:@selector(selectionSetRecordButtonPressed)];
}

-(void)selectionSetRecordButtonPressed {
    NSString *title = [selectionSetRecordButton title];
    
    if ([title isEqualToString:@"Set Selection"]) {
        selectionSet = YES;
        [selectionSetRecordButton setTitle:@"Start Recording"];
        [self makeOverlayClickThrough];
    } else if ([title isEqualToString:@"Start Recording"]) {
        recording = true;
        [selectionSetRecordButton setTitle:@"Stop Recording"];
        [self.delegate record];
    } else if ([title isEqualToString:@"Stop Recording"]) {
        recording = false;
        [selectionSetRecordButton setTitle:@"Close"];
        [self.delegate stopRecording];
         NSWindow *win =  [self window];
    } else if ([title isEqualToString:@"Close"]) {
        [self closeOverlay];
    }

//    [self setNeedsDisplayInRect:globalRect];

//    if (!recorder) {
//        recorder = [[ScreenRecorder alloc] initWithRect: globalRect];
//    }
    
//    if (recording) {
//        NSLog(@"Stop recording");
//         [recorder stop];
//        recording = NO;
//    } else {
//        NSLog(@"Begin recording");
//        recording = YES;
//        [recorder start];
//    }
    
    //Do what You want here...
}

-(void)closeOverlay {
//    NSWindow *win =  [self window];
//    [win.contentView views]
//    [win close];
    [self makeOverlayNotClickThrough];
        [self.delegate doneDoingStuff];
    [controlWindow close];
}

-(void)makeOverlayClickThrough {
    NSWindow *win =  [self window];
    [win setIgnoresMouseEvents:YES];
}

-(void)makeOverlayNotClickThrough {
    NSWindow *win =  [self window];
    [win setIgnoresMouseEvents:NO];
}

- (void)mouseDragged:(NSEvent *)theEvent
{
	NSPoint curPoint = [theEvent locationInWindow];
	NSRect previousSelectionRect = _selectionRect;
	_selectionRect = NSMakeRect(
                                MIN(_mouseDownPoint.x, curPoint.x),
                                MIN(_mouseDownPoint.y, curPoint.y),
                                MAX(_mouseDownPoint.x, curPoint.x) - MIN(_mouseDownPoint.x, curPoint.x),
                                MAX(_mouseDownPoint.y, curPoint.y) - MIN(_mouseDownPoint.y, curPoint.y));
	[self setNeedsDisplayInRect:NSUnionRect(_selectionRect, previousSelectionRect)];

}

- (void)drawRect:(NSRect)dirtyRect
{
     	[[NSColor blackColor] set];
        NSRectFill(dirtyRect);
        [[NSColor clearColor] set];
        NSRectFill(_selectionRect);
//        LogRect(_selectionRect);
}

@end



//    int x = 600; //possition x
//    int y = 100; //possition y
//
//    int width = 130;
//    int height = 40;

//    NSButton *myButton = [[[NSButton alloc] initWithFrame:NSMakeRect(x, y, width, height)] autorelease];
//      NSButton *myButton = [[[NSButton alloc] initWithFrame:NSMakeRect(x, y, width, height)] autorelease];
//    [[self.window contentView] addSubview: myButton];
//    [myButton setStringValue:@"TEST"];
//    [myButton setDrawsBackground:NO];
//    [myButton setTextColor:[NSColor blackColor]];
//    [myButton setBackgroundColor:[NSColor blackColor]];

//    [myButton setButtonType:NSMomentaryLightButton]; //Set what type button You want
//    [myButton setBezelStyle:NSRoundedBezelStyle]; //Set what style You want

//    NSColor *color = [NSColor greenColor];
//    NSMutableAttributedString *colorTitle =
//    [[NSMutableAttributedString alloc] initWithAttributedString:[myButton attributedTitle]];
//
//    NSRange titleRange = NSMakeRange(0, [colorTitle length]);
//
//    [colorTitle addAttribute:NSForegroundColorAttributeName
//                       value:color
//                       range:titleRange];


//    [myButton setTarget:self];
//    [myButton setAction:@selector(buttonPressed)];


//    NSView *view = [[NSView alloc] initWithFrame:NSMakeRect(100, 100, 100, 100)];
//    [view setWantsLayer:YES];
//    view.layer.backgroundColor = [[NSColor blackColor] CGColor];
//
//    [self.window.contentView addSubview:view];
//
//    NSRect frame = NSMakeRect(10, 40, 90, 40);
//    NSButton* pushButton = [[NSButton alloc] initWithFrame: frame];
//    pushButton.bezelStyle = NSRoundedBezelStyle;
//
//    [self.window.contentView addSubview:pushButton];