/*!
 	@file AppController.j

	@brief Controller of Nemesis App

	Handles all declarations and main functions that make up the Nemesis Application

	using GroupDataSource.j, using globals.j (global declarations)

	@author Casey Clyde
	@date 5/20/2011 
 */

@import <Foundation/CPObject.j>
@import <AppKit/CPView.j>
@import "GroupDataSource.j"
@import "globals.j"


@implementation AppController : CPObject
{
	CPSplitView verticalSplitter;
	CPView priceReportView;
	CPView performanceReviewView;
	CPView leftView;
	CPView rightView;
	CPTableView clientView;
	CPTableView fundView;
	CPTableView navView;
	CPTableView estNavView;
	CPTableView estReturnView;
	CPTableView realReturnView;
	CPTableView dateView;
	CPTableView estReturnYtdView;
	CPTableView actualYtdView;
	CPTableView sourceView;
	GroupDataSource clientDS;
	GroupDataSource fundDS;
	GroupDataSource navDS;
	GroupDataSource estNavDS;
	GroupDataSource estReturnDS;
	GroupDataSource realReturnDS;
	GroupDataSource estReturnYtdDS;
	GroupDataSource actualYtdDS;
}
- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
	var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
		contentView = [theWindow contentView];

	[self splitPage:[contentView bounds]];
	[self createClientView]
	[self createFundView];
	[self createNavView];
	[self createEstNavView];
	[self createEstReturnView];
	[self createRealReturnView];
	[self createDateView];
	[self createEstReturnYtdView];
	[self createActualYtdView];
	[self createSourceView];
	
	[self combineViews];
	
	// add vertical splitter (entire page) to contentview
	[contentView addSubview:verticalSplitter];
	
	[self createMenu];
	[theWindow orderFront:self];
}
- (BOOL)windowShouldClose:(id)window
{
    [window close];
    [self reloadData:YES];
}

- (@action)createPopup:(id)sender withURL:(CPString)aURL
{
    var success = true;
    var theURL;
	if([sender title] == "Add Returns"){
		var i = [[fundView selectedRowIndexes] firstIndex];
		if(i != -1)
			theURL = addReturnsURL + "?fund=" + [[fundDS objs] objectAtIndex:i];
		else
		    success = false;
	}
	
    if(success){
	    var newWindow = [[CPWindow alloc] initWithContentRect:CGRectMake(70, 70, 900, 800) styleMask:CPClosableWindowMask | CPResizableWindowMask];
	    [newWindow orderFront:self];
        [newWindow setDelegate:self];
	    var contentView = [newWindow contentView],
		    bounds = [contentView bounds];
	
	    [contentView setAutoresizingMask: CPViewWidthSizable | CPViewHeightSizable];
	    var newWebView = [[CPWebView alloc] initWithFrame:bounds];
	    [newWebView setAutoresizingMask: CPViewWidthSizable | CPViewHeightSizable];
	    [newWebView setMainFrameURL:theURL];

	    [contentView addSubview:newWebView];
	}
	else{
        var theAlert = [[CPAlert alloc] init];
        [theAlert setMessageText:@"You Need to Select a Client, Fund or Both"];
        [theAlert setTitle:@"Error"];
        [theAlert addButtonWithTitle:@"OK"];
        [theAlert runModal];
	}
	
}

/*!
	Called by reload button on top menu, sets pricing report to the front and deselects everything but client
*/
- (void)reloadData:(BOOL)wholePage
{
    if(wholePage){
	[priceReportView addSubview:dateScrollView];
	[priceReportView addSubview:fundScrollView];
	[rightView addSubview:priceReportView];
        var i = [[clientView selectedRowIndexes] firstIndex];   
		if(i > -1){
			var j = [[fundView selectedRowIndexes] firstIndex];
        	[fundDS getGroups:requestFundsURL + "?client=" + [[clientDS objs] objectAtIndex:i]];
        	if(j > -1)
            	[fundView selectRowIndexes:[CPIndexSet indexSetWithIndex:j] byExtendingSelection:NO];
		[fundView deselectAll];
		}
    }
}

- (void)tableViewSelectionDidChange:(CPNotification)aNotification
{
	var i = [[[aNotification object] selectedRowIndexes] firstIndex];
	if(i > -1){
	    if(clientView === [aNotification object]){
		[fundDS getGroups:requestTestFundURL];
	    }
	}
}
- (void)openLink:(id)sender
{
    window.location = "/"; 
}
- (void)refresh:(id)sender
{
    [self reloadData:YES];
}

