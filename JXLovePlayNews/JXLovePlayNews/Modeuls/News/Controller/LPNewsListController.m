//
//  LPNewsListController.m
//  JXLovePlayNews
//
//  Created by mac on 17/7/25.
//  Copyright © 2017年 JXIcon. All rights reserved.
//

#import "LPNewsListController.h"
#import <MJRefresh/MJRefresh.h>
#import "LPRefreshGifHeader.h"
#import "LPNewsInfoModel.h"
#import "LPNewsBaseCellNode.h"
#import "LPNewsImageTitleCellNode.h"
#import "LPNewsImageCellNode.h"
#import "LPNewsCellNode.h"
#import "LPNewsViewModel.h"


@interface LPNewsListController ()<ASTableDelegate,ASTableDataSource>

// UI
@property (nonatomic, strong) ASTableNode *tableNode;

// Data
@property (nonatomic, strong) NSArray *newsList;
@property (nonatomic, assign) NSInteger curIndexPage;
@property (nonatomic, assign) BOOL haveMore;

@end

@implementation LPNewsListController
#pragma mark - life cycle

- (instancetype)init
{
    if (self = [super initWithNode:[ASDisplayNode new]]) {
        _sourceType = 1;
        [self addTableNode];
    }
    return self;
}

- (void)addTableNode
{
    _tableNode = [[ASTableNode alloc] init];
    _tableNode.backgroundColor = [UIColor whiteColor];
    _tableNode.delegate = self;
    _tableNode.dataSource = self;
    [self.node addSubnode:_tableNode];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureTableView];
    
    [self addRefreshHeader];
    [self loadData];
    
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _tableNode.frame = self.node.bounds;
}


#pragma mark - private Method

- (void)configureTableView
{
    if (_extendedTabBarInset) {
        _tableNode.view.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
        _tableNode.view.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 49, 0);
    }
    _tableNode.view.tableFooterView = [[UIView alloc]init];
    _tableNode.view.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)addRefreshHeader
{
    self.tableNode.view.mj_header = [LPRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
}

- (void)loadData{
    
    NSInteger curIndexPage = _curIndexPage;
    curIndexPage = 0;
    _haveMore = YES;
    
    if (!_newsList) {
        [LPLoadingView showLoadingInView:self.view];
    }
    
    [LPNewsViewModel requestNewsListWithTopId:_newsTopId pageIndex:_curIndexPage completion:^(NSArray<LPNewsInfoModel *> *modelArray) {
        
        [_tableNode.view.mj_header endRefreshing];
        [LPLoadingView hideLoadingForView:self.view];
        
        // 加载失败或者没有数据
        if (modelArray.count == 0) {
            
            if (_newsList.count == 0) {
                __weak typeof(self) weakSelf = self;
                [LPLoadFailedView showLoadFailedInView:self.view retryHandle:^{
                    [weakSelf loadData];
                }];
            }
            return ;
        }
        
        // 加载最新
        if (_newsList.count == 0){
            
            _newsList = modelArray;
            [_tableNode reloadData];
            _curIndexPage++;
            
            
        }else{
            
            LPNewsInfoModel *infoModel = _newsList.firstObject;
            NSMutableArray *indexPaths = [NSMutableArray array];
            NSInteger index = 0;
            for (LPNewsInfoModel *newInfoModel in modelArray) {
                if ([newInfoModel.docid isEqualToString:infoModel.docid]) {
                    break;
                }
                [indexPaths addObject:[NSIndexPath indexPathForRow:index inSection:0]];
                ++index;
            }
            
            if (indexPaths.count > 0) {
                NSArray *newAddList = [modelArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, index)]];
                _newsList = [newAddList arrayByAddingObjectsFromArray:_newsList];
                [_tableNode insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
                [self showUpdateNewsCountView:newAddList.count];
            }
            
        }
        
    }];
  
}

