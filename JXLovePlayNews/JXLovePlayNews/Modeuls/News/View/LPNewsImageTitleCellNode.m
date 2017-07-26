//
//  LPNewsImageTitleCellNode.m
//  JXLovePlayNews
//
//  Created by mac on 17/7/26.
//  Copyright © 2017年 JXIcon. All rights reserved.
// 自定义 cell

#import "LPNewsImageTitleCellNode.h"
#import <YYWebImage.h>



@interface LPNewsImageTitleCellNode ()
@property (nonatomic, strong) ASTextNode *titleNode;
@property (nonatomic, strong) ASDisplayNode *imageNode;
@property (nonatomic, strong) ASImageNode *replyImageNode;
@property (nonatomic, strong) ASTextNode *replyTextNode;
@property (nonatomic, strong) ASTextNode *timeNode;
@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation LPNewsImageTitleCellNode
- (instancetype)initWithNewsInfo:(LPNewsInfoModel *)newsInfo
{
    if (self = [super initWithNewsInfo:newsInfo]) {
        
        [self addTitleNode];
        
        [self addImageNode];
        
        [self addTimeNode];
        
        [self addReplyTextNode];
        
        [self addReplyImageNode];
    }
    return self;
}

- (void)didLoad
{
    [super didLoad];
    
    [self addImageView];
}

- (void)addImageView
{
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.backgroundColor = RGB_255(245, 245, 245);
    imageView.yy_imageURL = [self.newsInfo.imgsrc.firstObject appropriateImageURL];
    [self.view addSubview:imageView];
    _imageView = imageView;
}

- (void)addTitleNode
{
    ASTextNode *titleNode = [[ASTextNode alloc]init];
    titleNode.placeholderEnabled = YES;
    titleNode.placeholderColor = RGB_255(245, 245, 245);
    titleNode.layerBacked = YES;
    titleNode.maximumNumberOfLines = 2;
    NSDictionary *attrs = @{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-bold" size:16.0f] ,NSForegroundColorAttributeName: RGB_255(36, 36, 36)};
    titleNode.attributedText = [[NSAttributedString alloc]initWithString:self.newsInfo.title attributes:attrs];
    [self addSubnode:titleNode];
    _titleNode = titleNode;
}

- (void)addImageNode
{
    ASDisplayNode *imageNode = [[ASDisplayNode alloc]init];
    imageNode.layerBacked = YES;
    [self addSubnode:imageNode];
    _imageNode = imageNode;
}

- (void)addTimeNode
{
    ASTextNode *timeNode = [[ASTextNode alloc]init];
    timeNode.layerBacked = YES;
    timeNode.maximumNumberOfLines = 1;
    NSDictionary *attrs = @{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:12.0f] ,NSForegroundColorAttributeName: RGB_255(150, 150, 150)};
    NSString *time = self.newsInfo.ptime.length > 10 ? [self.newsInfo.ptime substringToIndex:10]:self.newsInfo.ptime;
    timeNode.attributedText = [[NSAttributedString alloc]initWithString:time attributes:attrs];
    [self addSubnode:timeNode];
    _timeNode = timeNode;
}

- (void)addReplyImageNode
{
    ASImageNode *replyImageNode = [[ASImageNode alloc]init];
    replyImageNode.layerBacked = YES;
    replyImageNode.contentMode = UIViewContentModeCenter;
    replyImageNode.image = [UIImage imageNamed:@"common_chat_new"];
    [self addSubnode:replyImageNode];
    _replyImageNode = replyImageNode;
}

- (void)addReplyTextNode
{
    ASTextNode *replyTextNode = [[ASTextNode alloc]init];
    replyTextNode.layerBacked = YES;
    replyTextNode.maximumNumberOfLines = 1;
    NSDictionary *attrs = @{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:12.0f] ,NSForegroundColorAttributeName: RGB_255(150, 150, 150)};
    replyTextNode.attributedText = [[NSAttributedString alloc]initWithString:@(self.newsInfo.replyCount).stringValue attributes:attrs];
    [self addSubnode:replyTextNode];
    _replyTextNode = replyTextNode;
}


/**!
 ======>>>>> 示例代码
 - (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
 {
 
 // 1
 NSMutableArray *mainStackContent = [[NSMutableArray alloc] init];
 [mainStackContent addObject:_titleLabel];
 [mainStackContent addObject:_contentLabel];
 
 // 2
 _albumCountLabel.textContainerInset = UIEdgeInsetsMake(3, 5, 3, 5);
 
 // 3
 ASRelativeLayoutSpec *albumCountSpec = [ASRelativeLayoutSpec
 relativePositionLayoutSpecWithHorizontalPosition:ASRelativeLayoutSpecPositionStart
 verticalPosition:ASRelativeLayoutSpecPositionCenter
 sizingOption:ASRelativeLayoutSpecSizingOptionMinimumWidth
 child:_albumCountLabel];
 
 // 4
 [mainStackContent addObject:albumCountSpec];
 
 
 // 5
 ASStackLayoutSpec *contentSpec =
 [ASStackLayoutSpec
 stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
 spacing:8.0
 justifyContent:ASStackLayoutJustifyContentStart
 alignItems:ASStackLayoutAlignItemsStretch
 children:mainStackContent];
 contentSpec.style.flexShrink = 1.0;
 
 // 6
 _photoImageNode.style.preferredSize = CGSizeMake(90, 90);
 
 // 7
 ASStackLayoutSpec *avatarContentSpec =
 [ASStackLayoutSpec
 stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
 spacing:16.0
 justifyContent:ASStackLayoutJustifyContentStart
 alignItems:ASStackLayoutAlignItemsStart
 children:@[_photoImageNode, contentSpec]];
 
 // 8
 return [ASInsetLayoutSpec
 insetLayoutSpecWithInsets:UIEdgeInsetsMake(8, 16, 8, 16)
 child:avatarContentSpec];
 }
 
 
 */


