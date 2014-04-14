//
//  PDFAppDelegate.h
//

#import <UIKit/UIKit.h>

@class PDFViewController;

@interface PDFAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    PDFViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet PDFViewController *viewController;

@end

