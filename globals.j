/*!
	@file globals.j

	@brief global declarations for Nemesis App

	@author Omar Chanouha, modified by: Casey Clyde
	@date 5/20/2011
*/

requestClientsURL = @"php/getJSONClients.php";
requestTestFundURL = @"php/getJSONTestFunds.php";
requestFundsURL = @"php/getJSONFunds.php";
addReturnsURL = @"php/addReturns.php";


fundColId = @"Funds";
clientColId = @"Clients";
navColId = @"NAVs";
estNavColId = @"Est. NAVs";
estReturnColId = @"Est. Return";
realReturnColId = @"Real Return";
dateColId = @"Date";
estReturnYtdColId = @"Est. Ytd Return";
actualYtdColId = @"Actual Ytd";
sourceColId = @"Source";

groupColHeaderName = @"groupId";
plHeaderName = @"P&L";

naString = @"N/A";

headerColor = [CPColor colorWithPatternImage:[[CPImage alloc] initWithContentsOfFile:[[CPBundle mainBundle] pathForResource:@"button-bezel-center.png"]]]; 
clientViewColor = @"EBF3F5";
fundViewColor = @"fae3da";
navViewColor = @"EBF3F5";
estNavViewColor = @"CCDDDD";
redColor = @"FF0000";
greenColor = @"189818";
blackColor = @"000000";

colWidth = 125;

resetNoti = @"ResetNotification";

allName = @"All";

topHeight = 648;
