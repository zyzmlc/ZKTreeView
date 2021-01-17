//
//  TreeNode.h
//  NodeTest
//
//  Created by 小冬 on 2021/1/17.
//  Copyright © 2021 小冬. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, NSTreeNodeType) {
    NSTreeNodeTypeExpand,   // 下级展开的节点，部门级别，文件夹
    NSTreeNodeTypeShrink,   // 下级收起的节点，展示UI的时候用到
    NSTreeNodeTypeObject,   // 没有下级的节点，成员
};

@interface TreeNode : NSObject

/** 父节点, parent=nil时表示根节点. 务必不要与children冲突,  */
@property (nonatomic, strong) TreeNode * _Nullable parent;

/** 子节点, 务必不要与parent冲突 */
@property (nonatomic, strong) NSArray <TreeNode *>*_Nullable children;

/* 参考 NSTreeNodeType */
@property (nonatomic, assign) NSTreeNodeType type;

/* 节点包含的数据, 注意, 不是包含下级节点 */
@property (nonatomic, strong) id data;

/* 取得当前节点所在的层级, 0 表示根节点 ，用parent来查找*/
@property (nonatomic, assign, readonly) NSInteger level;

/* 1：创建根结点 */
+ (TreeNode *)createRootNode;

/* 初始化节点 */
+ (id)treeNodeWithData:(id)data type:(NSTreeNodeType)type parent:(TreeNode *)parent;

/*2： 初始化节点 */
- (id)initWithData:(id)data type:(NSTreeNodeType)type parent:(TreeNode *)parent;

/*插入子节点数组*/
- (void)insertChildrenNode:(NSArray <TreeNode *>*)array;

/*3： 插入子节点 */
- (void)insertChildNode:(TreeNode *)Node;


@end

NS_ASSUME_NONNULL_END
