//
//  ViewController.m
//  ReactiveCcocoa
//
//  Created by 张家铭 on 16/7/28.
//  Copyright © 2016年 张家铭. All rights reserved.
//

#import "ViewController.h"
#import "GlobalHeader.h"
#import "JMRedView.h"
#import "JMFlag.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet UITextField *textField2;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (strong, nonatomic) id <RACSubscriber> subscriber;
@property (weak, nonatomic) IBOutlet JMRedView *redView;

@property (strong, nonatomic) UIButton *btn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   

}

/** skip:跳跃几个值 */
- (void)test32 {
    RACSubject *subject = [RACSubject subject];
    [[subject skip:2] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    [subject sendNext:@1];
    [subject sendNext:@2];
    [subject sendNext:@3];
}

/** distinctUntilChanged:只要当前的值与上一个相同，就不会被订阅到 */
- (void)test31 {
    RACSubject *subject = [RACSubject subject];
    [[subject distinctUntilChanged] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    [subject sendNext:@1];
    [subject sendNext:@1];
    [subject sendNext:@1];
}

/** distinctUntilChanged:只要当前的值与上一个相同，就不会被订阅到 */
- (void)test30 {
    RACSubject *subject = [RACSubject subject];
    [[subject distinctUntilChanged] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    [subject sendNext:@1];
    [subject sendNext:@1];
    [subject sendNext:@1];
}

/** takeUntil:只要传入的信号发送完成或传入的信号发送任意数据，就不会接收源信号的内容 */
- (void)test29 {
    RACSubject *subject = [RACSubject subject];
    RACSubject *subject1 = [RACSubject subject];
    [[subject takeUntil:subject1] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    [subject sendNext:@1];
    [subject sendNext:@2];
    [subject1 sendCompleted];
    [subject sendNext:@3];
}

/** takeLast 取后面几个值 */
- (void)test28 {
    RACSubject *subject = [RACSubject subject];
    [[subject takeLast:2] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    [subject sendNext:@1];
    [subject sendNext:@2];
    [subject sendNext:@3];
    [subject sendCompleted];
}

/** take 取前面几个值 */
- (void)test27 {
    RACSubject *subject = [RACSubject subject];
    [[subject take:1] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    [subject sendNext:@1];
    [subject sendNext:@2];
}

/** 忽略 */
- (void)test26 {
    RACSubject *subject = [RACSubject subject];
    
    // 忽略值 ignoreValues:忽略所有值
    RACSignal *ignoreSignal = [subject ignore:@"1"];
    
    [ignoreSignal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    [subject sendNext:@"123"];
}

/** 过滤 filter */
- (void)test25 {
    // 只有当文本框的内容大于3时，才想要获取文本框的内容
    [[_textField1.rac_textSignal filter:^BOOL(id value) {
        // value:源信号的内容
        return [value length] > 3; // 返回值就是过滤条件，只有满足这个条件，才能获取内容
    }] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
}

/** 组合 combineLatest 只有两个文本框都有值时，按钮才可以点击 */
- (void)test24 {
    // textField1、textField2都有值时btn1才可以点击
    [_textField1.rac_textSignal subscribeNext:^(id x) {
        
    }];
    
    [_textField2.rac_textSignal subscribeNext:^(id x) {
        
    }];
    
    // 组合
    // 看到这个协议id<NSFastEnumeration>就传一个数组NSArray
    // reduceBlock参数:与组合的信号有关，--对应
    RACSignal *combineSignal = [RACSignal combineLatest:@[_textField1.rac_textSignal, _textField2.rac_textSignal] reduce:^id(NSString *text1, NSString *text2){
        // block:只要源信号发送内容就会调用，组合成新的值
        
        // 聚合的值就是组合信号的内容
        return @(text1.length && text2.length);
    }];
    
    //    // 订阅组合信号
    //    [combineSignal subscribeNext:^(id x) {
    //        _btn1.enabled = [x boolValue];
    //    }];
    // 给某个对象的某个属性绑定一个信号
    RAC(_btn1, enabled) = combineSignal;
}

/** 压缩信号(只有两个信号同时发送数据时，才会调用) */
- (void)test23 {
    // 创建信号
    RACSubject *subject1 = [RACSubject subject];
    RACSubject *subject2 = [RACSubject subject];
    
    // 压缩
    RACSignal *zipSignal = [subject1 zipWith:subject1];
    
    [zipSignal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    [subject2 sendNext:@"213"];
    [subject1 sendNext:@"333"];
}

/** 组合 merge (任意信号发送数据) */
- (void)test22 {
    // 创建信号
    RACSubject *subject1 = [RACSubject subject];
    RACSubject *subject2 = [RACSubject subject];
    
    // 组合
    RACSignal *mergeSignal = [subject1 merge:subject2];
    
    // 订阅信号
    [mergeSignal subscribeNext:^(id x) {
        // 任意信号发送数据都会来到这个block
        NSLog(@"%@", x);
    }];
    
    // 发送数据
    [subject1 sendNext:@"123"];
    [subject2 sendNext:@"456"];
}

/** 组合 then (忽略第一个信号发送的数据)*/
- (void)test21 {
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"发送第一个请求");
        [subscriber sendNext:@"第一个请求返回数据"];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"清空资源");
        }];
    }];
    
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"发送第二个请求");
        [subscriber sendNext:@"第二个请求返回数据"];
        return nil;
    }];
    
    // 创建组合信号, 需要调用第一个信号的sendCompleted才会执行第二个信号，且第一个信号发送的数据将不再可用
    RACSignal *thenSignal =[signal1 then:^RACSignal *{ // 返回的信号就是需要组合的信息
        return signal2;
    }];
    
    // 订阅信号
    [thenSignal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
}

/** 组合 concat */
- (void)test20 {
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"发送第一个请求");
        [subscriber sendNext:@"第一个请求返回数据"];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"清空资源");
        }];
    }];
    
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"发送第二个请求");
        [subscriber sendNext:@"第二个请求返回数据"];
        return nil;
    }];
    
    // concat:按顺序去连接组合，返回一个新的组合信号,第一个信号发送数据后必须调用[subscriber sendCompleted];
    RACSignal *signals = [signal1 concat:signal2];
    
    // 订阅组合信号
    [signals subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
}

