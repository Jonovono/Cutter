//
//  MainViewAppDelegate.m
//  Cutter
//
//  Created by Jordan Howlett on 06/03/2014.
//  Copyright (c) 2014 Jordan Howlett. All rights reserved.
//

#import "MainViewAppDelegate.h"

@implementation MainViewAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
//    NSLog(@"LOAAAAAAAAAAAAAAAAAAAAAAAAd");
//    // Insert code here to initialize your application
//    audioOptionsArray = [[NSArray alloc] initWithObjects:self.audioSpeaker,
//                                  self.audioMicrophone,
//                                  self.audioNone, nil];
//    NSLog(@"AUD %@", audioOptionsArray);
    
}

-(void)awakeFromNib {
    [self createCutsDesktopFolder];
    recording = NO;
    
//    [self runScript:@"ps"];
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:statusMenu];
    [statusItem setTitle:@"Cutter"];
    [statusItem setHighlightMode:YES];
    
    // Insert code here to initialize your application
    audioOptionsArray = [[NSArray alloc] initWithObjects:self.audioSpeaker,
                         self.audioMicrophone,
                         self.audioNone, nil];
}


- (IBAction)quitApp:(id)sender {
       [NSApp terminate: nil];
}

- (IBAction)screenSelection:(id)sender {
}

- (IBAction)audioSpeakerSelected:(id)sender {
    [self resetAudioOptionMenusToStateOff];
    [sender setState: NSOnState];
}

- (IBAction)audioMicrophoneSelected:(id)sender {
    [self resetAudioOptionMenusToStateOff];
    [sender setState: NSOnState];
}

- (IBAction)audioNoneSelected:(id)sender {
    [self resetAudioOptionMenusToStateOff];
    [sender setState: NSOnState];
}

- (IBAction)startRecording:(id)sender {
    if (recording) {
        NSLog(@"RECORDING STOP");
        recording = NO;
        [self killRecordProcesses];

    } else {
        NSLog(@"NOT RECORDING, start it");
        recording = YES;
        [self launchRecordProcess];
    }
//    AppController *ac = [[AppController alloc] init];
}

- (void)resetAudioOptionMenusToStateOff {
    for (id object in audioOptionsArray) {
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

- (void)launchRecordProcess {
    NSString *sharedSupportPath = [[NSBundle mainBundle] resourcePath];
    NSString *scriptName = @"record";
    NSString *scriptExtension = @"sh";
    NSString *scriptAbsPath = [NSString stringWithFormat:@"%@/%@.%@", sharedSupportPath, scriptName, scriptExtension];
    //NSString *bits = [NSString stringWithFormat:@"%d", mEngine->mOutputDevice.getStreamPhysicalBitDepth(false)];
    NSTask *task=[[NSTask alloc] init];
    //NSArray *argv=[NSArray arrayWithObject:bits];
    //[task setArguments: argv];
    [task setLaunchPath:scriptAbsPath];
    [task launch];
}

- (void)killRecordProcesses {
    NSString *sharedSupportPath = [[NSBundle mainBundle] resourcePath];
    NSString *scriptName = @"kill_recorders";
    NSString *scriptExtension = @"sh";
    NSString *scriptAbsolutePath = [NSString stringWithFormat:@"%@/%@.%@", sharedSupportPath, scriptName, scriptExtension];
    NSTask *task=[[NSTask alloc] init];
    NSArray *argv=[NSArray arrayWithObjects:nil];
    [task setArguments: argv];
    [task setLaunchPath:scriptAbsolutePath];
    [task launch];
}

@end
