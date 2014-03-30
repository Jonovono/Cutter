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
    
    NSString *theFile = [self getLastCreatedVideo];
    
    NSString *dat = [[NSString alloc] initWithFormat:@"title=%@&description=%@&type=%@&movie=%@&tvshow=%@&season=%@&episode=%@", title, description, type, movie, tvShow, season, episode];
    
    
    //    TRYING TO POST
    NSString *urlString = @"http://cuts.io/upload";
    NSString *filename = @"small.mov";
    NSData *data = [[NSData alloc] initWithContentsOfFile:theFile];
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
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"GOT HERE %@", returnString);
}

-(NSString *)getLastCreatedVideo {
    
    NSString *cutsDir = @"~/Desktop/Cuts/";
    cutsDir = [cutsDir stringByExpandingTildeInPath];
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    NSURL *url = [[NSURL alloc] initWithString:cutsDir];
    
    
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:url
                                                              includingPropertiesForKeys:@[NSURLContentModificationDateKey]
                                                                                 options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                                   error:nil];
    
    NSArray *sortedContent = [directoryContent sortedArrayUsingComparator:
                              ^(NSURL *file1, NSURL *file2)
                              {
                                  // compare
                                  NSDate *file1Date;
                                  [file1 getResourceValue:&file1Date forKey:NSURLContentModificationDateKey error:nil];
                                  
                                  NSDate *file2Date;
                                  [file2 getResourceValue:&file2Date forKey:NSURLContentModificationDateKey error:nil];
                                  
                                  // Ascending:
                                  return [file1Date compare: file2Date];
                                  // Descending:
                                  //return [file2Date compare: file1Date];
                              }];
    NSLog(@"DATA %@", sortedContent);
    
    NSString *current = [sortedContent objectAtIndex:[sortedContent count]-1];
    NSLog(@"LAST %@", current);
    return current;
}

@end
