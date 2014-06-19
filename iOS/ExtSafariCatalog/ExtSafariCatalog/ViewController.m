//
//  ViewController.m
//  ExtSafariCatalog
//
//  Created by B04354 on 2014/05/01.
//  Copyright (c) 2014年 Tadayasu Iwasawa. All rights reserved.
//

#import "ViewController.h"
#import "ReaderViewController.h"

@interface ViewController () <ReaderViewControllerDelegate>

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) // See README
		return UIInterfaceOrientationIsPortrait(interfaceOrientation);
	else
		return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor clearColor]; // Transparent
    
	self.title = @"";

	CGSize viewSize = self.view.bounds.size;
    
	CGRect labelRect = CGRectMake(0.0f, 0.0f, 80.0f, 32.0f);
    
	UILabel *tapLabel = [[UILabel alloc] initWithFrame:labelRect];
	tapLabel.text = @"Start";
	tapLabel.textColor = [UIColor whiteColor];
	tapLabel.textAlignment = NSTextAlignmentCenter;
	tapLabel.backgroundColor = [UIColor clearColor];
	tapLabel.font = [UIFont systemFontOfSize:24.0f];
	tapLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
	tapLabel.autoresizingMask |= UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	tapLabel.center = CGPointMake(viewSize.width / 2.0f, viewSize.height / 2.0f);
    
	[self.view addSubview:tapLabel];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
	//singleTap.numberOfTouchesRequired = 1; singleTap.numberOfTapsRequired = 1; //singleTap.delegate = self;
	[self.view addGestureRecognizer:singleTap];
}

#pragma mark UIGestureRecognizer methods

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)
    
	NSArray *pdfs = [[NSBundle mainBundle] pathsForResourcesOfType:@"pdf" inDirectory:nil];
    
	NSString *filePath = [pdfs lastObject]; assert(filePath != nil); // Path to last PDF file
    
	ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:phrase];
    
	if (document != nil) // Must have a valid ReaderDocument object in order to proceed with things
	{
		ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
        
		readerViewController.delegate = self; // Set the ReaderViewController delegate to self
        
#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)
        
		[self.navigationController pushViewController:readerViewController animated:YES];
        
#else // present in a modal view controller
        
		readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
		readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        
		[self presentViewController:readerViewController animated:YES completion:NULL];
        
#endif // DEMO_VIEW_CONTROLLER_PUSH
	}
}

#pragma mark ReaderViewControllerDelegate methods
- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
