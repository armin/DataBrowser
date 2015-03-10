//
//  Common.m
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

#import "DataBrowserUtil.h"


@implementation DataBrowserUtil

+ (NSInteger) cellStyleForString:(NSString*)cellStyle
{
    if ( [cellStyle isEqualToString:@"UITableViewCellStyleValue1"] ) 
        return UITableViewCellStyleValue1;
    if ( [cellStyle isEqualToString:@"UITableViewCellStyleValue2"] ) 
        return UITableViewCellStyleValue2;
    if ( [cellStyle isEqualToString:@"UITableViewCellStyleSubtitle"] ) 
        return UITableViewCellStyleSubtitle;   
    
    return UITableViewCellStyleDefault;
}

+ (NSInteger) accesoryTypeForString:(NSString*)accesoryType
{
    if ( [accesoryType isEqualToString:@"UITableViewCellAccessoryDisclosureIndicator"] ) 
        return UITableViewCellAccessoryDisclosureIndicator;
    if ( [accesoryType isEqualToString:@"UITableViewCellAccessoryDetailDisclosureButton"] ) 
        return UITableViewCellAccessoryDetailDisclosureButton;
    if ( [accesoryType isEqualToString:@"UITableViewCellAccessoryCheckmark"] ) 
        return UITableViewCellAccessoryCheckmark;   
    
    return UITableViewCellAccessoryNone;
}

+ (NSInteger) textAlingmentForString:(NSString*)textAlingment
{
    if ( [textAlingment isEqualToString:@"UITextAlignmentCenter"] ) 
        return NSTextAlignmentCenter;
    if ( [textAlingment isEqualToString:@"UITextAlignmentRight"] ) 
        return NSTextAlignmentRight;
    
    return NSTextAlignmentLeft;
}

+ (void)addFormBackgroundForView:(UIView *)theView andTableView:(UITableView *) myTableView {
	myTableView.backgroundColor = [UIColor clearColor];
	myTableView.opaque = YES;
	myTableView.alpha = 1.0;
	
	theView.backgroundColor = BG_COLOR;
	UIImageView *foo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"form_bg.png"]];
	[foo setContentMode:UIViewContentModeBottom];
	[theView addSubview:foo];
	[theView sendSubviewToBack:foo];
	[foo setFrame:CGRectMake(0, 0, 320, 367)];
}


+ (UITableViewCell *)makeTextCell:(NSString *)text{
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:text];
	cell.textLabel.text = text;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

+ (UITableViewCell *)makeTextCellWithText:(NSString *)text andAccessory:(UITableViewCellAccessoryType)accessory{
	UITableViewCell *cell = [DataBrowserUtil makeTextCell:text];
	cell.accessoryType = accessory;
    return cell;
}


// load a view form a nib file (nib file must only have one view in it) then gives it to the owner
+ (UIView *)loadRemoteControllNibFileWithName:(NSString *)nibName owner:(id)owner
{
    NSArray*    topLevelObjs = nil;
	
	NSLog(@"WILL use an this nib name to load remote nib file to load: %@", nibName);
	
    topLevelObjs = [[NSBundle mainBundle] loadNibNamed:nibName owner:owner options:nil];
    if (topLevelObjs == nil) {
        NSLog(@"Error! Could not load myNib file.\n");
        return nil;
    }
    return [topLevelObjs objectAtIndex:0];
}

+ (NSString *) friendlySinceDate:(NSDate *)sinceDate {
	NSTimeInterval since = [sinceDate timeIntervalSinceNow] * -1;
	if ( since < 60 )			return @"Less than a minute ago";
	if ( since < (60 *60) )		return @"Less than an hour ago";
	if ( since < (60 *60 * 24) )return @"Less than a day ago";
	if ( since < (60 *60 * 24 *5 ) )return @"Less than a week ago";
	
	return @"More than a week ago";
}

@end
