//
//  MainViewAppDelegate.m
//  Cutter
//
//  Created by Jordan Howlett on 06/03/2014.
//  Copyright (c) 2014 Jordan Howlett. All rights reserved.
//

#import "MainViewAppDelegate.h"
#import "ScreenRecorder.h"
#include <Carbon/Carbon.h>
#include "Recorder.h"
#include "UploadView.h"

#define LogRect(RECT) NSLog(@"%s: (%0.0f, %0.0f) %0.0f x %0.0f", #RECT, RECT.origin.x, RECT.origin.y, RECT.size.width, RECT.size.height)

@implementation MainViewAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{}

-(void)awakeFromNib {
    [self createCutsDesktopFolder];
    
    recording = NO;
    
    // INIT the arrays
    audioOptionsArray = [[NSArray alloc] initWithObjects:self.audioSpeaker,
                         self.audioMicrophone,
                         self.audioNone, nil];
    videoOptionsArray = [[NSArray alloc] initWithObjects:self.videoFullScreen, self.videoScreenSelection,
                         self.videoWebcam, self.videoNone,nil];
    
    
    [self setupStatusBar];
    [self bindHotKeys];
    [self initDefaults];
    
//    self.upView = [[UploadView alloc]
//                   initWithWindowNibName:@"UploadView"];
    
}



- (IBAction)quitApp:(id)sender {
       [NSApp terminate: nil];
}

- (IBAction)screenSelection:(id)sender {
    int windowLevel = CGShieldingWindowLevel();
    NSRect windowRect = [[NSScreen mainScreen] frame];
    
    DrawMouseBoxView *tempWind;
    
    //    windowRect.size.height = windowRect.size.height - 20;
    if (overlayWindow) {
        NSLog(@"OVERLAY ALREADY DEFINED");
        NSLog(@"OV: %@", overlayWindow);
        [overlayWindow makeKeyAndOrderFront:self];
        tempWind = [[DrawMouseBoxView alloc] initWithFrame:windowRect];
        tempWind.delegate = self;
        [overlayWindow setContentView:tempWind];
    } else {
    overlayWindow = [[NSWindow alloc] initWithContentRect:windowRect
                                                styleMask:NSBorderlessWindowMask
                                                  backing:NSBackingStoreBuffered
                                                    defer:NO
                                                   screen:[NSScreen mainScreen]];
    
    
    [overlayWindow setReleasedWhenClosed:YES];
    [overlayWindow setLevel:windowLevel];
    [overlayWindow setBackgroundColor:[NSColor colorWithCalibratedRed:0.0
                                                                green:0.0
                                                                 blue:0.0
                                                                alpha:0.5]];
    [overlayWindow setAlphaValue:0.5];
    [overlayWindow setOpaque:NO];
    [overlayWindow setIgnoresMouseEvents:NO];
    [overlayWindow makeKeyAndOrderFront:nil];
    
    drawMouseBoxView = [[DrawMouseBoxView alloc] initWithFrame:windowRect];
    drawMouseBoxView.delegate = self;
    [overlayWindow setContentView:drawMouseBoxView];
    }
}

#define kShadyWindowLevel   (NSDockWindowLevel + 1000)

- (void)doneDoingStuff {
//    [overlayWindow close];
    [overlayWindow orderOut:self];
//    [overlayWindow performClose:nil];
//    drawMouseBoxView = NULL;
//    overlayWindow = NULL;
//        NSLog(@"OVERLAY %@", overlayWindow);
    
//    for (NSWindow* w in [NSApp windows])
//	{
//		if ([w level] == kShadyWindowLevel)
//			[w close];
//	}
}

- (void)drawMouseBoxView:(DrawMouseBoxView*)view didSelectRect:(NSRect)rect {
    selectionRect = rect;
    LogRect(selectionRect);
}


- (IBAction)audioSpeakerSelected:(id)sender {
    currentAudio = 0;
    [self updateRecordingSelections];
}

