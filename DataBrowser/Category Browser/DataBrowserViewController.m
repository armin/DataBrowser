//
//  BrowseViewController.m
//
//  Created by Armin Kroll on 24/02/10.
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

#import "DataBrowserViewController.h"
#import "SelectItemViewController.h"
#import "DataBrowserUtil.h"
#import "NSDictionary+Access.h"

#define DEFAULT_DATA_FILE_NAME @"DataBrowser.plist"

@implementation DataBrowserViewController

- (id) loadDetailsViewControllerWithIdentifier:(NSString*)identifier
{
    UIViewController *controller = nil;
    @try {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DetailViewControllers" bundle:nil];
        controller = [storyboard instantiateViewControllerWithIdentifier:identifier];
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    @finally {
        NSLog(@"finally");
        return controller;
    }
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];

	[DataBrowserUtil addFormBackgroundForView:self.view andTableView:self.myTableView];
	self.navigationController.navigationBar.tintColor = NAVBAR_COLOR; 
	
	if (self.currentLevel == 0) {
		//Initialize our table data source
		NSArray *tempArray = [[NSArray alloc] init];
		self.tableDataSource = tempArray;
		
		// load Data
        {
            NSString *path = [[NSBundle mainBundle] bundlePath];
            // if no file name was set use default
            if (!self.configFileName) self.configFileName = DEFAULT_DATA_FILE_NAME;
            NSString *dataPath = [path stringByAppendingPathComponent:self.configFileName];		
            self.data = [[NSMutableDictionary alloc] initWithContentsOfFile:dataPath];
        }
		
        // configure controller
        {
            self.tableDataSource = [self.data objectForKey:@"Children"];
            self.sections = [self.data objectForKey:@"Sections"];
            //self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"heading.png"]];
            self.navigationItem.title =[self.data objectForKey:@"Title"];
        }
        
       // The cancel button on left side of navigation bar
        if (self.modal) {
            UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
                                                                                    target:self 
                                                                                    action:@selector(cancelButtonPressed:)];
            self.navigationItem.leftBarButtonItem = button;
        }
    }
	else {
		self.navigationItem.title = self.currentTitle;
	}
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;


}