-(void)showSelected:(id)sender
{
	if([sender title] == "Performance Review")
	{
		[performanceReviewView addSubview:dateScrollView];
		[performanceReviewView addSubview:fundScrollView];
		[rightView addSubview:performanceReviewView];
	}
	else if([sender title] == "Pricing Report")
	{
		[priceReportView addSubview:dateScrollView];
		[priceReportView addSubview:fundScrollView];
		[rightView addSubview:priceReportView];
	}
}
		

- (void)createMenu
{
    [CPMenu setMenuBarVisible:YES];
	var theMenu = [[CPApplication sharedApplication] mainMenu];
	
	var mainMenuItem = [[CPMenuItem alloc] initWithTitle:@"" action:@selector(openLink:) keyEquivalent:nil]; 
    	[mainMenuItem setImage:[[CPImage alloc] initWithContentsOfFile:[[CPBundle mainBundle] pathForResource:@"logo_small.png"] size:CGSizeMake(15,15)]];
	var addReturnsMenuItem = [[CPMenuItem alloc] initWithTitle:@"Add Returns" action:@selector(createPopup:withURL:) keyEquivalent:nil];
	var csvDumpMenuItem = [[CPMenuItem alloc] initWithTitle:@"Dump to CSV" action:@selector(csvDump:) keyEquivalent:nil];
	var pricingReportMenuItem = [[CPMenuItem alloc] initWithTitle:@"Pricing Report" action:@selector(showSelected:) keyEquivalent:nil];
	var performanceReviewItem = [[CPMenuItem alloc] initWithTitle:@"Performance Review" action:@selector(showSelected:) keyEquivalent:nil];
	var printMenuItem = [[CPMenuItem alloc] initWithTitle:@"Print" action:@selector(print:) keyEquivalent:nil];
	var refreshMenuItem = [[CPMenuItem alloc] initWithTitle:@"" action:@selector(refresh:) keyEquivalent:nil]; 
    	[refreshMenuItem setImage:[[CPImage alloc] initWithContentsOfFile:[[CPBundle mainBundle] pathForResource:@"refresh.png"] size:CGSizeMake(15,15)]];

	[theMenu removeItemAtIndex:[theMenu indexOfItemWithTitle: @"New" ]];
	[theMenu removeItemAtIndex:[theMenu indexOfItemWithTitle: @"Open"]];
	[theMenu removeItemAtIndex:[theMenu indexOfItemWithTitle: @"Save"]];

	[theMenu insertItem:mainMenuItem atIndex: 0];
	[theMenu insertItem:addReturnsMenuItem atIndex: 1];
	[theMenu insertItem:csvDumpMenuItem atIndex: 2];
	[theMenu insertItem:pricingReportMenuItem atIndex: 3];
	[theMenu insertItem:performanceReviewItem atIndex: 4];
	[theMenu insertItem:printMenuItem atIndex: 5];
	[theMenu insertItem:refreshMenuItem atIndex: 6];
}
/*!
	The following functions do the work to create each individual view including size and placement specifications
	as well as establishing the Data Sources for each one

*/
- (void)createClientView
{
	clientScrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([leftView bounds]), CGRectGetHeight([leftView bounds]))];
	[clientScrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
	[clientScrollView setAutohidesScrollers:YES];
        
	clientView = [[CPTableView alloc] initWithFrame:[clientScrollView bounds]];
	clientDS = [[GroupDataSource alloc] initWithTable:clientView selectIndex:-1];
	[clientDS getGroups:requestClientsURL];
	[clientView setIntercellSpacing:CGSizeMakeZero()];
   	//[clientView setHeaderView:nil];
	[clientView setCornerView:nil];
	[clientView setDelegate:self];
	[clientView setDataSource:clientDS];
	[clientView setAllowsEmptySelection:NO];
	[clientView setBackgroundColor:[CPColor colorWithHexString:clientViewColor]];

	var column = [[CPTableColumn alloc] initWithIdentifier:clientColId];
	[[column headerView] setStringValue:clientColId];
	[column setWidth:220.0];
	[column setMinWidth:50.0];

	[clientView addTableColumn:column];
	[clientView setColumnAutoresizingStyle:CPTableViewFirstColumnOnlyAutoresizingStyle];
	[clientView setRowHeight:26.0];
	
	[clientScrollView setDocumentView:clientView];
}
- (void)createFundView
{
	fundScrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(0,0,200,topHeight)];
	[fundScrollView setAutoresizingMask: CPViewHeightSizable];
	[fundScrollView setAutohidesScrollers:YES];

	fundView = [[CPTableView alloc] initWithFrame:[fundScrollView bounds]];
	fundDS = [[GroupDataSource alloc] initWithTable:fundView selectIndex:-1];
	[fundView setIntercellSpacing:CGSizeMakeZero()];
    	//[fundView setHeaderView:nil];
	[fundView setCornerView:nil];
	[fundView setDelegate:self];
	[fundView setDataSource:fundDS];
	[fundView setAllowsEmptySelection:NO];
	[fundView setBackgroundColor:[CPColor colorWithHexString:fundViewColor]];

	var column = [[CPTableColumn alloc] initWithIdentifier:fundColId];
	[[column headerView] setStringValue:fundColId];
	[column setWidth:220.0];
	[column setMinWidth:50.0];

	[fundView addTableColumn:column];
	[fundView setColumnAutoresizingStyle:CPTableViewFirstColumnOnlyAutoresizingStyle];
	[fundView setRowHeight:26.0];
	
	[fundScrollView setDocumentView:fundView];
}
- (void)createNavView
{
	navScrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(201,0,175,topHeight)];
	[navScrollView setAutoresizingMask: CPViewHeightSizable];
	[navScrollView setAutohidesScrollers:YES];

	navView = [[CPTableView alloc] initWithFrame:[navScrollView bounds]];
	navDS = [[GroupDataSource alloc] initWithTable:navView selectIndex:-1];
	[navView setIntercellSpacing:CGSizeMakeZero()];
   	//[navView setHeaderView:nil];
   	[navView setCornerView:nil];
	[navView setDelegate:self];
	[navView setDataSource:navDS];
	[navView setAllowsEmptySelection:NO];
	[navView setUsesAlternatingRowBackgroundColors:YES];
	//[NavView setBackgroundColor:[CPColor colorWithHexString:estNavViewColor]];

	var column = [[CPTableColumn alloc] initWithIdentifier:navColId];
	[[column headerView] setStringValue:navColId];
	[column setWidth:220.0];
	[column setMinWidth:50.0];


	[navView addTableColumn:column];
	[navView setColumnAutoresizingStyle:CPTableViewLastColumnOnlyAutoresizingStyle];
	[navView setRowHeight:26.0];
	
	[navScrollView setDocumentView:navView];
}
- (void)createEstNavView
{
	estNavScrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(377,0,175,topHeight)];
	[estNavScrollView setAutoresizingMask: CPViewHeightSizable];
	[estNavScrollView setAutohidesScrollers:YES];

	estNavView = [[CPTableView alloc] initWithFrame:[estNavScrollView bounds]];
	estNavDS = [[GroupDataSource alloc] initWithTable:estNavView selectIndex:-1];
	[estNavView setIntercellSpacing:CGSizeMakeZero()];
   	//[estNavView setHeaderView:nil];
   	[estNavView setCornerView:nil];
	[estNavView setDelegate:self];
	[estNavView setDataSource:estNavDS];
	[estNavView setAllowsEmptySelection:NO];
	[estNavView setUsesAlternatingRowBackgroundColors:YES];
	//[estNavView setBackgroundColor:[CPColor colorWithHexString:estNavViewColor]];

	var column = [[CPTableColumn alloc] initWithIdentifier:estNavColId];
	[[column headerView] setStringValue:estNavColId];
	[column setWidth:220.0];
	[column setMinWidth:50.0];


	[estNavView addTableColumn:column];
	[estNavView setColumnAutoresizingStyle:CPTableViewLastColumnOnlyAutoresizingStyle];
	[estNavView setRowHeight:26.0];
	
	[estNavScrollView setDocumentView:estNavView];
}