// ===============>>>>>
// 注意到一个细节没有？不管是 ASNetworkImageNode 还是 ASTextNode，它们都不需要设置框架（frame）。这是因为它们的构建和布局是分开进行的（这就是框架名字中 Async 异步的由来了），在初始化方法中，你只管构建好了，布局在另一个方法中进行：

/**!
 所有的 ASNode 都必须在这个方法中进行布局，这也是这一节重点要介绍的地方：
 
 1.一个数组，我们放入了两个对象：一个标题标签，一个内容标签。这个后面会用到，因为我们打算将这两个标签放在一起，上下排列。
 2.设置曲目数标签的文字补白，这样会在这个标签的文字四周补上一些边距，不至于让文字紧紧地被边框包裹在一起，因为默认的 Inset 值是 0。
 3.一个相对布局，这个和 Android 中的相对布局是一样的。这个相对布局我们指定它的水平对齐方式为左对齐，垂直对齐方式为中对齐，在宽度上进行紧凑布局（相当于 Android 的 layout_width=”wrap_content”)，然后将曲目数标签放入布局。这样会导致这个标签居于这个布局中的左边垂直居中，同时标签宽度不会占满整行，而是内容有多长就多宽。
 4.将这个对布局也放到前面的数组中，这样，三个标签就放在一块了，上下排列。
 5.要将 3个标签放到一块，需要将 3 者（即前面的数组，我们已经将 3 者放到一个数组了）添加到一个 stack 布局中。stack 布局类似自动布局中的 UIStackView，专门作为其他节点的容器，并且可以方便地指定这些节点的排列方式。这里我们在构建 stack 布局时指定三者为垂直排列，行间距 8，主轴方向(y轴)顶对齐，交叉轴方向(x轴)占据行宽。
 6.现在来布局图片的大小，一般来说图片大小是固定的，这里我们通过设置它的 style.preferredSize 来指定它的固定大小为 90*90。
 7.创建另一个 stack 布局，将图片和另一个 stack 布局（即 3 个标签）放到一起，指定：让两者水平排列、水平间距 16、主轴方向左对齐，交叉轴方向顶对齐。
 8.最后在 stack 布局的基础上补白。并返回补白后的 Inset 布局。
 ASDK 有 4 中布局，这 4 种布局分别是：
 
 ASStackLayoutSpec: 允许你定义一个水平或垂直的子节点栈。它的 justifyContent 属性决定栈在相应方向上的子节点之间的间距。alignItems 属性决定了它们在另一个坐标轴上的间距。这种 layout specs 有点像 UIKit 的 UIStackView。
 ASOverlayLayoutSpec: 允许你拉伸一个元素横跨到另一个元素。被覆盖的对象必须要有一个固定的 content size，否则无法工作。
 ASRelativeLayoutSpec: 一种相对布局，允许将一个东西以相对位置放置在它的有效空间内。参考一下“9-切片图”的 9 个切片。你可以让一个东西放在这 9 个切片中的某个上。
 ASInsetLayoutSpec: 一个 inset 布局，允许你在一个已有的对象的基础上添加某些间距。你想在你的 cell 四周加上经典的 iOS 16 像素的边距吗？用这个就对了。
 在这个例子中我们用到了 3 种。Overlay 布局不太常用，它类似于 css 中的 position : absolute 属性，允许将一个布局重叠到另一个布局上。
 
 */
- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    _imageNode.style.preferredSize = CGSizeMake(constrainedSize.max.width, 160);
    _titleNode.style.flexShrink = YES; // 如果子元素的堆叠大小的总和大于最大大小，那么这个对象是否缩小？
    _replyImageNode.style.preferredSize = CGSizeMake(12, 12);
    
    /// ASStackLayoutSpec: 允许你定义一个水平或垂直的子节点栈。它的 justifyContent 属性决定栈在相应方向上的子节点之间的间距。alignItems 属性决定了它们在另一个坐标轴上的间距。这种 layout specs 有点像 UIKit 的 UIStackView。
    ASStackLayoutSpec *horReplayStackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:5 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsCenter children:@[_replyImageNode,_replyTextNode]];
    
    ASStackLayoutSpec *horBottomStackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:0 justifyContent:ASStackLayoutJustifyContentSpaceBetween alignItems:ASStackLayoutAlignItemsStretch children:@[_timeNode,horReplayStackLayout]];
    horBottomStackLayout.style.flexGrow = YES; //如果子元素的堆叠大小的总和小于最小大小，那么这个对象是否增长？
    
    ASStackLayoutSpec *verBottomStackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:12 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStretch children:@[_titleNode,horBottomStackLayout]];
    verBottomStackLayout.style.flexGrow = YES;
    
    ASInsetLayoutSpec *insetLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 15, 12, 15) child:verBottomStackLayout];
    
    ASStackLayoutSpec *verStackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:12 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStretch children:@[_imageNode,insetLayout]];
    
    return verStackLayout;
}

- (void)layout
{
    [super layout];
    _imageView.frame = _imageNode.frame;
}


@end