/** map */
- (void)test19 {
    // 创建信号
    RACSubject *subject = [RACSubject subject];
    
    // 绑定信号
    RACSignal *bindSignal = [subject map:^id(id value) {
        // 返回的类型就是你需要映射的值
        return [NSString stringWithFormat:@"改变的值%@", value];
    }];
    
    // 订阅信号
    [bindSignal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    // 发送数据
    [subject sendNext:@"321"];
}

/** flattenMap 用于信号中的信号 */
- (void)test18 {
    // flattenMap
    // 创建信号
    RACSubject *subject = [RACSubject subject];
    
    // 绑定信号
    RACSignal *bindSignal = [subject flattenMap:^RACStream *(id value) {
        // value:源信号发送的内容
        // 返回的信号就是需要包装的值
        NSLog(@"%@", value);
        value = [NSString stringWithFormat:@"新的值:%@", value];
        return [RACReturnSignal return:value];
    }];
    
    // 订阅信号
    [bindSignal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    // 发送数据
    [subject sendNext:@000];
}

/** 绑定信号 */
- (void)test17 {
    // 1.创建信号
    RACSubject *subject = [RACSubject subject];
    
    // 2.绑定信号
    RACSignal *bindSignal = [subject bind:^RACStreamBindBlock{
        // 只要信号源发送数据就会调用block
        // block的作用:处理源信号内容
        // value:源信号发送的内容
        
        return ^RACSignal *(id value, BOOL *stop) {
            NSLog(@"接收到的源信号内容:%@", value);
            
            value = [NSString stringWithFormat:@"新的信号数据%@", value];
            // 返回信号，不能传nil.返回空信号[RACSignal empty];
            return [RACReturnSignal return:value]; // 把value包装成一个信号返回去
        };
    }];
    
    // 3.订阅绑定信号
    [bindSignal subscribeNext:^(id x) {
        NSLog(@"接收到的绑定信号处理完的信号:%@", x);
    }];
    
    // 4.发送数据
    [subject sendNext:@123];
}

/** 获取信号中的最新信号 */
- (void)test16 {
    //switchToLatest:获取信号中的最新信号
    RACSubject *subject1 = [RACSubject subject];
    RACSubject *subject2 = [RACSubject subject];
    
    //    [subject2 subscribeNext:^(id x) {
    //        [x subscribeNext:^(id x) {
    //            NSLog(@"%@", x);
    //        }];
    //    }];
    [subject2.switchToLatest subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    [subject2 sendNext:subject1];
    [subject1 sendNext:@1];
}

/** RACCommand处理事件，不能返回一个空的信号 */
- (void)test15 {
    // RACCommand处理事件，不能返回一个空的信号,当命令内部发送数据完成，一定要主动发送完成
    // 1.创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        // input:执行命令传入参数
        // Block调用:执行命令的时候就会调用
        NSLog(@"%@", input);
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            // 发送数据
            [subscriber sendNext:@"执行命令产生的数据"];
            
            // 发送完成
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    // 方式2,executionSignals:信号源，信号中信号，发送数据就是信号
    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
        
        NSLog(@"%@", x);
    }];
    
    // 监听事件是否完成
    [[command executing] subscribeNext:^(id x) {
        if ([x boolValue]) { // 正在执行完成
            NSLog(@"完成");
        } else {
            NSLog(@"执行完成或没有执行");
        }
    }];
    
    // 2.执行命令
    RACSignal *signal = [command execute:@1];
    
    // 订阅命令内部的信号
    // 方式1
    //    [signal subscribeNext:^(id x) {
    //        NSLog(@"%@", x);
    //    }];
}

/** 避免多次创建信号中的block而产生副作用 */
- (void)test14 {
    // RACMulticastConnection避免多次创建信号中的block而产生副作用(必要有信号才能创建)
    // 1.创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"发送请求");
        [subscriber sendNext:@"数据"];
        return nil;
    }];
    
    // 2.将信号转换成连接类
    //RACMulticastConnection *connection = [signal publish];
    RACMulticastConnection *connection = [signal multicast:[RACReplaySubject subject]];
    
    // 3.订阅连接类的信号
    [[connection signal] subscribeNext:^(id x) {
        NSLog(@"1%@", x);
    }];
    
    [[connection signal] subscribeNext:^(id x) {
        NSLog(@"2%@", x);
    }];
    
    // 4.连接
    [connection connect];
}

