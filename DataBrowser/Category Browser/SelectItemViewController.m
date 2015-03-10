//
//  SelectItemViewController.m
//
//  Created by Armin Kroll on 28/02/2015.
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

#import "SelectItemViewController.h"
#import "DataBrowserUtil.h"

@interface SelectItemViewController ()
@end

@implementation SelectItemViewController

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    NSIndexPath *indexPath = self.selectedIndexPath;
    
    // Send back the index and value of the selected item
    {
        NSMutableDictionary *dictionary = [self dictonaryForIndexPath:indexPath];
        NSString *entry = [dictionary objectForKey:@"Title"];
        [self.delegate didSelectValue:entry selectedIndex:indexPath.row indexPath:self.delegateIndexPath];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"Cell";
    
    NSMutableDictionary *dictionary = [self dictonaryForIndexPath:indexPath];
    
    NSInteger cellStyle = UITableViewCellStyleDefault;
    if ([dictionary objectForKey:@"cellStyle"]) {
        cellIdentifier = [dictionary objectForKey:@"cellStyle"];
        cellStyle = [DataBrowserUtil cellStyleForString:cellIdentifier];
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:cellStyle reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Configure the cell...
    cell.textLabel.text = [dictionary objectForKey:@"Title"];
    if (cell.accessoryType == UITableViewCellStyleValue1) {
        cell.detailTextLabel.text = [dictionary objectForKey:@"Value"];
    }
    
    // accessory
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        // if the current cell is the selected on then use the configured accessory
        if ([dictionary objectForKey:@"accesoryType"] && self.selectedIndexPath == indexPath) {
            cell.accessoryType = [DataBrowserUtil accesoryTypeForString:[dictionary objectForKey:@"accesoryType"]];
        }
    }
    
    // we don't want a selection style. The checkbox will do.
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // label
    if ([dictionary objectForKey:@"Label"]) {
        cell.textLabel.text = [dictionary objectForKey:@"Label"];
    }
    // test alignment
    if ([dictionary objectForKey:@"textAlingment"]) {
        cell.textLabel.textAlignment = [DataBrowserUtil textAlingmentForString:[dictionary objectForKey:@"textAlingment"]];
    }
    
    return cell;
}



#pragma mark -
#pragma mark Table view delegate

#define TEXT_LABEL 10

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"index path is %ld, %ld", (long)indexPath.section, (long)indexPath.row);
    

    self.selectedIndexPath = indexPath;
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [tableView reloadData];
}

@end
