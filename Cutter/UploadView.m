//
//  UploadView.m
//  Cutter
//
//  Created by Jordan Howlett on 20/03/2014.
//  Copyright (c) 2014 Jordan Howlett. All rights reserved.
//

#import "UploadView.h"

@interface UploadView ()

@end

@implementation UploadView


-(id)init {
    if (! (self = [super initWithWindowNibName:@"UploadController"])) {
        // Initialization code here.
        return nil;
    }
    return self;
}

//- (id)initWithWindow:(NSWindow *)window
//{
//    self = [super initWithWindow:window];
//    if (self) {
//        // Initialization code here.
//    }
//    return self;
//}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
