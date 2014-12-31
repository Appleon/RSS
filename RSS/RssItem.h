//
//  RssItem.h
//  RSS
//
//  Created by Cyrilshanway on 2014/12/31.
//  Copyright (c) 2014年 Cyrilshanway. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RssItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *description1;
@property (nonatomic, strong) NSString *pubDate;
@end
