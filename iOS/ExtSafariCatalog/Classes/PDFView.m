// PDFView.m

#import "PDFView.h"

@implementation PDFView

// プロパティ
@synthesize page = _page;

//--------------------------------------------------------------//
#pragma mark -- Property --
//--------------------------------------------------------------//

- (void)setPage:(CGPDFPageRef)page
{
    // ページの設定
    _page = page;
    
    // 画面の更新
    [self setNeedsDisplay];
}

//--------------------------------------------------------------//
#pragma mark -- Drawing --
//--------------------------------------------------------------//

- (void)drawRect:(CGRect)rect
{
    // ページのチェック
    if (!_page) {
        return;
    }
    
    // グラフィックスコンテキストの取得
    CGContextRef    context;
    context = UIGraphicsGetCurrentContext();
    
    // 垂直方向に反転するアフィン変換の設定
    CGContextScaleCTM(context, 1.0f, -1.0f);
    CGContextTranslateCTM(context, 0, -CGRectGetHeight(rect));
    
    // ページ全体を表示するためのアフィン変換の設定
    CGAffineTransform   transform;
    transform = CGPDFPageGetDrawingTransform(_page, kCGPDFMediaBox, rect, 0, YES);
    CGContextConcatCTM(context, transform);
    
    // ページの描画
    CGContextDrawPDFPage(context, _page);
}

@end