- (void)loadMoreDataWithContext:(ASBatchContext *)context
{
    if (context) {
        [context beginBatchFetching];
    }
    
    
    [LPNewsViewModel requestNewsListWithTopId:_newsTopId pageIndex:_curIndexPage completion:^(NSArray<LPNewsInfoModel *> *modelArray) {
        
        
        if (context) {
            // 加载更多
            if (modelArray.count > 0) {
                NSMutableArray *indexPaths = [NSMutableArray array];
                for (NSInteger row = _newsList.count; row<_newsList.count+modelArray.count; ++row) {
                    [indexPaths addObject:[NSIndexPath indexPathForRow:row inSection:0]];
                }
                _newsList = [_newsList arrayByAddingObjectsFromArray:modelArray];
                [_tableNode insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                _curIndexPage++;
                _haveMore = YES;
                
            }else {
                _haveMore = NO;
            }
        }
        if (context) {
            [context completeBatchFetching:YES];
        }
        
        
    }];

    
    
}


#pragma mark - 显示更新新闻条数
- (void)showUpdateNewsCountView:(NSInteger)count
{
    CGFloat labelH = 25;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), -labelH)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"发现%zd条新内容",count];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = RGBA_255(238, 95, 112, 0.8);
    [self.view insertSubview:label aboveSubview:_tableNode.view];
    
    // 移动动画
    [UIView animateWithDuration:0.5 animations:^{
        label.transform = CGAffineTransformMakeTranslation(0, labelH);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
            label.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
}



#pragma mark - ASTableDataSource

// 1.这个方法用于告诉 ASTableNode，用户的一次下拉动作是否需要触发异步抓取，这里我们返回了 YES，也就是不管什么情况都进行异步抓取。我们这样做的原因，是现在的后台服务从来不告诉前端什么时候数据才会”完”,反正有数据的话服务器会返回数据，没数据的话则返回错误（比如“ 404 没有数据” 之类）或者返回空结果集。所以我们根本无法事先知道数据什么时候数据已经加载完。所以不管数据有没有完，我们都当做没有完来进行抓取，并通过服务器返回的结果来判断。这样这个方法就没有必要进行任何计算了，直接返回 YES。
- (BOOL)shouldBatchFetchForTableView:(ASTableView *)tableView
{
    return _newsList.count && _haveMore;
}

// 2.这个方法用于进行一次抓取。loadPageWithContext: 方法是我们自定义的，它会加载一页数据，同时页数会累加，这样每次都会加载“下一页”，除非服务器没有数据返回。context 参数是必须的，用于抓取完后通知 ASTableNode 抓取完成（见后面的loadPageWithContext 方法实现)。
- (void)tableView:(ASTableView *)tableView willBeginBatchFetchWithContext:(ASBatchContext *)context
{
    [self loadMoreDataWithContext:context];
    
    
}


- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section{
    
    return _newsList.count;
}


- (ASCellNodeBlock)tableView:(ASTableView *)tableView nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LPNewsInfoModel *newsInfo = _newsList[indexPath.row];
    ASCellNode *(^cellNodeBlock)() = ^ASCellNode *() {
        LPNewsBaseCellNode *cellNode = nil;
        
        if (_sourceType == 0) {
            cellNode = [[LPNewsImageTitleCellNode alloc] initWithNewsInfo:newsInfo];
        }else {
            switch (newsInfo.showType) {
                case 2:
                    cellNode = [[LPNewsImageCellNode alloc] initWithNewsInfo:newsInfo];
                    break;
                default:
                    cellNode = [[LPNewsCellNode alloc] initWithNewsInfo:newsInfo];
                    break;
            }
        }
        return cellNode;
    };
    return cellNodeBlock;
}

#pragma mark - ASTableDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LPNewsInfoModel *newsInfo = _newsList[indexPath.row];
//    LPNewsDetailController *detail = [[LPNewsDetailController alloc]init];
//    detail.newsId = newsInfo.docid;
//    [self.navigationController pushViewController:detail animated:YES];
}





#pragma mark - 新增两个方法
/**!
 
 // 1
 - (void)loadPageWithContext:(ASBatchContext *)context
 {
 NSString* radioId = [[AccountAdditionalModel currentAccount] radioId];
 // 2
 [self loadAlbums:radioId pageNum:pageNum+1 pageSize:pageSize].thenOn(dispatch_get_main_queue(),^(NSArray<AlbumModel>* array){
 
 if(array!=nil){
 // 3
 pageNum = pageNum+1;
 [_models addObjectsFromArray: array];
 // 4
 [self insertNewRowsInTableNode:array];
 }
 // 5
 if (context) {
 [context completeBatchFetching:YES];
 }
 
 }).catch(^(NSError* error){
 [self showHint:error.localizedDescription];
 // 6
 if (context) {
 [context completeBatchFetching:YES];
 }
 });
 
 }
 
 // 7
 - (void)insertNewRowsInTableNode:(NSArray<AlbumModel>*)array
 {
 NSInteger section = 0;
 NSMutableArray *indexPaths = [NSMutableArray array];
 
 for (NSUInteger row = _models.count-array.count; row < _models.count; row++) {
 NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:section];
 [indexPaths addObject:path];
 }
 [_tableNode insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
 }
 
 
 
 ====================>>>>>>>>>>>>>>>>>>>
 代码解释如下：
 
 这个方法用于加载一页数据，如果后台服务器也支持分页查询的话。这里各人的实现会不一样，这个实现仅供参考。
 在这个方法中，调用你自己的分页抓取实现，具体的实现就不介绍了，无非就是向服务器进行异步请求之类的。注意，这里的分页抓取实现使用了 Promise 设计模型来解决异步调用的问题，即 thenOn/catch 形式。
 当所请求的数据返回，如果结果集不为空，我们累加当前页数和数据源数组。
 调用 insertNewRowsInTableNode 方法，这个方法向 tableNode 中插入新的单元格（见后面的实现）。
 数据源更新完毕，一定要通知 context（ASBatchContext 实例）告诉它批抓取结束，即调用它的 completeBatchFetching 方法。
 出现错误时，也要调用 completeBatchFetching。
 insertNewRowsInTableNode 方法实现就很简单了，一次向 tableNode 中插入多个 cell。

 
 
 
 批抓取什么时候进行？
 
 ASTableNode 也有“页”的概念，但和我们向服务器进行分页请求时的“页”不同，这里的“页”是一屏的概念。也就是说，我们在 viewDidLoad 中设置 self.tableNode.view.leadingScreensForBatching = 1.0; 这一句时，表示当屏幕中还剩下一屏（页）的数据就要显示完的时候，ASTableNode 会自动进行抓取。
 
 但是我们一次向服务器能够请求的页大小并不一定能够填满一屏。比如分页查询的页大小是 4，然而 4 条数据并不足以填满一个屏幕，因此 ASTableNode 还会再请求一次分页查询，然后检查（会进行一个预布局，计算数据显示时的尺寸）是否填满一屏，如果不够，会再次请求，直至填满一屏。
 
 也就是说，数据在真正得到显示之前就已经进行了布局（异步的）。当需要显示的时候，仅仅是一个绘制而已，这样绘制的速度就会非常快，滚动体验会无比顺滑。
 

 
 
 */


@end
