# fishHook-simpleDemo

# hook定义
hook：改变程序执行流程的一种技术统称。
# fishhook
它是Facebook提供的一个动态修改链接mach-O文件的工具。利用MachO文件加载原理，通过修改懒加载和非懒加载两个表的指针达到C函数HOOK的目的。

[fishhook](https://github.com/facebook/fishhook)

# 使用fishhook修改系统C函数实现
## 以NSLog函数为例
1.利用一个函数指针保存原NSLog函数的地址
`static void (*sys_nslog)(NSString *format,...);`

2.替换函数，效果就是调用NSLog时，先执行我们的替换函数，一般都会手动调用父类或原先的实现（根据需求），通过上一步指针的记录来调用。
```
void myNSLog(NSString *format, ...) {
    format = [format stringByAppendingString:@"hook成功！"];
    sys_nslog(format);
    sys_nslog(@"%s",__func__);
}
```
3.重新绑定符号
```
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
```