-(void)viewDidAppear: (BOOL)animated{
	[super viewDidAppear:animated];
	NSIndexPath *indexPath = [self.myTableView indexPathForSelectedRow];
	// fading effect for selected item
	if(indexPath != nil) {
		[self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
	}
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	return [self.sections count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	
	NSNumber *secs = [self.sections objectAtIndex:section];
	return [secs integerValue];
}


// Calculate index based on sections 
- (NSMutableDictionary *) dictonaryForIndexPath:(NSIndexPath *)indexPath {
	NSUInteger cellIndex = 0;
	NSUInteger section = indexPath.section;
	for (int i = 0 ; i < section ; i++ ) {
		int numRows =  [(NSNumber *)[self.sections objectAtIndex:i] intValue];
		cellIndex = cellIndex + ( numRows );
	}
	cellIndex = cellIndex + indexPath.row;
	NSMutableDictionary *dictionary = [self.tableDataSource objectAtIndex:cellIndex];
	return dictionary;
}

// Customize the appearance of table view cells.
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

    // accessory type
    {
        BOOL isButton = [dictionary boolValueForKeyPath:@"Button"];
        if (isButton) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        else if ([dictionary objectForKey:@"accesoryType"]) {
            cell.accessoryType = [DataBrowserUtil accesoryTypeForString:[dictionary objectForKey:@"accesoryType"]];
        }
        
        else {
            NSArray *children = [dictionary objectForKey:@"Children"];
            if (cell.accessoryType == UITableViewCellAccessoryNone &&  [children count] > 0) {
                // if there are children then show the disclosure accessory unless config is different
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
    }
    
    if ([dictionary objectForKey:@"Label"]) {
        cell.textLabel.text = [dictionary objectForKey:@"Label"];
    }
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
    NSLog(@"index path is %ld, %ld", indexPath.section, indexPath.row);
	UIViewController *controller = nil;
	BOOL isModal = NO;
    
    // Unselect the cell.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	//Get the dictionary of the selected data source.
	NSDictionary *dictionary = [self dictonaryForIndexPath:indexPath];
	
	//Get the children of the present item.
	NSArray *children = [dictionary objectForKey:@"Children"];

	if ([children count] == 0) {
		//Get the details of the present item 
		NSString *detailsControllerName = [dictionary objectForKey:@"DetailsViewControllerName"];
        // in case it it html content
		NSString *htmlName = [dictionary objectForKey:@"html"];  
		if ( htmlName )  {
			NSLog(@"WILL load details web view from html file  %@", htmlName);
            // currently disabled as we do not deal with html content right now
			//controller = [[InfoBrowser alloc] initWithLocalFileName:htmlName title:titleName];
		}
		else if ( detailsControllerName ) {
			NSLog(@"WILL load controller from string %@", detailsControllerName);
			if ([detailsControllerName rangeOfString:@"Modal"].location != NSNotFound) isModal = YES;
            controller = [self loadDetailsViewControllerWithIdentifier:detailsControllerName];
            
            // set delegate if a ValueChangerProtocol
            if ([controller conformsToProtocol:@protocol(ValueChangerProtocol)]) {
                id<ValueChangerProtocol> valueChanger = (id<ValueChangerProtocol>)controller;
                [valueChanger setDelegate:self];
                [valueChanger setDelegateIndexPath:indexPath];
                NSString *theValue = [dictionary objectForKey:@"Value"];
                if ( theValue ) [valueChanger setDelegateValue:theValue];
            }

            // set the title of the new controller
			NSString *theTitle = [dictionary objectForKey:@"Title"];
            if (theTitle)  controller.title = theTitle;

            // if we use the default DetailsViewController then we can populate a text label
			NSString *text = [dictionary objectForKey:@"text"];
			if (text) {
				UILabel *label = (UILabel *)[controller.view viewWithTag:TEXT_LABEL];
				if (label) label.text = text;
			}
		}
		else {
			NSLog(@"WARNING: No DetailsViewController configured");
            // we could use default controller to show but then again it's pprob better if the configuration is complete in plist
		}
		if (controller)	{
			if (isModal) {
				[self.navigationController presentViewController:controller animated:YES completion:^{
                }];
			}
			else {
				[self.navigationController pushViewController:controller animated:YES];
			}
		}
	}
	else {
		//Prepare to navigate to next level.
        
        DataBrowserViewController *rvController;

        // is next level is a selection?

        if ( [dictionary objectForKey:@"SelectChild"] ) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            SelectItemViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"SelectItemViewController"];
            
            NSNumber *indexNumber = [dictionary objectForKey:@"SelectedChildIndex"];
            if ( indexNumber ) {
                NSUInteger indexRow = [indexNumber unsignedIntegerValue];
                // a selection list has alway only one section
                controller.selectedIndexPath = [NSIndexPath indexPathForRow:indexRow inSection:0];
                controller.delegate =self;
                controller.delegateIndexPath = indexPath;
            }
            rvController = controller;
        }
        else {
            
            // next level is a list again
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            rvController = [storyboard instantiateViewControllerWithIdentifier:@"DataBrowserViewController"];
        }
		
		//Increment the Current View
		rvController.currentLevel += 1;
		rvController.currentTitle = [dictionary objectForKey:@"Title"];
		rvController.tableDataSource = children;
		rvController.sections = [dictionary objectForKey:@"Sections"];
        
	
		//Push the new table view on the stack
		[self.navigationController pushViewController:rvController animated:YES];
	}
}

#pragma mark UpdateValueDelegate

- (void) didChangeValue:(NSString *)value indexPath:(NSIndexPath*)indexPath
{
    NSLog(@"value has changed to %@ for section %ld and row %ld", value,indexPath.section, indexPath.row);
    NSMutableDictionary *dict = [self dictonaryForIndexPath:indexPath];
    [dict setObject:[NSString stringWithString:value] forKey:@"Value"];
    [self.myTableView reloadData];
}

- (void) didSelectValue:(NSString *)value selectedIndex:(NSUInteger)selectedIndex indexPath:(NSIndexPath *)indexPath
{
    NSLog(@"value has changed to %@ for section %ld and row %ld", value, indexPath.section, indexPath.row);
    NSMutableDictionary *dict = [self dictonaryForIndexPath:indexPath];
    [dict setObject:[NSString stringWithString:value] forKey:@"Value"];
    [dict setObject:[NSNumber numberWithUnsignedLong:selectedIndex] forKey:@"SelectedChildIndex"];
    [self.myTableView reloadData];
}

#pragma mark Actions

-(void) cancelButtonPressed:(id)sender 
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void) nextButtonPressed:(id)sender 
{
    NSLog(@"Next button pressed");
}


@end

