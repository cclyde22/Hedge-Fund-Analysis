@implementation GroupDataSource : CPObject
{
	JSObject objs @accessors;
	CPTableView theTable;
	CPNumber theIndex;
}
- (id)initWithTable:(CPTableView)aTable
{
	if(self = [super init])
	{
		objs = [];
		theTable = aTable;
		theIndex = -1;
	}
	return self;
}
- (id)initWithTable:(CPTableView)aTable selectIndex:(CPNumber)aIndex
{
	if(self = [super init])
	{
		objs = [];
		theTable = aTable;
        theIndex = aIndex;
	}
	return self;
}
- (void)getGroups:(CPString)aURL
{
	var request = [CPURLRequest requestWithURL:aURL];
	[[CPURLConnection alloc] initWithRequest:request delegate:self];
}
- (void)connection:(CPURLConnection)aConnection didReceiveData:(CPString)data
{
	objs = [data objectFromJSON];
	[theTable reloadData];
	if(theIndex > -1)
		[theTable selectRowIndexes:[CPIndexSet indexSetWithIndex:theIndex] byExtendingSelection:NO];

}
- (void)connection:(CPURLConnection)aConnection didFailWithError:(CPString)error
{
    alert(error) ;
}
- (int)numberOfRowsInTableView:(CPTableView)tableView
{
	return [objs count];
}
- (id)tableView:(CPTableView)tableView objectValueForTableColumn:(CPTableColumn)tableColumn row:(int)row
{
	return objs[row];
}
@end
