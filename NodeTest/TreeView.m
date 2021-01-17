//
//  TreeView.m
//  NodeTest
//
//  Created by 小冬 on 2021/1/17.
//  Copyright © 2021 小冬. All rights reserved.
//

#import "TreeView.h"

@interface TreeView () <UITableViewDataSource, UITableViewDelegate, TreeViewDelegate> {
    TreeNode *_treeSource;
    NSMutableArray *_listSource;
}

@end

@implementation TreeView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        _listSource = [NSMutableArray array];
    }
    return self;
}

- (void)transformFromTree:(TreeNode *)tree toList:(NSMutableArray *)list {
    if (tree.level != 0) {
        [list addObject:tree];
    }
    if (tree.type == NSTreeNodeTypeExpand) {
        for (TreeNode* nextNode in tree.children) {
            [self transformFromTree:nextNode toList:list];
        }
    }
}

- (void)reloadData {
    [_listSource removeAllObjects];
    [self transformFromTree:_treeSource toList:_listSource];
    [super reloadData];
}

- (void)setTreeSource:(TreeNode *)node {
    _treeSource = node;
    _treeSource.parent = nil;
    [self reloadData];
}

- (void)setSelectNode:(TreeNode *)node {
    _selectNode = node;
    
    if ([self.action treeView:self clickAtTreeNode:node]) {
        NSInteger row = [_listSource indexOfObject:node];
        [self selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    } else {
        NSInteger row = [_listSource indexOfObject:_selectNode];
        [self selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TreeNode *treeNode = [_listSource objectAtIndex:indexPath.row];
    if (treeNode.type == NSTreeNodeTypeExpand) {
        treeNode.type = NSTreeNodeTypeShrink;
        [self reloadData];
    }
    else if (treeNode.type == NSTreeNodeTypeShrink) {
        treeNode.type = NSTreeNodeTypeExpand;
        [self reloadData];
    }
    
    if ([self.action treeView:self clickAtTreeNode:treeNode])
    {
        _selectNode = treeNode;
        NSInteger row = [_listSource indexOfObject:treeNode];
        [self selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    } else {
        NSInteger row = [_listSource indexOfObject:_selectNode];
        [self selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _listSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TreeNode *treeNode = _listSource[indexPath.row];
    return [self.action treeView:self cellAtTreeNode:treeNode atIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   return  [self.action treeView:self heightForRowAtIndexPath:indexPath];
}


@end
