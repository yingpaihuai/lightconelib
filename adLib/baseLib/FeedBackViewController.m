//
//  FeedBackViewController.m
//
//  Created by CloudCity on 15/5/18.
//  Copyright (c) 2015年 CloudCity. All rights reserved.
//

#import "FeedBackViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
@interface FeedBackViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *emailBtn;
@property (weak, nonatomic) IBOutlet UITextField *emailTxt;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    self.emailAddress = @"gzyappservice@gmail.com";
    UIActivityIndicatorView *loadingBar = [[UIActivityIndicatorView alloc]init];
    loadingBar.center = self.view.center;
    [self.view addSubview:loadingBar];
    [loadingBar startAnimating];
    self.textView.delegate = self;
    self.textView.text = @"Your feedback will help us make improvements!";
    self.textView.textColor = [UIColor lightGrayColor]; //optional
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:self.emailAddress];
    NSRange contentRange = {0,[content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    [_emailBtn setAttributedTitle:content forState:UIControlStateNormal];
    self.submitBtn.backgroundColor =  UIColorFromRGB(0x0089E3);
    [self.submitBtn setBackgroundImage:[UIImage imageNamed:@"bt_tap2.png"] forState:UIControlStateHighlighted];
    self.submitBtn.adjustsImageWhenHighlighted = NO;
    self.emailTxt.placeholder = @"your email(optional)";
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, self.emailTxt.frame.size.height)];
    self.emailTxt.leftView = paddingView;
    self.emailTxt.leftViewMode = UITextFieldViewModeAlways;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Your feedback will help us make improvements!"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Your feedback will help us make improvements!";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    self.screenName = @"FeedBack";
    [super viewWillAppear:animated];
}

- (IBAction)pressBack:(UIButton *)sender {
    if(self.navigationController){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (IBAction)onPressSubmit:(id)sender{
    NSString *account = @"";
    NSString *feedbackContent = @"";
    if(![self.textView.text  isEqual: @"Your feedback will help us make improvements!"]){
        feedbackContent = self.textView.text;
    }
    
    if(![self.emailTxt.text isEqual:@"your email(optional)"]){
        account = self.emailTxt.text;
    }
    NSString *brand = @"APPLE";
    NSString *model = [[UIDevice currentDevice] model];
    NSString *sdkInt = [[UIDevice currentDevice] systemVersion];
    NSString *versionRelease = [[UIDevice currentDevice] systemVersion];;
    NSString *appName = self.appName;
    
    NSString *strName = [[UIDevice currentDevice] name];
    NSLog(@"设备名称：%@", strName);//e.g. "My iPhone"
    
    NSString *strSysName = [[UIDevice currentDevice] systemName];
    NSLog(@"系统名称：%@", strSysName);// e.g. @"iOS"
    
    NSString *strSysVersion = [[UIDevice currentDevice] systemVersion];
    NSLog(@"系统版本号：%@", strSysVersion);// e.g. @"4.0"
    
    NSString *strModel = [[UIDevice currentDevice] model];
    NSLog(@"设备模式：%@", strModel);// e.g. @"iPhone", @"iPod touch"
    
    NSString *strLocModel = [[UIDevice currentDevice] localizedModel];
    NSLog(@"本地设备模式：%@", strLocModel);// localized version of model //地方型号  （国际化区域名称）
    
    NSString* phoneModel = [[UIDevice currentDevice] model];
    NSLog(@"手机型号: %@",phoneModel );   //手机型号
    
    
    //第一步，创建url
    NSURL *url = [NSURL URLWithString:@"http://www.guangzhuiyuan.com/feedbackserver/feedback.jsp"];
    //第二步，创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str = [NSString stringWithFormat:@"account=%@&content=%@&brand=%@&model=%@&sdkInt=%@&versionRelease=%@&appName=%@",account,feedbackContent,brand,model,sdkInt,versionRelease,appName] ;
    NSLog(@"%@",str);
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    //第三步，连接服务器
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
}

//接收到服务器回应的时候调用此方法
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
    NSLog(@"%@",[res allHeaderFields]);
    
}
//接收到服务器传输数据的时候调用，此方法根据数据大小执行若干次
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //    [self.receiveData appendData:data];
}
//数据传完之后调用此方法
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //    NSString *receiveStr = [[NSString alloc]initWithData:self.receiveData encoding:NSUTF8StringEncoding];
    NSLog(@"over");
    UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"FeedBack" message:@"Successful" delegate:self cancelButtonTitle:@"I know" otherButtonTitles:nil, nil];
    [view show];
}
//网络请求过程中，出现任何错误（断网，连接超时等）会进入此方法
-(void)connection:(NSURLConnection *)connection
 didFailWithError:(NSError *)error
{
    NSLog(@"%@",[error localizedDescription]);
    UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"FeedBack" message:@"Failed" delegate:self cancelButtonTitle:@"I know" otherButtonTitles:nil, nil];
    [view show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)endEditEmail:(UITextField *)sender {
    [sender resignFirstResponder];
}

