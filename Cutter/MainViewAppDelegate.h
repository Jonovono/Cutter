//
//  MainViewAppDelegate.h
//  Cutter
//
//  Created by Jordan Howlett on 06/03/2014.
//  Copyright (c) 2014 Jordan Howlett. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MainViewAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
    IBOutlet NSMenu *statusMenu;
    NSStatusItem *statusItem;
    
    NSArray *audioOptionsArray;
}

// Menu properties

@property (weak) IBOutlet NSMenuItem *quitAppMenuButton;
@property (weak) IBOutlet NSMenuItem *audioSpeaker;
@property (weak) IBOutlet NSMenuItem *audioMicrophone;
@property (weak) IBOutlet NSMenuItem *audioNone;

@property (weak) IBOutlet NSMenuItem *videoFullScreen;
@property (weak) IBOutlet NSMenuItem *videoScreenSelection;
@property (weak) IBOutlet NSMenuItem *videoWebcam;
@property (weak) IBOutlet NSMenuItem *videoNone;

@property (weak) IBOutlet NSMenuItem *selectScreen;
@property (weak) IBOutlet NSMenuItem *recordToggle;


// Menu button actions
- (IBAction)quitApp:(id)sender;
- (IBAction)screenSelection:(id)sender;

// Audio actions
- (IBAction)audioSpeakerSelected:(id)sender;
- (IBAction)audioMicrophoneSelected:(id)sender;
- (IBAction)audioNoneSelected:(id)sender;



@property (assign) IBOutlet NSWindow *window;
@end
