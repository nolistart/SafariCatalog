// PDFView.h

#import <UIKit/UIKit.h>

@interface PDFView : UIView
{
    CGPDFPageRef    _page;
}

// プロパティ
@property (nonatomic) CGPDFPageRef page;

@end

