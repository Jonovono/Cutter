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
    // Insert code here to initialize your application
    audioOptionsArray = [[NSArray alloc] initWithObjects:self.audioSpeaker,
                                  self.audioMicrophone,
                                  self.audioNone, nil];
    
}

-(void)awakeFromNib {
    NSLog(@"HUHUH");
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:statusMenu];
    [statusItem setTitle:@"Clipper"];
    [statusItem setHighlightMode:YES];
}

- (void) quitApp {
    NSLog(@"quit");
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

- (void)resetAudioOptionMenusToStateOff {
    for (id object in audioOptionsArray) {
        [object setState:NSOffState];
    }
}
@end
