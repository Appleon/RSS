//
//  RSSReaderTableViewController.m
//  RSS
//
//  Created by Cyrilshanway on 2014/12/31.
//  Copyright (c) 2014年 Cyrilshanway. All rights reserved.
//

#import "RSSReaderTableViewController.h"
#import "RssItem.h"

@interface RSSReaderTableViewController ()<NSXMLParserDelegate,UITableViewDataSource, UITableViewDelegate>
{
    //用來下載與解析xml檔
    NSXMLParser *rssParser;
    //放文章項目的清單
    NSMutableArray *rssItems;
    //用來暫存目前解析的元素(暫存標題.鏈結.說明及發表日期內容)
    NSMutableString *title, *link, *description1, *pubDate;
    //儲存目前解析的元素
    NSString *currentElement;
    //存放目前的rss項目
    RssItem  *currentRssItem;
}
@end

@implementation RSSReaderTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    rssItems = [[NSMutableArray alloc] initWithCapacity:0];
    NSURL *url = [NSURL URLWithString:@"http://images.apple.com/main/rss/hotnews/hotnews.rss"];
    rssParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    [rssParser setDelegate:self];
    [rssParser parse];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark -NSXMLParserDelegate delegate methods
//當起始標籤被找到後，didStartElement：方法就會被呼叫
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    currentElement = elementName;
    //先判斷目前的元素為item時初始化變數
    if ([currentElement isEqualToString:@"item"]) {
        RssItem *rssItem = [[RssItem alloc] init];
        currentRssItem = rssItem;
        
        title = [[NSMutableString alloc] init];
        link  = [[NSMutableString alloc] init];
        description1 = [[NSMutableString alloc] init];
        pubDate = [[NSMutableString alloc] init];
    }
}

//當解析器開始解析元素的內容時，會調用此代理方法foundCharacters:
//依照我們解析元素的元素，存到暫存變數中
//使用NSMutableString的原因：分析器每次都只能緩衝部分的內容，每次方法調用會取得特定元素部分的內容
//所以需要用append String(附加字串)來將字串做串連
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    if ([currentElement isEqualToString:@"title"]) {
        [title appendString:string];
    }else if ([currentElement isEqualToString:@"link"]){
        [link appendString:string];
    }else if ([currentElement isEqualToString:@"description"]){
        [description1 appendString:string];
    }else if ([currentElement isEqualToString:@"pubDate"]){
        [pubDate appendString:string];
    }
}

//當結尾標籤找到後，解析器呼叫didEndElement：代理方法
//將剛解析到的內容的RSSItem物件加到陣列中
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if ([elementName isEqualToString:@"item"]) {
        currentRssItem.title = [title stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet ];
        currentRssItem.link  = [link stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
        currentRssItem.description1 = [description1 stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet ];
        currentRssItem.pubDate  = [pubDate stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
        
        [rssItems addObject:currentRssItem];
    }
}

#pragma mark -UITableViewDataSource delegate
//rquire
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSLog(@"%ld", rssItems.count);
    return rssItems.count;
    
}

//將cell標題的子標題分別設定為rss item的title跟pubDate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    RssItem *item = [rssItems objectAtIndex:indexPath.row];
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.pubDate;
    
    return cell;
}

#pragma  mark -確認資料可以正確顯示，當完成xml文件解析時，會通知表格視圖重新載入資料
-(void)parserDidEndDocument:(NSXMLParser *)parser{
    [self.tableView reloadData];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"showWebPage"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        RssItem *item = [rssItems objectAtIndex:indexPath.row];
        [[segue destinationViewController] setLink:item.link];
    }
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
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
