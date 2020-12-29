//
//  ViewController.h
//  Maze
//
//  Created by 房彤 on 2020/12/28.
//  Copyright © 2020 房彤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, strong) UITextField *rowTextField;
@property (nonatomic, strong) UITextField *columnTextField;
@property (nonatomic, strong) UIButton *sureButton;

@property (nonatomic, strong) NSMutableArray *array;

@end

