//
//  LPNewsPagerController.m
//  JXLovePlayNews
//
//  Created by mac on 17/7/25.
//  Copyright © 2017年 JXIcon. All rights reserved.
//

#import "LPNewsPagerController.h"
#import "LPNewsListController.h"

@interface LPNewsPagerController ()

@property (nonatomic, strong) NSArray *newsPageInfos;

@end

@implementation LPNewsPagerController

#pragma mark - lifeCycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        [self configurePagerStyles];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
        [self configurePagerStyles];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 把视图扩展到底部tabbar
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    [self loadData];
    
    [self configureTabButtonPager];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)configurePagerStyles
{
    self.adjustStatusBarHeight = YES;
    self.contentTopEdging = 44;
    self.barStyle = TYPagerBarStyleProgressElasticView;
}

- (void)configureTabButtonPager
{
    self.pagerBarView.backgroundColor = RGB_255(34, 34, 34);
    self.progressColor = RGB_255(237, 67, 89);
    self.normalTextColor = [UIColor whiteColor];
    self.selectedTextColor = RGB_255(237, 67, 89);
    self.cellWidth = 38;
    self.collectionLayoutEdging = 12;
    self.cellSpacing = (kScreenWidth - _newsPageInfos.count*self.cellWidth - 2*self.collectionLayoutEdging)/(_newsPageInfos.count-1);
    self.progressBottomEdging = 3;
}

#pragma mark - load data

- (void)loadData
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"NewsInfo" ofType:@"plist"];
    NSDictionary *data = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    _newsPageInfos = [data objectForKey:@"newsPageInfos"];
}

#pragma mark - TYPagerControllerDataSource

- (NSInteger)numberOfControllersInPagerController
{
    return _newsPageInfos.count;
}

- (NSString *)pagerController:(TYPagerController *)pagerController titleForIndex:(NSInteger)index
{
    NSDictionary *newsPageInfo = _newsPageInfos[index];
    NSString *title = [newsPageInfo objectForKey:@"title"];
    return title ? title : @"";
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index
{
    NSDictionary *newsPageInfo = _newsPageInfos[index];
    LPNewsListController *newsVC = [[LPNewsListController alloc]init];
    newsVC.newsTopId = [newsPageInfo objectForKey:@"topId"];
    // 扩展到底部tabbar
    newsVC.extendedTabBarInset = YES;
    return newsVC;
}


@end