- (IBAction)onTouch:(UIControl *)sender {
    [self.view endEditing:YES];
}

- (void)sendEmail
{
    MFMailComposeViewController *sendMailViewController = [[MFMailComposeViewController alloc] init];
    sendMailViewController.mailComposeDelegate = self;
    if([MFMailComposeViewController canSendMail]){
        // 设置邮件主题
        [sendMailViewController setSubject: [NSString stringWithFormat:@"Feedback for %@",self.appName]];
        
        /*
         * 设置收件人，收件人有三种
         */
        // 设置主收件人
        [sendMailViewController setToRecipients:[NSArray arrayWithObject:self.emailAddress]];
        //    // 设置CC
        //    [sendMailViewController setCcRecipients:[NSArray arrayWithObject:@"example@hotmail.com"]];
        //    // 设置BCC
        //    [sendMailViewController setBccRecipients:[NSArray arrayWithObject:@"example@gmail.com"]];
        //
        /*
         * 设置邮件主体，有两种格式
         */
        // 一种是纯文本
        [sendMailViewController setMessageBody:@"" isHTML:NO];
        // 一种是HTML格式（HTML和纯文本两种格式按需求选择一种即可）
        //[mailVC setMessageBody:@"<HTML><B>Hello World!</B><BR/>Is everything OK?</HTML>" isHTML:YES];
        
        // 添加附件
        //    NSString *path = [[NSBundle mainBundle] pathForResource:@"feedback" ofType:@"png"];
        //    NSData *data = [NSData dataWithContentsOfFile:path];
        //    [sendMailViewController addAttachmentData:data mimeType:@"image/png" fileName:@"feedback"];
        
        // 视图呈现
        [self presentViewController:sendMailViewController animated:YES completion:nil];
    }else{
        NSLog(@"can't send mail");
    }
    
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultCancelled: {
            NSLog(@"Mail send canceled.");
            break;
        }
        case MFMailComposeResultSaved: {
            NSLog(@"Mail saved.");
            break;
        }
        case MFMailComposeResultSent: {
            NSLog(@"Mail sent.");
            break;
        }
        case MFMailComposeResultFailed: {
            NSLog(@"Mail sent Failed.");
            break;
        }
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)sendEmailBtnPressed:(id)sender
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        if ([mailClass canSendMail])
        {
            [self sendEmail];   // 调用发送邮件的方法
        }
        else {
            [self launchMailAppOnDevice];   // 调用客户端邮件程序
        }
    }
    else {
        [self launchMailAppOnDevice];    // 调用客户端邮件程序
    }
    
}

-(void)launchMailAppOnDevice
{
    //@"mailto:first@example.com?cc=second@example.com,third@example.com&subject=my email!";
    NSString *recipients =  [NSString stringWithFormat:@"%@&subject=Feedback for %@!",self.emailAddress, self.appName];
    NSString *body = @"&body=Feedback!";
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    email = [email stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:email]];
}
@end
