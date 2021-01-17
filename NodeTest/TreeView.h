//
//  TreeView.h
//  NodeTest
//
//  Created by 小冬 on 2021/1/17.
//  Copyright © 2021 小冬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TreeNode.h"


NS_ASSUME_NONNULL_BEGIN
@protocol TreeViewDelegate;

@interface TreeView : UITableView

/* 树形数据的根节点, 根节点不会加入到listSource中 */
@property (nonatomic, strong) TreeNode *treeSource;

/* 界面上展示的列表数据, 由treeSource转换而来, 无法直接设置 */
@property (nonatomic, strong, readonly) NSArray *listSource;

/* 设置/获取 选中的节点 */
@property (nonatomic, strong) TreeNode *selectNode;

/* 事件委托 */
@property (nonatomic, weak) id<TreeViewDelegate>  action;


@end

@protocol TreeViewDelegate <NSObject>
/* 高度   */
- (CGFloat)treeView:(TreeView *)treeView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

 /* yes表示此行会被选中 */
- (BOOL)treeView:(TreeView *)treeView clickAtTreeNode:(TreeNode *)node;

/* cell */
- (UITableViewCell *)treeView:(TreeView *)treeView cellAtTreeNode:(TreeNode *)node atIndexPath:(NSIndexPath *)indexPath;

@end


NS_ASSUME_NONNULL_END