- (void)createEstReturnView
{
	estReturnScrollView = [[CPScrollView alloc] initWithFrame: CGRectMake(553, 0, 175, topHeight)];
	[estReturnScrollView setAutoresizingMask: CPViewHeightSizable];
	[estReturnScrollView setAutohidesScrollers:YES];

	estReturnView = [[CPTableView alloc] initWithFrame:[estReturnScrollView bounds]];
	estReturnDS = [[GroupDataSource alloc] initWithTable: estReturnView selectIndex: -1];
	[estReturnView setIntercellSpacing:CGSizeMakeZero()];
	[estReturnView setCornerView:nil];
	[estReturnView setDelegate:self];
	[estReturnView setDataSource:estReturnDS];
	[estReturnView setAllowsEmptySelection:NO];
	[estReturnView setUsesAlternatingRowBackgroundColors:YES];
	
	var column = [[CPTableColumn alloc] initWithIdentifier:estReturnColId];
    	[[column headerView] setStringValue:estReturnColId];
    	[column setWidth:220.0];
    	[column setMinWidth:50.0];
    
    	[estReturnView addTableColumn:column];
    	[estReturnView setColumnAutoresizingStyle:CPTableViewLastColumnOnlyAutoresizingStyle];
    	[estReturnView setRowHeight:26.0];
	
	[estReturnScrollView setDocumentView:estReturnView];

}
- (void)createRealReturnView
{
	realReturnScrollView = [[CPScrollView alloc] initWithFrame: CGRectMake(729, 0, 175, topHeight)];
	[realReturnScrollView setAutoresizingMask: CPViewHeightSizable];
	[realReturnScrollView setAutohidesScrollers:YES];

	realReturnView = [[CPTableView alloc] initWithFrame:[realReturnScrollView bounds]];
	realReturnDS = [[GroupDataSource alloc] initWithTable: estReturnView selectIndex: -1];
	[realReturnView setIntercellSpacing:CGSizeMakeZero()];
	[realReturnView setCornerView:nil];
	[realReturnView setDelegate:self];
	[realReturnView setDataSource:realReturnDS];
	[realReturnView setAllowsEmptySelection:NO];
	[realReturnView setUsesAlternatingRowBackgroundColors:YES];
	
	var column = [[CPTableColumn alloc] initWithIdentifier:realReturnColId];
    	[[column headerView] setStringValue:realReturnColId];
    	[column setWidth:220.0];
    	[column setMinWidth:50.0];
    
    	[realReturnView addTableColumn:column];
    	[realReturnView setColumnAutoresizingStyle:CPTableViewLastColumnOnlyAutoresizingStyle];
    	[realReturnView setRowHeight:26.0];
	
	[realReturnScrollView setDocumentView:realReturnView];

}

