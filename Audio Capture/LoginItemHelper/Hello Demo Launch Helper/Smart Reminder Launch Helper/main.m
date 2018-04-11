//
//  main.m
//  Smart Reminder Launch Helper
//
//  Created by Satendra Dagar on 21/09/15.
//  Copyright (c) 2015 CoreBits Software Solutions Pvt. Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>

int main(int argc, const char * argv[]) {
    
    @autoreleasepool {
        NSArray *pathComponents = [[[NSBundle mainBundle] bundlePath] pathComponents];
        pathComponents = [pathComponents subarrayWithRange:NSMakeRange(0, [pathComponents count] - 4)];
        NSMutableArray *mutablePaths = [pathComponents mutableCopy];
        [mutablePaths addObject:@"MacOS"];
        [mutablePaths addObject:@"Hello Demo"];
        NSString *path = [NSString pathWithComponents:pathComponents];
        NSLog(@"Launch app at path: %@",path);
        [[NSWorkspace sharedWorkspace] launchApplication:path];
        [NSApp terminate:nil];
    }
    return NSApplicationMain(argc, argv);
}
