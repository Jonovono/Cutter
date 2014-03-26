//
//  UploadView.h
//  Cutter
//
//  Created by Jordan Howlett on 20/03/2014.
//  Copyright (c) 2014 Jordan Howlett. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface UploadView : NSWindowController
- (IBAction)upload:(id)sender;
@property (weak) IBOutlet NSTextField *clipTitle;
@property (weak) IBOutlet NSTextField *clipDescription;

@property (weak) IBOutlet NSTextField *clipMovie;


@property (weak) IBOutlet NSTextField *clipTVShow;
@property (weak) IBOutlet NSTextField *clipSeason;
@property (weak) IBOutlet NSTextField *clipEpisode;



@property (weak) IBOutlet NSTabView *tabBarType;

@end


