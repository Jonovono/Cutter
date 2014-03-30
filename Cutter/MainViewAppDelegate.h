//
//  MainViewAppDelegate.h
//  Cutter
//
//  Created by Jordan Howlett on 06/03/2014.
// GPL
//

#import <Cocoa/Cocoa.h>
#import "DrawMouseBoxView.h"
#import <QTKit/QTKit.h>
#import <Carbon/Carbon.h>
#import "Recorder.h"
#import "UploadView.h"

//@class UploadView;

@interface MainViewAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
    IBOutlet NSMenu *statusMenu;
    NSStatusItem *statusItem;
    
    NSArray *audioOptionsArray;
    NSArray *videoOptionsArray;
    BOOL *recording;
    NSTask *task;
    NSWindow *overlayWindow;
    DrawMouseBoxView* drawMouseBoxView;
    
    IBOutlet NSPanel *theSheet;
    
    UploadView *uploadView;
    
    NSRect selectionRect;
    
    
    EventHandlerUPP recordHotKeyFunction;
    
    // 0 = speaker, 1 = microphone, 2 = none
    int currentAudio;
    
    // 0 = fullscreen, 1 = selection, 2 = webcam, 3 = none.
    int currentVideo;
    
    Recorder *recorder;
}

// Menu properties

//Used to inform what is currently selected.
@property (weak) IBOutlet NSMenuItem *currentlySelectedStatus;

@property (strong) UploadView *upView;



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
- (IBAction)startRecording:(id)sender;


- (IBAction)videoNoneSelected:(id)sender;

- (IBAction)popupUploadView:(id)sender;

@property (assign) IBOutlet NSWindow *window;
@end