- (void)createDateView
{
	dateScrollView = [[CPScrollView alloc] initWithFrame: CGRectMake(905, 0, 150, topHeight)];
	[dateScrollView setAutoresizingMask: CPViewHeightSizable];
	[dateScrollView setAutohidesScrollers:YES];

	dateView = [[CPTableView alloc] initWithFrame:[estReturnScrollView bounds]];
	dateDS = [[GroupDataSource alloc] initWithTable: dateView selectIndex: -1];
	[dateView setIntercellSpacing:CGSizeMakeZero()];
	[dateView setCornerView:nil];
	[dateView setDelegate:self];
	[dateView setDataSource:dateDS];
	[dateView setAllowsEmptySelection:NO];
	[dateView setUsesAlternatingRowBackgroundColors:YES];
	
	var column = [[CPTableColumn alloc] initWithIdentifier:dateColId];
    	[[column headerView] setStringValue:dateColId];
    	[column setWidth:220.0];
    	[column setMinWidth:50.0];
    
    	[dateView addTableColumn:column];
    	[dateView setColumnAutoresizingStyle:CPTableViewLastColumnOnlyAutoresizingStyle];
    	[dateView setRowHeight:26.0];
	
	[dateScrollView setDocumentView:dateView];

}
- (void)createEstReturnYtdView
{
	estReturnYtdScrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(202,0,235,topHeight)];
	[estReturnYtdScrollView setAutoresizingMask: CPViewHeightSizable];
	[estReturnYtdScrollView setAutohidesScrollers:YES];

	estReturnYtdView = [[CPTableView alloc] initWithFrame:[estReturnScrollView bounds]];
	estReturnYtdDS = [[GroupDataSource alloc] initWithTable: estReturnView selectIndex: -1];
	[estReturnYtdView setIntercellSpacing:CGSizeMakeZero()];
	[estReturnYtdView setCornerView:nil];
	[estReturnYtdView setDelegate:self];
	[estReturnYtdView setDataSource:estReturnYtdDS];
	[estReturnYtdView setAllowsEmptySelection:NO];
	[estReturnYtdView setUsesAlternatingRowBackgroundColors:YES];
	
	var column = [[CPTableColumn alloc] initWithIdentifier:estReturnYtdColId];
    	[[column headerView] setStringValue:estReturnYtdColId];
    	[column setWidth:220.0];
    	[column setMinWidth:50.0];
    
    	[estReturnYtdView addTableColumn:column];
    	[estReturnYtdView setColumnAutoresizingStyle:CPTableViewLastColumnOnlyAutoresizingStyle];
    	[estReturnYtdView setRowHeight:26.0];
	
	[estReturnYtdScrollView setDocumentView:estReturnYtdView];

}
- (void)createActualYtdView
{
	actualYtdScrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(439,0,235,topHeight)];
	[actualYtdScrollView setAutoresizingMask: CPViewHeightSizable];
	[actualYtdScrollView setAutohidesScrollers:YES];

	actualYtdView = [[CPTableView alloc] initWithFrame:[actualYtdScrollView bounds]];
	actualYtdDS = [[GroupDataSource alloc] initWithTable: actualYtdView selectIndex: -1];
	[actualYtdView setIntercellSpacing:CGSizeMakeZero()];
	[actualYtdView setCornerView:nil];
	[actualYtdView setDelegate:self];
	[actualYtdView setDataSource:actualYtdDS];
	[actualYtdView setAllowsEmptySelection:NO];
	[actualYtdView setUsesAlternatingRowBackgroundColors:YES];
	
	var column = [[CPTableColumn alloc] initWithIdentifier:actualYtdColId];
    	[[column headerView] setStringValue:actualYtdColId];
    	[column setWidth:220.0];
    	[column setMinWidth:50.0];
    
    	[actualYtdView addTableColumn:column];
    	[actualYtdView setColumnAutoresizingStyle:CPTableViewLastColumnOnlyAutoresizingStyle];
    	[actualYtdView setRowHeight:26.0];
	
	[actualYtdScrollView setDocumentView:actualYtdView];
}