- (IBAction)audioMicrophoneSelected:(id)sender {
    currentAudio = 1;
    [self updateRecordingSelections];
}

- (IBAction)audioNoneSelected:(id)sender {
    currentAudio = 2;
    [self updateRecordingSelections];
}

- (IBAction)videoEntireScreenSelected:(id)sender {
    currentVideo = 0;
    [self updateRecordingSelections];
}

- (IBAction)videoScreenSelectionSelected:(id)sender {
    currentVideo = 1;
    [self updateRecordingSelections];
}

- (IBAction)videoWebcamSelected:(id)sender {
    currentVideo = 2;
    [self updateRecordingSelections];
}

- (IBAction)videoNoneSelected:(id)sender {
    currentVideo = 3;
    [self updateRecordingSelections];
}

- (IBAction)popupUploadView:(id)sender {

    UploadView *view = [[UploadView alloc] initWithWindowNibName:@"UploadView"];
    [view showWindow:self];

    
//    [[myWindow window] makeMainWindow];
//    NSLog(@"OPEn");
//    if (!self.upView) {
//        self.upView = [[UploadView alloc] init];
//    }
    NSLog(@"VIEW %@", self.upView);
//    [self.upView showWindow:self];
//    [self.upView.window makeKeyAndOrderFront:self];
//    [[uploadView window] makeKeyAndOrderFront:self];
    
//    [self.window addChildWindow:uploadView ordered:NSWindowBelow];
//    [uploadView.window makeKeyAndOrderFront:self];
////    [uploadView showWindow:nil];
}

-(void)test {
    NSLog(@"test");
}


-(void)record {
    LogRect(selectionRect);
    if (currentVideo == 1) {
        recorder = [[Recorder alloc] initWithAudio:currentAudio andVideo:currentVideo andScreenRect:selectionRect];
    } else {
        recorder = [[Recorder alloc] initWithAudio:currentAudio andVideo:currentVideo andScreenRect:NSZeroRect];
    }
    [recorder record];
}

-(void)stopRecording {
    [recorder stop];
}

- (IBAction)startRecording:(id)sender {
    if (recording) {
        recording = NO;
        [self stopRecording];
    } else {
        recording = YES;
        [self record];
    }
}

- (void)resetAudioOptionMenusToStateOff {
    for (id object in audioOptionsArray) {
        [object setState:NSOffState];
    }
}

- (void)resetVideoOptionMenusToStateOff {
    for (id object in videoOptionsArray) {
        [object setState:NSOffState];
    }
}

-(void) runScript:(NSString*)name
{
//    NSTask *task;
//    task = [[NSTask alloc] init];
//    [task setLaunchPath: @"/bin/sh"];
//    
//    NSArray *arguments;
//    NSString* newpath = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] privateFrameworksPath], scriptName];
//    NSLog(@"shell script path: %@",newpath);
//    arguments = [NSArray arrayWithObjects:newpath, nil];
//    [task setArguments: arguments];
//    
//    NSPipe *pipe;
//    pipe = [NSPipe pipe];
//    [task setStandardOutput: pipe];
//    
//    NSFileHandle *file;
//    file = [pipe fileHandleForReading];
//    
//    [task launch];
//    
//    NSData *data;
//    data = [file readDataToEndOfFile];
//    
//    NSString *string;
//    string = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
//    NSLog (@"script returned:\n%@", string);

    NSString *sharedSupportPath = [[NSBundle mainBundle] resourcePath];
    NSLog(@"PATH %@", sharedSupportPath);
    NSString *scriptName = @"ffmpeg";
    NSString *scriptExtension = @"sh";
    NSString *scriptAbsPath = [NSString stringWithFormat:@"%@/%@", sharedSupportPath, scriptName];
//    NSString *bits = [NSString stringWithFormat:@"%d", mEngine->mOutputDevice.getStreamPhysicalBitDepth(false)];
    NSTask *task=[[NSTask alloc] init];
//    NSArray *argv=[NSArray arrayWithObject:bits];
    
    //    ffmpeg -i TestRecording-20140363110156.mov -i 1393956048.wav -vcodec copy out.mov
    
    
        NSString *testPath = [NSString stringWithFormat:@"%@/%@", sharedSupportPath, @"test.mov"];
            NSString *testWav = [NSString stringWithFormat:@"%@/%@", sharedSupportPath, @"test.wav"];
            NSString *testOut = @"~/Desktop/output.mov";
    testOut = [testOut stringByExpandingTildeInPath];
    NSLog(@"********************* %@", testOut);
    NSError *err = nil;
    NSString *outFile = [NSString stringWithContentsOfFile:testOut encoding:NSUTF8StringEncoding error:&err];
    NSLog(@"tESTETTEET %@", outFile);

    [task setArguments:@[@"-i", testPath, @"-i", testWav, @"-vcodec", @"copy", testOut]];
//    [task setArguments: argv];
    [task setLaunchPath:scriptAbsPath];
    [task launch];


}


