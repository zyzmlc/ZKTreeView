//
//  TreeNode.m
//  NodeTest
//
//  Created by 小冬 on 2021/1/17.
//  Copyright © 2021 小冬. All rights reserved.
//

#import "TreeNode.h"

@implementation TreeNode

+ (TreeNode *)createRootNode{
    TreeNode *node = [TreeNode new];
    node.parent = nil;
    node.children = nil;
    node.data = @"根节点";
    node.type = NSTreeNodeTypeExpand;
    return node;
}

/** 初始化节点 */
+ (id)treeNodeWithData:(id)data type:(NSTreeNodeType)type parent:(TreeNode *)parent{
    return [[TreeNode alloc] initWithData:data type:type parent:parent];
}

/** 初始化节点 */
- (id)initWithData:(id)data type:(NSTreeNodeType)type parent:(TreeNode *)parent{
    self = [super init];
    if (self) {
        self.data = data;
        self.type = type;
        self.parent = parent;
    }
    return self;
}

/*插入子节点数组*/
- (void)insertChildrenNode:(NSArray <TreeNode *>*)array{
    if (array.count == 0) {
        self.children = nil;
    }
    self.children = array;
}

/* 插入子节点 */ 
- (void)insertChildNode:(TreeNode *)Node{
    NSMutableArray *childrenArray = [NSMutableArray arrayWithArray:self.children];
    [childrenArray addObject:Node];
    self.children = [childrenArray copy];
}

/* 获取层级， 用来布局*/
- (NSInteger)level {
    NSInteger level = 0;
    TreeNode *temp = self;
    while (temp.parent) {
        temp = temp.parent;
        level++;
    }
    return level;
}
@end