- (void)createSourceView
{
	sourceScrollView = [[CPScrollView alloc] initWithFrame: CGRectMake(676, 0, 227, topHeight)];
	[sourceScrollView setAutoresizingMask: CPViewHeightSizable];
	[sourceScrollView setAutohidesScrollers:YES];

	sourceView = [[CPTableView alloc] initWithFrame:[sourceScrollView bounds]];
	sourceDS = [[GroupDataSource alloc] initWithTable: sourceView selectIndex: -1];
	[sourceView setIntercellSpacing:CGSizeMakeZero()];
	[sourceView setCornerView:nil];
	[sourceView setDelegate:self];
	[sourceView setDataSource:sourceDS];
	[sourceView setAllowsEmptySelection:NO];
	[sourceView setUsesAlternatingRowBackgroundColors:YES];
	
	var column = [[CPTableColumn alloc] initWithIdentifier:sourceColId];
    	[[column headerView] setStringValue:sourceColId];
    	[column setWidth:220.0];
    	[column setMinWidth:50.0];
    
    	[sourceView addTableColumn:column];
    	[sourceView setColumnAutoresizingStyle:CPTableViewLastColumnOnlyAutoresizingStyle];
    	[sourceView setRowHeight:26.0];
	
	[sourceScrollView setDocumentView:sourceView];
}
- (void)splitPage:(CGRect)aBounds
{
	// create a view to split the page by left/right
	verticalSplitter = [[CPSplitView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(aBounds), CGRectGetHeight(aBounds))];
	[verticalSplitter setDelegate:self];
	[verticalSplitter setVertical:YES]; 
	[verticalSplitter setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable ];
	[verticalSplitter setIsPaneSplitter:YES]; //1px splitter line	

	//create left/right views
	leftView = [[CPView alloc] initWithFrame:CGRectMake(0, 0, 225, CGRectGetHeight([verticalSplitter bounds]))];
	rightView = [[CPView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([verticalSplitter bounds]) - 200, topHeight)];
	[rightView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable ];

}
- (void)combineViews
{
    	priceReportView = [[CPView alloc] initWithFrame:CGRectMake(0.0, 0, CGRectGetWidth([rightView bounds]), topHeight)];
	[priceReportView setBackgroundColor:[CPColor colorWithHexString:estNavViewColor]];
	

	performanceReviewView = [[CPView alloc] initWithFrame:CGRectMake(0.0,0,CGRectGetWidth([rightView bounds]), topHeight)];
	[performanceReviewView setBackgroundColor:[CPColor colorWithHexString:estNavViewColor]];	
	

	[leftView addSubview:clientScrollView];
	
	// add subviews to priceReportView
	[priceReportView addSubview:fundScrollView];
	[priceReportView addSubview:navScrollView];
	[priceReportView addSubview:estNavScrollView];
	[priceReportView addSubview:estReturnScrollView];
	[priceReportView addSubview:realReturnScrollView];
	[priceReportView addSubview:dateScrollView];

	//add subviews to performanceReviewView
	//[performanceReviewView addSubview:fundScrollView];
	[performanceReviewView addSubview:estReturnYtdScrollView];
	[performanceReviewView addSubview:actualYtdScrollView];
	[performanceReviewView addSubview:sourceScrollView];
	//[performanceReviewView addSubview:dateScrollView];

	//add performance review and price report to right view
	
	[rightView addSubview:performanceReviewView];
	[rightView addSubview:priceReportView];

	//set priceReport as main view
	//[rightView :priceReportView];
	// add the left/right view to the verticalview
	[verticalSplitter addSubview:leftView];
	[verticalSplitter addSubview:rightView];
	
}
@end
