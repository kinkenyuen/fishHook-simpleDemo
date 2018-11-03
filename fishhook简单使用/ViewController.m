//
//  ViewController.m
//  fishhook简单使用
//
//  Created by Kinken_Yuen on 2018/10/30.
//  Copyright © 2018年 Kinken_Yuen. All rights reserved.
//

#import "ViewController.h"
#import "fishhook.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"第一次调用.");
    
    //hook交换方法
//    struct rebinding {
//        const char *name; //需要hook的函数名称，C字符串
//        void *replacement; //新函数的地址
//        void **replaced;  //原始函数地址的指针（二级指针）
//    };
    struct rebinding nslog;
    nslog.name = "NSLog";
    nslog.replacement = myNSLog;
    nslog.replaced = (void *)&sys_nslog;
    
    struct rebinding rebs[1] = {nslog};
    /**
     重新绑定符号

     @param rebindings#> 存放rebingding结构体的数组 description#>
     @param rebindings_nel#> 数组的长度 description#>
     @return return value description
     */
    rebind_symbols(rebs, 1);
    printf("修改完毕!");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchBegin-");
    
}

#pragma mark - 更改系统NSLog调用
//函数指针,保存原始函数的地址
static void (*sys_nslog)(NSString *format,...);

void myNSLog(NSString *format, ...) {
    format = [format stringByAppendingString:@"hook成功！"];
    sys_nslog(format);
}



@end