/** 开发中常用的宏 */
- (void)test13 {
    // 监听文本框内容 RAC(TARGET, ...)
    [_textField.rac_textSignal subscribeNext:^(id x) {
        _textLabel.text = x;
    }];
    // 用来给某个对象的某个属性绑定信号，只要产生信号内容，就会把内容给对象的属性赋值
     RAC(self.textLabel, text) = _textField.rac_textSignal;
    
    // 监听对象属性值发生改变 RACObserve(TARGET, KEYPATH)
    [[self.view rac_valuesAndChangesForKeyPath:@"frame" options:NSKeyValueObservingOptionNew observer:self] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    // 这要这个对象的该属性的值发生改变就会产生信号
    [RACObserve(self.view, frame) subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];

    // 循环引用 @weakify(...) @strongify(...)
    
    // 包装元组 RACTuplePack(...)
    RACTuple *tuple = RACTuplePack(@1, @2);
    NSLog(@"%@", tuple[1]);
    
    // RACTupleUnpack:用来解析元组,里面的参数传需要解析的变量名
    RACTuple *tuple1 = RACTuplePack(@"年龄", @25);
    RACTupleUnpack(NSString *name1, NSNumber *name2) = tuple1;
    NSLog(@"%@---%@", name1, name2);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //self.view.frame = CGRectMake(0, 0, 300, 200);
}

- (void)requestFinishedFirst:(NSString *)firstSignal second:(NSString *)secondSignal {
    NSLog(@"%@---%@", firstSignal, secondSignal);
}

/** RAC多个请求 */
- (void)test12 {
    // 请求第一个模块
    RACSignal *firstSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"第一个信号请求完");
        
        [subscriber sendNext:@"传递第一个模块"];
        return [RACDisposable disposableWithBlock:^{
            nil;
        }];
    }];
    
    RACSignal *secondSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"第二个信号请求完");
        
        [subscriber sendNext:@"传递第二个模块"];
        return [RACDisposable disposableWithBlock:^{
            nil;
        }];
    }];
    
    // 当一个界面有多个请求时，需要保证全部请求完成后才搭建界面
    // 数组：存放信号，当数组中的所有信号都发送完数据的时候才会执行方法
    // 方法的参数：必须跟数组的信号一一对应,就是每个信号发送的数据
    [self rac_liftSelector:@selector(requestFinishedFirst:second:) withSignalsFromArray:@[firstSignal, secondSignal]];
}

/** RAC通知 */
- (void)test11 {
    // RAC通知
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UITextFieldTextDidBeginEditingNotification object:self.textField] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
}

/** 监听按钮的点击 */
- (void)test10 {
    // 监听按钮的点击
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.frame = CGRectMake(0, 0, 50, 50);
    _btn.backgroundColor = [UIColor darkTextColor];
    [self.view addSubview:_btn];
    [[_btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
        NSLog(@"%f", x.frame.size.width);
    }];
}

