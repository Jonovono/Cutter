//
//  Recorder.h
//  Cutter
//
//  Created by Jordan Howlett on 18/03/2014.
//  Copyright (c) 2014 Jordan Howlett. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface Recorder : NSObject {
    
    
    AVCaptureDeviceInput		*videoDeviceInput;
	AVCaptureDeviceInput		*audioDeviceInput;
    AVCaptureInput *mCaptureScreenInput;
    AVCaptureMovieFileOutput	*movieFileOutput;
    AVCaptureSession			*session;

    AVCaptureScreenInput* screenDevice;
    AVCaptureDevice *audioDevice;
    AVCaptureDevice *videoDevice;
    
    NSArray *audioDevices;
}

-(void)record;
-(void)stop;
-(id)initWithAudio:(int)audio andVideo:(int)video;
-(id)initWithAudio:(int)audio andVideo:(int)video andScreenRect:(NSRect)rect;
@end
