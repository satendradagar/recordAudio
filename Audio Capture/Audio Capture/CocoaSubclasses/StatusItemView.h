//
//  StatusItemView.h
//  Hello Demo
//
//  Created by Satendra Dagar on 15/03/18.
//  Copyright © 2018 CB. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface StatusItemView : NSView
{
    NSStatusItem *statusItem;
    NSString *title;
    BOOL isMenuVisible;
}
@property (retain, nonatomic) NSStatusItem *statusItem;
@property (retain, nonatomic) NSString *title;

@end
