//
//  LPNewsCommentController.m
//  LovePlayNews
//
//  Created by tanyang on 16/8/20.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPNewsCommentController.h"
#import "LPNewsCommentCellNode.h"
#import "LPNewsTitleSectionView.h"
#import "LPLoadingView.h"
#import "LPLoadFailedView.h"

@interface LPNewsCommentController ()<ASTableDelegate, ASTableDataSource>

// UI
@property (nonatomic, strong) ASTableNode *tableNode;

// Data
@property (nonatomic, strong) LPNewsCommentModel *hotComments;
@property (nonatomic, strong) LPNewsCommentModel *newestComments;

@property (nonatomic, assign) NSInteger curIndexPage;
@property (nonatomic, assign) BOOL haveMore;

@end

static NSString *headerId = @"LPNewsTitleSectionView";

@implementation LPNewsCommentController

#pragma mark - life cycle

- (instancetype)init
{
    if (self = [super initWithNode:[ASDisplayNode new]]) {
        
        [self addTableNode];
    }
    return self;
}

- (void)addTableNode
{
    _tableNode = [[ASTableNode alloc] init];
    _tableNode.backgroundColor = RGB_255(247, 247, 247);
    _tableNode.delegate = self;
    _tableNode.dataSource = self;
    [self.node addSubnode:_tableNode];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view layoutIfNeeded];
    
    [self configureTableView];
    
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _tableNode.frame = self.node.bounds;
}

- (void)configureTableView
{
    _tableNode.view.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableNode.view.tableFooterView = [[UIView alloc]init];
    [_tableNode.view registerClass:[LPNewsTitleSectionView class] forHeaderFooterViewReuseIdentifier:headerId];
}

#pragma mark - load Data

- (void)loadData
{
    [LPLoadingView showLoadingInView:self.view];
   
    
    _curIndexPage = 0;
    _haveMore = YES;
}

- (void)loadMoreDataWithContext:(ASBatchContext *)context
{
    if (context) {
        [context beginBatchFetching];
    }
    
}

#pragma mark - ASTableDataSource

- (BOOL)shouldBatchFetchForTableView:(ASTableView *)tableView
{
    return _newestComments.commentIds.count > 0 && _haveMore;
}

- (void)tableView:(ASTableView *)tableView willBeginBatchFetchWithContext:(ASBatchContext *)context
{
    [self loadMoreDataWithContext:context];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _hotComments.commentIds.count > 0 || _newestComments.commentIds.count > 0 ? 2 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return _hotComments.commentIds.count;
        case 1:
            return _newestComments.commentIds.count;
        default:
            return 0;
    }
}

- (ASCellNodeBlock)tableView:(ASTableView *)tableView nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *floors = indexPath.section == 0 ? _hotComments.commentIds[indexPath.row] :_newestComments.commentIds[indexPath.row];
    NSDictionary *comments = indexPath.section == 0 ? _hotComments.comments : _newestComments.comments;
    ASCellNode *(^commentCellNodeBlock)() = ^ASCellNode *() {
        LPNewsCommentCellNode *cellNode = [[LPNewsCommentCellNode alloc] initWithCommentItems:comments floors:floors];
        return cellNode;
    };
    return commentCellNodeBlock;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_hotComments.commentIds.count == 0 && section == 0) {
        return nil;
    }else if (_newestComments.commentIds.count == 0 && section == 1) {
        return nil;
    }
    
    LPNewsTitleSectionView *sectionView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerId];
    
    switch (section) {
        case 0:
            sectionView.title = @"热门跟帖";
            break;
        case 1:
            sectionView.title = @"最新跟帖";
            break;
        default:
            break;
    }
    
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_hotComments.commentIds.count > 0 && section == 0) {
        return 28;
    }else if (_newestComments.commentIds.count > 0 && section == 1) {
        return 28;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