-(void)createCutsDesktopFolder {
    NSString *cutsDir = @"~/Desktop/Cuts";
    cutsDir = [cutsDir stringByExpandingTildeInPath];
    BOOL isDir;
    NSFileManager *fileManager= [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:cutsDir isDirectory:&isDir])
    if(![fileManager createDirectoryAtPath:cutsDir withIntermediateDirectories:YES attributes:nil error:NULL])
    NSLog(@"Error: Create folder failed %@", cutsDir);
}

- (void)initDefaults {
    currentAudio = 0;  //Default audio = Speaker
    currentVideo = 1;  // Default video = Screen selection
    [self updateRecordingSelections];
}

- (void)updateRecordingSelections {
    [self resetAudioOptionMenusToStateOff];
    [self resetVideoOptionMenusToStateOff];
    
    [[audioOptionsArray objectAtIndex:currentAudio] setState:NSOnState];
    [[videoOptionsArray objectAtIndex:currentVideo] setState:NSOnState];

    
    //    If screen selection
    if (currentVideo == 1) {
        [self.recordToggle setHidden:YES];
        [self.selectScreen setHidden:NO];
    } else {
        [self.recordToggle setHidden:NO];
        [self.selectScreen setHidden:YES];
    }
    
    if (currentVideo == 3 && currentAudio == 2) {
        [self.recordToggle setHidden:YES];
        [self.selectScreen setHidden:YES];
    }
    
    [self updateStatusMessage];
    
}

-(void)updateStatusMessage {
    NSString *msg = @"";
    
    switch (currentAudio) {
        case 0:
            msg = [msg stringByAppendingString:@"Internal / "];
            break;
        case 1:
            msg = [msg stringByAppendingString:@"Microphone / "];
            break;
        case 2:
            msg = [msg stringByAppendingString:@"None / "];
            break;
        default:
            break;
    }
    
    switch (currentVideo) {
        case 0:
            msg = [msg stringByAppendingString:@"Full Screen"];
            break;
        case 1:
            msg = [msg stringByAppendingString:@"Screen Selection"];
            break;
        case 2:
            msg = [msg stringByAppendingString:@"Webcam"];
            break;
        case 3:
            msg = [msg stringByAppendingString:@"None"];
            break;
        default:
            break;
    }
    
    [self.currentlySelectedStatus setTitle:msg];
}

- (NSString *)getNewPath {
    NSString *cutsDir = @"~/Desktop/Cuts/test.wav";
    cutsDir = [cutsDir stringByExpandingTildeInPath];
    return cutsDir;
}

