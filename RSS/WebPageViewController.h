//
//  WebPageViewController.h
//  RSS
//
//  Created by Cyrilshanway on 2014/12/31.
//  Copyright (c) 2014年 Cyrilshanway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebPageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
//給RSSReadertableViewController傳遞資料用
@property (nonatomic, strong) NSString *link;
@end
