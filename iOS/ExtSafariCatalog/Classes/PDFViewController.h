// PDFViewController.h

#import <UIKit/UIKit.h>

@class PDFView;

@interface PDFViewController : UIViewController
{
    CGPDFDocumentRef    _document;
    int                 _index;
    
    IBOutlet UIScrollView*  _mainScrollView;
    
    IBOutlet UIView*        _innerView;
    IBOutlet PDFView*       _pdfView0;
    IBOutlet UIScrollView*  _subScrollView;
    IBOutlet PDFView*       _pdfView1;
    IBOutlet PDFView*       _pdfView2;
}

@end

