//
//  ViewController.m
//  Maze
//
//  Created by 房彤 on 2020/12/28.
//  Copyright © 2020 房彤. All rights reserved.
//

#import "ViewController.h"
#include <stdlib.h>

struct node {
    int x;      //横坐标
    int y;      //纵坐标
    int f;      //父亲在队列中的编号
    int s;      //步数
};

@interface ViewController ()

@end

//设置地图大小不超过10*10 队列扩展不会超过2500
struct node que[101];
int a[11][11];
int book[11][11];
int tail1;

//char filename[40];


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _array = [[NSMutableArray alloc] init];
    
    [self initView];


}

- (void)initView {
    
    _rowTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 80, 120, 30)];
    [self.view addSubview:_rowTextField];
    _rowTextField.borderStyle = UITextBorderStyleRoundedRect;
    _rowTextField.placeholder = @"请输入行数";
    
    _columnTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 125, 120, 30)];
    [self.view addSubview:_columnTextField];
    _columnTextField.borderStyle = UITextBorderStyleRoundedRect;
    _columnTextField.placeholder = @"请输入列数";
    
    
    _sureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:_sureButton];
    _sureButton.frame = CGRectMake(50, 170, 45, 27);
    [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [_sureButton addTarget:self action:@selector(pressSure) forControlEvents:UIControlEventTouchUpInside];
    
    

    
}

- (void)pressSure {
    
    for (UIView *v in self.view.subviews) {
           if ([v isKindOfClass:[UIImageView class]]) {
               
               [v removeFromSuperview];
           }
    }
    
    [self maze];
    [self initImageView];
    [self path];
}


- (void)maze {
    
    //设置地图大小不超过50*50 队列扩展不会超过2500
    //struct node que[2501];
    
    //记录哪些点已经在队列中
    //int book[11][11] = {0};
    //int a[51][51] = {0};
    
    
    //方向数组
    int next[4][2] = {{0, 1}, {1, 0}, {0, -1}, {-1, 0}};
    
    int head, tail;
    int k, n, m, startx, starty, p, q, tx, ty, flag;
    
    //行 列
    n = [_rowTextField.text intValue];
    m = [_columnTextField.text intValue];
    
    //开始点
    startx = 1;
    starty = 1;
    
    //结束点
    p = n;
    q = m;

    while (1) {
    
        head = 1;
        tail = 1;
        
        //往队列拆入迷宫入坐标
        que[tail].x = startx;
        que[tail].y = starty;
        que[tail].f = 0;
        que[tail].s = 0;
        
        tail++;
        book[startx][starty] = 1;
        
        //标记是否到达终点，0表示没有到达 1表示到达
        flag = 0;
        
        //地图初始化
        for (int i = 1; i <= n; i++) {
            for (int j = 1; j <= m; j++) {
                a[i][j] = 0;
                book[i][j] = 0;
            }
        }
        
        //地图a 随机
        int trap, trap2;
        srand((unsigned)time(NULL));
        for (int i = 1; i <= (n * m) * 0.4; i++) {
            
            trap = rand() % n + 1;
            trap2 = rand() % m + 1;
            a[trap][trap2] = 1;
            
        }

        a[1][1] = 0;
        a[n][m] = 0;
        
        //当队列不为空时 循环
        while (head < tail) {
            
            //枚举四个方向
            for (k = 0; k <= 3; k++) {
                
                //下一个点的坐标
                tx = que[head].x + next[k][0];
                ty = que[head].y + next[k][1];
                
                //判断是否越界
                if (tx < 1 || tx > n || ty < 1 || ty > m) {
                    continue;
                }
                
                //判断是否是障碍物 && 已经在路径中
                if (a[tx][ty] == 0 && book[tx][ty] == 0) {
                    book[tx][ty] = 1;
                    
                    //插入新的点到队列中
                    que[tail].x = tx;
                    que[tail].y = ty;
                    que[tail].f = head;
                    
                    que[tail].s = que[head].s + 1;
                    
                    tail++;
                }
                
                //到目标点 停止扩展 退出循环
                if (tx == p && ty == q) {
                    flag = 1;
                    break;
                }
            }
            if (flag == 1) {
                break;
            }
            //当一个点扩展结束后 才对下一个点进行扩展
            head++;
        }
        
        //判断是不是通的迷宫
        if (que[tail - 1].x == p && que[tail - 1].y == q) {
            break;
        }
    }
    
    FILE *fp;

    //printf("输入文件名：");

    fp = fopen("/Users/fangtong/Desktop/test.txt", "w+");
    if (fp == NULL) {
        printf("\n打开文件失败");
        exit(0);
    }
    
    //地图   存地图
    for(int i = 1; i <= n; i++) {
        for (int j = 1; j <= m; j++) {
            printf("%d", a[i][j]);

            fprintf(fp, "%d", a[i][j]);
            
        }
        printf("\n");
        fputc('\n', fp);
    }
    fclose(fp);
    
    
    
    
    tail1 = tail;
    printf("最短步数%d\n", que[tail - 1].s);
}


- (void)initImageView {
    
    for (int i = 1; i <= [_rowTextField.text intValue]; i++) {
        
        for (int j = 1; j <= [_columnTextField.text intValue]; j++) {
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30 + j * 25, 200 + i * 25, 25, 25)];
            [self.view addSubview:imageView];
            
            imageView.tag = [[NSString stringWithFormat:@"%d%d", i, j] intValue];
            
            [_array addObject:imageView];
            
            if (a[i][j] == 1) {
                imageView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
                imageView.layer.borderWidth = 0.3;
                imageView.layer.borderColor = [UIColor blackColor].CGColor;
            } else {
                imageView.backgroundColor = [UIColor blackColor];
                
            }
            
        }
    }
}

- (void)path {
    int b = tail1 - 1;
    
    FILE *fp;
    fp = fopen("/Users/fangtong/Desktop/path.txt", "w+");
    if (fp == NULL) {
        printf("\n打开文件失败");
        exit(0);
    }

    
    while (que[b].f != 0) {
        
        NSLog(@"%d %d %d %d", que[b].x, que[b].y, que[b].f, que[b].s);
        
        int tx = que[b].x;
        int ty = que[b].y;
        
        //存解的路径
        fprintf(fp, "a[%d][%d]\n", tx, ty);
            
        UIImageView *imageView = [self.view viewWithTag:[[NSString stringWithFormat:@"%d%d", tx, ty] intValue]];
        
        [UIView animateWithDuration:1.7 animations:^{
            imageView.backgroundColor =[UIColor greenColor];
        }];
        
        UIImageView *imageViewTemp = [self.view viewWithTag:11];
        [UIView animateWithDuration:1.7 animations:^{
            imageViewTemp.backgroundColor =[ UIColor greenColor];
        }];
        b = que[b].f;
    }
    fprintf(fp, "a[1][1]");
    fclose(fp);
}

@end