/** RAC代替KVO */
- (void)test9 {
    // 方法1
    [_redView rac_observeKeyPath:@"frame" options:NSKeyValueObservingOptionNew observer:nil block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        NSLog(@"%@", value);
    }];
    
    // 方法2
    [[_redView rac_valuesForKeyPath:@"frame" observer:nil] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
}

/** 字典转模型 */
- (void)test8 {
    // 字典转模型
    NSString *path = [[NSBundle mainBundle] pathForResource:@"flags.plist" ofType:nil];
    NSArray *dictArr = [NSArray arrayWithContentsOfFile:path];
    
    //    NSMutableArray *arr = [NSMutableArray array];
    //    [dictArr.rac_sequence.signal subscribeNext:^(NSDictionary *x) {
    //        JMFlag *flag = [JMFlag flagWithDict:x];
    //        [arr addObject:flag];
    //    }];
    
    // 高级用法(映射会把集合中所有元素都映射成一个新的对象)
    NSArray *flags = [[dictArr.rac_sequence map:^id(NSDictionary *value) {
        // value:集合中元素, id:返回对象就是映射的值
        return [JMFlag flagWithDict:value];
    }] array];
    NSLog(@"%@", flags);
}

/** 快速遍历数组或字典 */
- (void)test7 {
    // RACSequence RAC集合(用来快速遍历OC中的NSArray、NSDictionary)
    NSArray *arr = @[@"123", @"321", @"456"];
    //    RACSequence *sequence = arr.rac_sequence;
    //    // 把集合转成信号
    //    RACSignal *signal = sequence.signal;
    //
    //    // 订阅集合信号,内部会自动遍历所有的元素
    //    [signal subscribeNext:^(id x) {
    //        NSLog(@"%@", x);
    //    }];
    
    // 开发中常用下面这种写法
    [arr.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    // 快速遍历字典
    NSDictionary *dict = @{@"account":@"aaa", @"name":@"xiao"};
    [dict.rac_sequence.signal subscribeNext:^(RACTuple *x) {
        //        NSString *key = x[0];
        //        NSString *value = x[1];
        //        NSLog(@"%@---%@", key, value);
        
        // RACTupleUnpack:用来解析元组,里面的参数传需要解析的变量名
        RACTupleUnpack(NSString *key, NSString *value) = x;
        NSLog(@"%@---%@", key, value);
    }];

}

/** 元组 */
- (void)test6 {
    // 元组(类似OC的NSArray)
    RACTuple *tuple = [RACTuple tupleWithObjects:@"123", @"456", @"987", nil];
    NSString *string = tuple[1];
    NSLog(@"%@", string);
}

// RAC替代代理
- (void)test5 {
    // 订阅信号 RACSubject替代代理, 需要传值
    [_redView.btnClickSignal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    // rac_signalForSelector监听某个对象是否调用了某个方法,不需要传值
    [[_redView rac_signalForSelector:@selector(btnClick:)] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];;
}

- (void)test4 {
    // 1.创建信号(RACReplaySubject可以先发送数据，再订阅信号)
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    
    // 3.发送数据(保存值，遍历所有的订阅者，发送数据)
    [replaySubject sendNext:@"222"];
    
    // 2.订阅信号(遍历所有的值，拿到当前订阅者去发送数据)
    [replaySubject subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
}

- (void)test3 {
    // 1.创建信号
    RACSubject *subject = [RACSubject subject];
    
    // 2.订阅信号
    [subject subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    [subject subscribeNext:^(id x) {
        NSLog(@"第二个订阅");
    }];
    
    // 3.发送信号
    [subject sendNext:@132];
}

- (void)test2 {
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        _subscriber = subscriber;
        // 发送数据(默认一个信号数据发送完毕就会主动取消订阅,只要订阅者还在，就不会取消订阅)
        [subscriber sendNext:@"123"];
        
        return [RACDisposable disposableWithBlock:^{
            // 只要信号取消订阅就会来到这，清空资源
            NSLog(@"信号被取消了");
        }];
    }];
    
    // 订阅信号
    RACDisposable *disposable = [signal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    // 取消订阅
    [disposable dispose];
}

- (void)test1 {
    // 1.创建信号（默认为冷信号，只有被订阅了才会成为热信号）
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // 3.发送数据
        [subscriber sendNext:@1];
        
        return nil;
    }];
    
    // 2.订阅信号
    [signal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
