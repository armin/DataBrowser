//
//  Common.h
//  
//
//  Created by Armin Kroll on 3/09/09.
//  Copyright 2010 JTRIBE HOLDINGS PTY LTD. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// define the common color (e.g. the nice Zendesk green)
#define NAVBAR_COLOR  [UIColor colorWithRed:(127/255.0) green:(147/255.0) blue:(173/255.0) alpha:1.0]
#define BG_COLOR      [UIColor colorWithRed:(202/255.0) green:(208/255.0) blue:(214/255.0) alpha:1.0]
#define COMMON_COLOR  [UIColor colorWithRed:0.988 green:0.988 blue:0.929 alpha:1.0]
#define SECTION_COLOR [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0]
#define GREY_COLOR    [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0]

#define SECTION_HEADER_HEIGHT   30

#define FAKE_NAME @"John So"



@interface DataBrowserUtil : NSObject {
}


+ (NSInteger) cellStyleForString:(NSString*)cellStyle;
+ (NSInteger) accesoryTypeForString:(NSString*)accesoryType;
+ (NSInteger) textAlingmentForString:(NSString*)textAlingment;
+ (void)addFormBackgroundForView:(UIView *)theView andTableView:(UITableView *)myTableView;
+ (UITableViewCell *)makeTextCell:(NSString *)text;
+ (UITableViewCell *)makeTextCellWithText:(NSString *)text andAccessory:(UITableViewCellAccessoryType)accessory;
+ (UIView *)loadRemoteControllNibFileWithName:(NSString *)nibName owner:(id)owner;
+ (NSString *) friendlySinceDate:(NSDate *)sinceDate;

@end