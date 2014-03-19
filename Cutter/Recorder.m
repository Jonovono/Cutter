//
//  Recorder.m
//  Cutter
//
//  Created by Jordan Howlett on 18/03/2014.
//  Copyright (c) 2014 Jordan Howlett. All rights reserved.
//

#import "Recorder.h"

#define LogRect(RECT) NSLog(@"%s: (%0.0f, %0.0f) %0.0f x %0.0f", #RECT, RECT.origin.x, RECT.origin.y, RECT.size.width, RECT.size.height)

@implementation Recorder

-(id)init {
    NSArray *audioDevices = [[NSArray alloc] initWithArray:[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio]];
    AVCaptureDevice *wavTapDevice;
//
//    
    for (AVCaptureDevice * dev in audioDevices) {
        NSString *name = [dev localizedName];
        if ([name isEqualToString:@"WavTap"]) {
            wavTapDevice = dev;
        }
    }
//
//    NSLog(@"DEVICE %@", wavTapDevice);
    
    
    return self;
}


-(id)initWithAudio:(int)audio andVideo:(int)video andScreenRect:(NSRect)rect{
    NSLog(@"GOING TO INIT THIS");
    LogRect(rect);
    BOOL success;
    NSError* error;
    
    session = [[AVCaptureSession alloc] init];
    [session beginConfiguration];
    
    movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    [session addOutput:movieFileOutput];

    
    switch (audio) {
        // Speaker
        case 0:
            NSLog(@"init with speaker");
            audioDevices = [[NSArray alloc] initWithArray:[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio]];
            for (AVCaptureDevice * dev in audioDevices) {
                NSString *name = [dev localizedName];
                if ([name isEqualToString:@"WavTap"]) {
                    audioDevice = dev;
                }
            }
            break;
        
        // Microphone
        case 1:
            NSLog(@"INIT WITH MIC");
            audioDevice  = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
            break;
        case 2:
            audioDevice = nil;
            break;
        default:
            audioDevice = nil;
            break;
    }
    
    switch (video) {
        // fullscreen
        case 0:
            screenDevice = [[AVCaptureScreenInput alloc] initWithDisplayID:CGMainDisplayID()];
            screenDevice.capturesMouseClicks = YES;
            videoDevice = nil;
            break;
        // Screen selection
        case 1:
            screenDevice = [[AVCaptureScreenInput alloc] initWithDisplayID:CGMainDisplayID()];
            screenDevice.capturesMouseClicks = NO;
            screenDevice.cropRect = rect;
            videoDevice = nil;
            break;
        // Webcam
        case 2:
            screenDevice = nil;
            videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
            break;
        // None
        case 3:
            screenDevice = nil;
            videoDevice = nil;
            break;
            
        default:
            screenDevice = nil;
            videoDevice = nil;
            break;
    }
    
    if (audioDevice) {
        audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
        [session addInput:audioDeviceInput];
    }
    
    if (videoDevice) {
        videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
        [session addInput:videoDeviceInput];
    }
    
    if (screenDevice) {
        NSLog(@"ADDING SCREEN DEVICE");
        [session addInput:screenDevice];
    }
    
    //    For screen selection
    //    mCaptureScreenInput = [[NSClassFromString(@"QTCaptureScreenInput") alloc] init];
    //    success = [session addInput:mCaptureScreenInput error:&error];
    
    
//    audioDevice = [AVCaptureDevice defaultInputDeviceWithMediaType:QTMediaTypeSound];
//    [audioDevice open];
    //    //
//    audioDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioDevice];
//    [session addInput:audioDeviceInput];
    //    //    NSLog(@"ERROR %@", [error localizedDescription]);
    //    //    NSLog(@"DEVICE %@", audioDevice);
    
    
    [session commitConfiguration];
    [session startRunning];
    return self;
}

-(void)stop {
    [session stopRunning];
    
}

-(void)record {
    NSLog(@"IN QT ABOUT TO RECORD");
    NSString *testOut = @"~/Desktop/greee.mov";
    testOut = [testOut stringByExpandingTildeInPath];
    [movieFileOutput startRecordingToOutputFileURL:[NSURL fileURLWithPath:testOut] recordingDelegate:self];
}

@end
