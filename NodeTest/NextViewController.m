//
//  NextViewController.m
//  NodeTest
//
//  Created by 小冬 on 2021/1/17.
//  Copyright © 2021 小冬. All rights reserved.
//

#import "NextViewController.h"
#import "TreeView.h"
#import "ViewController.h"

// 判断是否为iPhone x 或者 xs
#define iPhoneX [[UIScreen mainScreen] bounds].size.width == 375.0f && [[UIScreen mainScreen] bounds].size.height == 812.0f
// 判断是否为iPhone xr 或者 xs max
#define iPhoneXR [[UIScreen mainScreen] bounds].size.width == 414.0f && [[UIScreen mainScreen] bounds].size.height == 896.0f
// 是全面屏手机
#define isFullScreen (iPhoneX || iPhoneXR)

// 全面屏适配 适配
// 状态栏高度
#define kStateBarHeight (isFullScreen ? 44.0 : 20.0)
// 导航栏高度
#define kNavigationBarHeight (kStateBarHeight + 44.0)
// 底部tabbar高度
#define kTabBarHeight (isFullScreen ? (49.0+34.0) : 49.0)

#define TabbarSafeBottomMargin     (iPhoneX ? 34.f : 0.f)


#define cellHeight 60


@interface NextViewController () <TreeViewDelegate>

@property (nonatomic,strong)  TreeView     *treeView;
@property (nonatomic,strong)  TreeNode     *rootNode;

@end

@implementation NextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"集团";
    
    TreeView *treeView = [[TreeView alloc] init];
    treeView.backgroundColor = [UIColor whiteColor];
    treeView.action = self;
    treeView.showsVerticalScrollIndicator = NO;
    treeView.frame = CGRectMake(0, kStateBarHeight, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height -  kStateBarHeight );
    treeView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:treeView];
    _treeView = treeView;
    
    
    [self setupData];
    // 设置数据源
    _treeView.treeSource = self.rootNode;
    [_treeView reloadData];
}

#pragma mark - UITreeViewDelegate
- (CGFloat)treeView:(TreeView *)treeView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}
- (BOOL)treeView:(TreeView *)treeView clickAtTreeNode:(TreeNode *)node /* yes表示此行会被选中 */
{
    if(node.type == NSTreeNodeTypeObject)
    {
        NSLog(@"名字：%@", node.data);
        ViewController *vc = [ViewController new];
        vc.title = node.data;
        [self.navigationController pushViewController:vc animated:YES];
    }
    return YES;
}

- (UITableViewCell *)treeView:(TreeView *)treeView cellAtTreeNode:(TreeNode *)node atIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *kCellIdentifier = @"kCellIdentifier";
    UITableViewCell *cell = [treeView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    else for (UIView *view in cell.contentView.subviews)
        [view removeFromSuperview];
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    
    
    float w = treeView.bounds.size.width;
    float h = cellHeight;
    
    // 背景, 分割线
    NSInteger level = [node level];
    NSInteger offset = level * 30 ;
    //  根结点的level是0
    
    UIImageView* separator = [[UIImageView alloc] initWithFrame:CGRectMake(offset, cellHeight - 1, w - offset - 10, 1)];
    separator.backgroundColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:separator];
    
    
    // 展开/收起
    UIImageView* headIcon = [[UIImageView alloc] initWithFrame:CGRectMake(offset, (cellHeight - 20 )/2, 2*10, 2*10)];
    if (node.type == NSTreeNodeTypeShrink)
        headIcon.image = [UIImage imageNamed:@"arrow_down"];
    if (node.type == NSTreeNodeTypeExpand)
        headIcon.image = [UIImage imageNamed:@"arrow_up"];
    if (node.type == NSTreeNodeTypeObject){
        headIcon.image = [UIImage imageNamed:@"icon_head"];
        headIcon.frame = CGRectMake(offset, 10, 40, 40);
        
    }
    [cell.contentView addSubview:headIcon];
    
    // 标题
    UILabel* textLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headIcon.frame) + 10 , 0, w - CGRectGetMaxX(headIcon.frame) - 20 , h - 1)];
    textLabel.textColor = [UIColor blackColor];
    textLabel.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:textLabel];
    
    
    textLabel.text = node.data;
    
    return cell;
}


#pragma mark - 数据

- (void)setupData{
    
    NSArray *companyArray = @[@"集团一", @"集团二", @"集团三"];
    NSArray *departArray = @[@"部门一", @"部门二", @"部门三", @"部门四"];
    NSArray *departChildArray = @[@"子部门一", @"子部门二"];
    NSArray *personArray = @[@"张三", @"李四", @"王五"];
    
    // 根节点
    TreeNode *rootNode = [TreeNode createRootNode];
    
    for(int i = 0; i < companyArray.count; i++){
        // 总公司一
        TreeNode *companyNode = [[TreeNode alloc] initWithData:companyArray[i] type:NSTreeNodeTypeShrink parent:rootNode];
        [rootNode insertChildNode:companyNode];
        
        for(int m = 0; m < departArray.count; m++){
            // 部门一
            TreeNode *departNode = [[TreeNode alloc] initWithData:departArray[m] type:NSTreeNodeTypeShrink parent:companyNode];
            [companyNode insertChildNode:departNode];
            
            if(m == 1){
                for (int j = 0; j < departChildArray.count; j ++) {
                    TreeNode *deparChildtNode = [[TreeNode alloc] initWithData:departChildArray[j] type:NSTreeNodeTypeShrink parent:departNode];
                    [departNode insertChildNode:deparChildtNode];
                    
                    for (int n = 0; n < personArray.count; n++) {
                         TreeNode *personNode = [[TreeNode alloc] initWithData:personArray[n] type:NSTreeNodeTypeObject parent:deparChildtNode];
                         [deparChildtNode insertChildNode:personNode];
                    }
                }
            }else{
                for (int n = 0; n < personArray.count; n++) {
                     TreeNode *personNode = [[TreeNode alloc] initWithData:personArray[n] type:NSTreeNodeTypeObject parent:departNode];
                     [departNode insertChildNode:personNode];
                }
            }
        }
    }
    
    self.rootNode = rootNode;
}


@end
