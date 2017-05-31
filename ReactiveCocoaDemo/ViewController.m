//
//  ViewController.m
//  ReactiveCocoaDemo
//
//  Created by Apple on 2017/5/24.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveCocoa.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;

@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatLoginSingal];
}
- (void)creatLoginSingal {
    RACSignal *numberSignal = [self.numberTextField.rac_textSignal map:^id(NSString *username) {
        NSUInteger length = username.length;
        if (length == 11) {
            return @(YES);
        }
        return @(NO);
    }];
    
    RACSignal *codeSingnal = [self.codeTextField.rac_textSignal map:^id(NSString *code) {
        NSUInteger length = code.length;
        if (length > 0) {
            return @(YES);
        }
        return @(NO);
    }];
    RAC(self.loginButton,enabled) = [RACSignal combineLatest:@[numberSignal,codeSingnal] reduce:^(NSNumber *isnumberCorrect,NSNumber *iscodeCorrect){
        return @(isnumberCorrect.boolValue && iscodeCorrect.boolValue);
    }];
    
    [[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside ] subscribeNext:^(id x) {
        NSLog(@"Go to Login");
    }];
}
- (void)test {
    RACSignal *testSingnal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"test"];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    
    // 2.1 订阅Next信号
    [testSingnal subscribeNext:^(id x) {
        
    }];
    // 2.2 订阅失败信号
    [testSingnal subscribeError:^(NSError *error) {
        
    }];
    // 2.3 订阅成功信号
    [testSingnal subscribeCompleted:^{
        
    }];
    
    [testSingnal bind:^RACStreamBindBlock{
        return nil;
    }];
}

- (void)subject {
    // 先创建一个信号
    RACSubject *subject = [RACSubject subject];
    // 订阅信号
    [subject subscribeNext:^(id x) {
        
    }];
    // 发送信号
    [subject sendNext:@"HELLO"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
