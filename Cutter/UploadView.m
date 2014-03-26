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
    if (! (self = [super initWithWindowNibName:@"UploadView"])) {
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


- (IBAction)upload:(id)sender {
    
    
    NSString *title = self.clipTitle.stringValue;
    NSString *description = self.clipDescription.stringValue;
    
    NSString *type = self.tabBarType.selectedTabViewItem.label;
    
    NSString *movie = self.clipMovie.stringValue;
    NSString *tvShow = self.clipTVShow.stringValue;
    NSString *season = self.clipSeason.stringValue;
    NSString *episode = self.clipEpisode.stringValue;
    
    NSLog(@"Some values: %@, %@, %@, %@, %@, %@", title, description, movie, tvShow, season, episode);
//
//    
    NSString *testOut = @"~/Desktop/Cuts/small.mov";
    testOut = [testOut stringByExpandingTildeInPath];
    NSLog(@"PATH %@", testOut);
    
    NSString *args = @"term_in=201320&poop=test";
    
    NSString *dat = [[NSString alloc] initWithFormat:@"title=%@&description=%@&type=%@&movie=%@&tvshow=%@&season=%@&episode=%@", title, description, type, movie, tvShow, season, episode];
    NSLog(@"data %@", dat);
    
    
    
    //    TRYING TO POST
    NSLog(@"COMEON");
    NSString *urlString = @"http://localhost:3000/upload";
    NSString *filename = @"small.mov";
    NSData *data = [[NSData alloc] initWithContentsOfFile:testOut];
    NSMutableURLRequest *request= [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    NSMutableData *postbody = [NSMutableData data];

    
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",@"data"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:dat] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n", filename] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[NSData dataWithData:data]];
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postbody];
    
    NSLog(@"REQUEST %@", [request description]);
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"GOT HERE %@", returnString);
}
@end
