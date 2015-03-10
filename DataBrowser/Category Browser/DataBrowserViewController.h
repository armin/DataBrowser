//
//  BrowseViewController.h
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

#import <UIKit/UIKit.h>

@protocol LeaveProtocol <NSObject>

@end

@protocol UpdateValueDelegate <NSObject>
// send the updated value to delegate. indexPath is the delegate's indexPath so it can update the data source
- (void) didChangeValue:(NSString *)value indexPath:(NSIndexPath*)indexPath;
// send selected item value and index to delegate. indexPath is the delegate's indexPath so it can update the data source.
- (void) didSelectValue:(NSString *)value selectedIndex:(NSUInteger)selectedIndex indexPath:(NSIndexPath*)indexPath ;
@end

@protocol ValueChangerProtocol <NSObject>
- (void) setDelegate:(id<UpdateValueDelegate>)delegate;
- (void) setDelegateIndexPath:(NSIndexPath*)indexPath;
- (void) setDelegateValue:(NSString*)value;
@end

@interface DataBrowserViewController :UIViewController <UITableViewDataSource, UITableViewDelegate, UpdateValueDelegate>

@property (nonatomic, retain) NSString *configFileName;

@property (nonatomic, retain) NSArray *sections;
@property (nonatomic, retain) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) NSArray *tableDataSource;
@property (nonatomic, retain) NSString *currentTitle;
@property (nonatomic, readwrite) NSInteger currentLevel;
@property (nonatomic, retain) NSMutableDictionary *data;
@property BOOL modal;

// psydo protected
- (NSMutableDictionary *) dictonaryForIndexPath:(NSIndexPath *)indexPath;


@end
