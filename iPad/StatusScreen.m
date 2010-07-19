    //
//  StatusScreen.m
//  MobileCWLite
//
//  Created by Patrick Quinn-Graham on 10-06-25.
//  Copyright (c) 2010 Patrick Quinn-Graham
// 
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//  
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "StatusScreen.h"
#import "HuaweiWifiAPI.h"

@implementation StatusScreen

@synthesize tableView, connect, api, timer;


#pragma mark -
#pragma mark View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.api = [[[HuaweiWifiAPI alloc] init] autorelease];
	api.modemIP = @"192.168.1.1";
	api.modemPassword = @"admin";
	[self updateAPI];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}

-(void)viewWillAppear:(BOOL)animated {
	self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(updateAPI) userInfo:nil repeats:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
	[timer invalidate];
	self.timer = nil;
	
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return (api.modemAvailable && api.connected) ? 2 : 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if(section == 0)
		return api.modemAvailable ? 5 : 1;
	return 6;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
	if(!api.modemAvailable) {
		cell.textLabel.text = @"Modem unavailable";
		cell.detailTextLabel.text = @"";
		return cell;
	}
	switch(indexPath.section) {
		case 0:
			switch(indexPath.row) {
				case 0:
					cell.textLabel.text = @"Carrier";
					cell.detailTextLabel.text = api.operator;
					break;
				case 1:
					cell.textLabel.text = @"Network Type";
					cell.detailTextLabel.text = api.networkTypeLabel;
					break;
				case 2:
					cell.textLabel.text = @"Battery Level";
					cell.detailTextLabel.text = [NSString stringWithFormat:@"%d%%%@", (api.batteryLevel * 25), (api.batteryCharging ? @" (Charging)" : @"")];
					break;
				case 3:
					cell.textLabel.text = @"Signal Level";
					cell.detailTextLabel.text = [NSString stringWithFormat:@"%d%%", (api.connectionStrength * 20)];
					break;
				case 4:
					cell.textLabel.text = @"WiFi Users";
					cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", api.currentWifiUsers];	
			}
			break;
		case 1:
			switch(indexPath.row) {
				case 0:
					cell.textLabel.text = @"IP";
					cell.detailTextLabel.text = api.ipAddress;
					break;
				case 1:
					cell.textLabel.text = @"DNS Server 1";
					cell.detailTextLabel.text = api.dnsPrimary;
					break;
				case 2:
					cell.textLabel.text = @"DNS Server 2";
					cell.detailTextLabel.text = api.dnsSecondary;
					break;
				case 3:
					cell.textLabel.text = @"Downloads";
					cell.detailTextLabel.text = api.downloadsLabel;
					break;
				case 4:
					cell.textLabel.text = @"Uploads";
					cell.detailTextLabel.text = api.uploadsLabel;
					break;
				case 5:
					cell.textLabel.text = @"Connected Time";
					cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", api.connectedTime];	
			}
			break;
	}

	
    // Configure the cell...
    
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if(section == 0)
		return @"Modem Info";
	return @"Connection Info";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}


#pragma mark -
#pragma mark Memory Management


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
	[api release];
	[connect release];
	[tableView release];
    [super dealloc];
}

#pragma mark -
#pragma mark API Interface

-(void)updateAPI {
	[self performSelectorInBackground:@selector(updateAPIInBackground) withObject:nil];
}

-(void)updateAPIInBackground {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[api fetchModemStatus];
	[self performSelectorOnMainThread:@selector(apiUpdatedInBackground) withObject:nil waitUntilDone:NO];
	[pool drain];
	[pool release];	
}
-(void)apiUpdatedInBackground {
	[tableView reloadData];
	if(api.modemAvailable) {
		if(api.pppState == 2) {
			connect.enabled = YES;
			connect.title = @"Connect";
		} else if(api.pppState == 1) {
			connect.enabled = YES;
			connect.title = @"Disconnect";
		} else {
			connect.title = @"Connecting...";
			connect.enabled = NO;
		}
	} else {
		connect.title = @"Connect";
		connect.enabled = NO;
	}
}

#pragma mark -
#pragma mark UI Actions

-(IBAction)connectButtonHit:(id)sender {
	if(api.modemAvailable) {
		[self performSelectorInBackground:@selector(connectBackgrounding) withObject:nil];
	}
}

-(void)connectBackgrounding {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSError *err;
	if(api.pppState == 2) {
		err = [api connect];
	} else {
		err = [api disconnect];
	}
	if(err) {
		NSLog(@"err %@", err);
	}
	[self performSelectorOnMainThread:@selector(updateAPI) withObject:nil waitUntilDone:NO];
	[pool drain];
	[pool release];	
}

@end
