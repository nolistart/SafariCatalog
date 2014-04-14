// PDFViewController.m

#import "PDFViewController.h"
#import "PDFView.h"

@interface PDFViewController (private)

// 表示の更新
- (void)_renewPages;

@end

@implementation PDFViewController

//--------------------------------------------------------------//
#pragma mark -- View --
//--------------------------------------------------------------//
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    // PDFドキュメントの作成
    NSString*   path;
    NSURL*      url;
    path = [[NSBundle mainBundle] pathForResource:@"extsafari" ofType:@"pdf"];
    url = [NSURL fileURLWithPath:path];
    _document = CGPDFDocumentCreateWithURL((CFURLRef)url);
    
    // innerViewをメインスクロールビューに追加
    [_mainScrollView addSubview:_innerView];
    
    // メインスクロールビューのコンテントサイズを設定
    _mainScrollView.contentSize = _innerView.frame.size;
    
    // インデックスの初期値として-1を設定
    _index = -1;
}

- (void)viewWillAppear:(BOOL)animated
{
    // 親クラスの呼び出し
    [super viewWillAppear:animated];
    
    // ページの更新
    [self _renewPages];
}

//--------------------------------------------------------------//
#pragma mark -- Image --
//--------------------------------------------------------------//

- (void)_renewPages
{
    CGRect          rect;
    CGPDFPageRef    page;
    
    // 現在のインデックスを保存
    int oldIndex = _index;
    
    // PDFのページ数を取得
    int pageNumber;
    pageNumber = CGPDFDocumentGetNumberOfPages(_document);
    
    // コンテントオフセットを取得
    CGPoint offset;
    offset = _mainScrollView.contentOffset;
    if (offset.x == 0) {
        // 前のページへ移動
        _index--;
    }
    if (offset.x >= _mainScrollView.contentSize.width - CGRectGetWidth(_mainScrollView.frame)) {
        // 次のページへ移動
        _index++;
    }
    
    // インデックスの値をチェック
    if (_index < 1) {
        _index = 1;
    }
    if (_index > pageNumber) {
        _index = pageNumber;
    }
    
    if (_index == oldIndex) {
        return;
    }
    
    //
    // 左側のPDF viewを更新
    //
    
    // 最初のページのとき
    if (_index == 1) {
        // 左側のPDF viewは表示しない
        rect = CGRectZero;
        
        page = NULL;
    }
    // 最初のページ以外のとき
    else {
        // 左側のPDF viewのframe
        rect.origin = CGPointZero;
        rect.size = self.view.frame.size;
        
        // 左側のPDF viewの画像の読み込み
        page = CGPDFDocumentGetPage(_document, _index - 1);
    }
    
    // 左側のPDF viewの設定
    _pdfView0.frame = rect;
    _pdfView0.page = page;
    
    //
    // 中央のPDF view、サブスクロールビューを更新
    //
    
    // 中央のPDF viewの画像の読み込み
    page = CGPDFDocumentGetPage(_document, _index);
    
    // サブスクロールビューのframe
    rect.origin.x = CGRectGetMaxX(_pdfView0.frame) > 0 ?
            CGRectGetMaxX(_pdfView0.frame) + 20.0f : 0;
    rect.origin.y = 0;
    rect.size = self.view.frame.size;
    
    // サブスクロールビューの設定
    _subScrollView.frame = rect;
    
    // サブスクロールビューのスケールをリセットする
    _subScrollView.zoomScale = 1.0f;
    _pdfView1.transform = CGAffineTransformIdentity;
    
    // 中央のPDF viewの設定
    rect.origin = CGPointZero;
    rect.size = self.view.frame.size;
    _pdfView1.frame = rect;
    _pdfView1.page = page;
    
    // サブスクロールビューのコンテントサイズを設定する
    _subScrollView.contentSize = rect.size;
    
    // サブスクロールビューのスケールを設定する
    _subScrollView.minimumZoomScale = 1.0f;
    _subScrollView.maximumZoomScale = 2.0f;
    _subScrollView.zoomScale = 1.0f;
    
    //
    // 右側のPDF viewを更新
    //
    
    // 最後のページのとき
    if (_index >= pageNumber) {
        rect = CGRectZero;
        
        page = NULL;
    }
    // 最後のページ以外のとき
    else {
        // 右側のPDF viewのframe
        rect.origin.x = CGRectGetMaxX(_subScrollView.frame) + 20.0f;
        rect.origin.y = 0;
        rect.size = self.view.frame.size;
        
        // 右側のPDF viewの画像の読み込み
        page = CGPDFDocumentGetPage(_document, _index + 1);
    }
    
    // 右側のPDF viewの設定
    _pdfView2.frame = rect;
    _pdfView2.page = page;
    
    //
    // メインスクロールビューの更新
    //
    
    // コンテントサイズとオフセットの設定
    CGSize  size;
    size.width = CGRectGetMaxX(_pdfView2.frame) > 0 ? 
            CGRectGetMaxX(_pdfView2.frame) + 20.0f : 
            CGRectGetMaxX(_subScrollView.frame) + 20.0f;
    size.height = 0;
    _mainScrollView.contentSize = size;
    _mainScrollView.contentOffset = _subScrollView.frame.origin;
}

//--------------------------------------------------------------//
#pragma mark -- UIScrollViewDelegate --
//--------------------------------------------------------------//

- (void)scrollViewDidEndDragging:(UIScrollView*)scrollView 
        willDecelerate:(BOOL)decelerate
{
    // メインスクロールビューの場合
    if (scrollView == _mainScrollView) {
        if (!decelerate) {
            // ページの更新
            [self _renewPages];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
    // メインスクロールビューの場合
    if (scrollView == _mainScrollView) {
        // ページの更新
        [self _renewPages];
    }
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView*)scrollView
{
    // サブスクロールビューの場合
    if (scrollView == _subScrollView) {
        // 中央のPDF viewを使う
        return _pdfView1;
    }
    
    return nil;
}

@end