- (void)launchRecordProcess {
//    NSString *sharedSupportPath = [[NSBundle mainBundle] resourcePath];
//    NSString *scriptName = @"record";
//    NSString *scriptExtension = @"sh";
//    NSString *scriptAbsPath = [NSString stringWithFormat:@"%@/%@.%@", sharedSupportPath, scriptName, scriptExtension];
//    //NSString *bits = [NSString stringWithFormat:@"%d", mEngine->mOutputDevice.getStreamPhysicalBitDepth(false)];
//    NSTask *task=[[NSTask alloc] init];
//    //NSArray *argv=[NSArray arrayWithObject:bits];
//    //[task setArguments: argv];
//    [task setLaunchPath:scriptAbsPath];
//    [task launch];
    
    NSLog(@"KILLEM");

    NSString *sharedSupportPath = [[NSBundle mainBundle] resourcePath];
    NSString *scriptName = @"sox";
    NSString *scriptAbsPath = [NSString stringWithFormat:@"%@/%@", sharedSupportPath, scriptName];
//    //NSString *bits = [NSString stringWithFormat:@"%d", mEngine->mOutputDevice.getStreamPhysicalBitDepth(false)];
//    NSTask *task=[[NSTask alloc] init];
//    //NSArray *argv=[NSArray arrayWithObject:bits];
//    //[task setArguments: argv];
//    
////    $DIR/sox -V6 -t coreaudio 'WavTap' $bits $output_file
//    NSString *testOut = @"~/Desktop/out.wav";
//    testOut = [testOut stringByExpandingTildeInPath];
//    
//    [task setArguments:@[@"-V6", @"coreaudio", @"WavTap", testOut]];
//    [task setLaunchPath:scriptAbsPath];
//    [task launch];
    
    NSString *outputFile = [self getNewPath];

    
    NSArray *args = [NSArray arrayWithObjects:@"-V6", @"-t", @"coreaudio", @"WavTap", @"--bits", @"16", outputFile, nil];
    task = [[NSTask alloc] init];
    @try {
        [task setLaunchPath:scriptAbsPath];
        [task setArguments:args];
        [task launch];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.reason);
    }
    @finally {
//        [task release];
    }


}

-(void)setupStatusBar {
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    NSImage *image = [NSImage imageNamed:@"cutter.png"];
    [image setTemplate:YES];
    [statusItem setImage:image];
    [statusItem setToolTip:@"CUTTER"];
    [statusItem setHighlightMode:YES];
    [statusItem setMenu:statusMenu];
    //    [statusItem setTitle:@"Cutter"];
    [statusItem setHighlightMode:YES];
}

// Set up hot keys

OSStatus recordHotKeyHandler(EventHandlerCallRef nextHandler, EventRef anEvent, void *userData) {
    MainViewAppDelegate* inUserData = (__bridge MainViewAppDelegate*)userData;
    [inUserData poop];
    return noErr;
}

-(void)poop {
    NSLog(@"poop");
}


- (void)bindHotKeys {
    recordHotKeyFunction = NewEventHandlerUPP(recordHotKeyHandler);
    EventTypeSpec eventType0;
    eventType0.eventClass = kEventClassKeyboard;
    eventType0.eventKind = kEventHotKeyReleased;
    InstallApplicationEventHandler(recordHotKeyFunction, 1, &eventType0, (void *)CFBridgingRetain(self), NULL);
    EventHotKeyRef theRef0;
    EventHotKeyID keyID0;
    keyID0.signature = 'a';
    keyID0.id = 0;
    RegisterEventHotKey(49, cmdKey+controlKey, keyID0, GetApplicationEventTarget(), 0, &theRef0);
}

- (void)killRecordProcesses {
    NSLog(@"KILLLLLL THIS SHITTT");
    [task terminate];
//    NSString *sharedSupportPath = [[NSBundle mainBundle] resourcePath];
//    NSString *scriptName = @"kill_recorders";
//    NSString *scriptExtension = @"sh";
//    NSString *scriptAbsolutePath = [NSString stringWithFormat:@"%@/%@.%@", sharedSupportPath, scriptName, scriptExtension];
//    NSTask *task=[[NSTask alloc] init];
//    NSArray *argv=[NSArray arrayWithObjects:nil];
//    [task setArguments: argv];
//    [task setLaunchPath:scriptAbsolutePath];
//    [task launch];
}

@end
