//
//  RegNextTableViewCell.m
//  kreditbro
//
//  Created by 戴培琼 on 2019/3/24.
//  Copyright © 2019 lai. All rights reserved.
//

#import "RegNextTableViewCell.h"
#import <KRCommonUIComponents/CustomTextField.h>
#import <KRCommonUIComponents/JXLRPopTipView.h>
#import <KRCommonComponents/NSString+UserInfo.h>
#import "UserInfo.h"
#import <KRCommonComponents/Macros.h>
#import <KRCommonComponents/ColorTools.h>
#import <KRCommonUIComponents/KRProgressHud.h>
#import <KRNetworkManager/NSString+encryptDES.h>
#import <KRNetworkManager/KRNetworkConfig.h>
#import <KRCommonComponents/DAConfig.h>
#import <KRNetworkManager/KRRequestManager.h>
#import <KRCommonComponents/AppDefaultUtil.h>
#import <KRCommonComponents/KRNotificationConstant.h>

#define RegNextTableViewCellLeftSpace 20
#define RegNextTableViewCellWidth (MSWIDTH-40)

@interface RegNextTableViewCell()<UITextFieldDelegate>
{
    BOOL isAgree;
    NSInteger _typeNum;
    NSInteger _isInit;
    
}
@property (nonatomic, strong) JXLRPopTipView *tipView;
@property (nonatomic, strong) CustomTextField *verifyWindow;
@property (nonatomic, strong) CustomTextField *pwd1Window;
@property (nonatomic, strong) CustomTextField *pwd2Window;
@property (nonatomic, strong) CustomTextField *nickNameWindow;
@property (nonatomic, strong) CustomTextField *recWindow;
@property (nonatomic, strong) UIButton *verifyBtn;
@property (nonatomic, strong)  UILabel *lbl1;


@end
@implementation RegNextTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self createView];
        [self initData];
        self.accessoryType = UITableViewCellAccessoryNone;
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    return self;
}

- (void)initData
{
    _isInit = 1;
    isAgree = YES;
}

- (void)createView {
    UIControl *viewControl = [[UIControl alloc] initWithFrame:self.bounds];
    [viewControl addTarget:self action:@selector(ControlAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:viewControl];
    
    
    // 昵称必填
    _nickNameWindow = [[CustomTextField alloc] initWithFrame:CGRectMake(RegNextTableViewCellLeftSpace, 25, RegNextTableViewCellWidth, 60)];
    [_nickNameWindow setLeftImage:@"icon_nick" rightImage:@"" placeName:NSLocalizedString(@"tv_register_nickName", nil)];
    _nickNameWindow.clearButtonMode = UITextFieldViewModeWhileEditing;
    _nickNameWindow.delegate = self;
    [self.contentView addSubview:_nickNameWindow];
    
    // 请设置登录密码不少于6位
    _pwd1Window = [[CustomTextField alloc] initWithFrame:CGRectMake(RegNextTableViewCellLeftSpace, CGRectGetMaxY(_nickNameWindow.frame) + 15, RegNextTableViewCellWidth, 60)];
    [_pwd1Window setLeftImage:@"login_pwd" rightImage:@"" placeName:NSLocalizedString(@"tv_password_hint", nil)];
    _pwd1Window.clearButtonMode = UITextFieldViewModeWhileEditing;
    _pwd1Window.delegate = self;
    _pwd1Window.secureTextEntry = YES;
    _pwd1Window.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [self.contentView addSubview:_pwd1Window];
    
    // 请再次输入密码
    _pwd2Window = [[CustomTextField alloc] initWithFrame:CGRectMake(RegNextTableViewCellLeftSpace, CGRectGetMaxY(_pwd1Window.frame) + 15, RegNextTableViewCellWidth, 60)];
    [_pwd2Window setLeftImage:@"login_pwd" rightImage:@"" placeName:NSLocalizedString(@"tv_confirm_password", nil)];
    _pwd2Window.clearButtonMode = UITextFieldViewModeWhileEditing;
    _pwd2Window.delegate = self;
    _pwd2Window.secureTextEntry = YES;
    [self.contentView addSubview:_pwd2Window];
    
    //  邀请码
    _recWindow = [[CustomTextField alloc] initWithFrame:CGRectMake(RegNextTableViewCellLeftSpace, CGRectGetMaxY(_pwd2Window.frame) + 15, RegNextTableViewCellWidth, 60)];
    [_recWindow setLeftImage:@"rec" rightImage:@"" placeName:NSLocalizedString(@"tv_hint_tuijian", nil)];
    _recWindow.clearButtonMode = UITextFieldViewModeWhileEditing;
    _recWindow.delegate = self;
    [self.contentView addSubview:_recWindow];
    
    //用户注册协议
    UIButton *agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];//button的类型
    agreeBtn.frame =CGRectMake(10, CGRectGetMaxY(_recWindow.frame) + 20, 120, 30);//button的frame
    agreeBtn.selected = YES;
    [agreeBtn setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];//给button添加image
    [agreeBtn setImage:[UIImage imageNamed:@"check"] forState:UIControlStateSelected];//给button添加image
    agreeBtn.imageEdgeInsets = UIEdgeInsetsMake(22,15,22,40);
    [agreeBtn setTitle:NSLocalizedString(@"tv_I_agree", nil) forState:UIControlStateNormal];
    agreeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    agreeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [agreeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    agreeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -agreeBtn.titleLabel.bounds.size.width, 0, 0);
    [agreeBtn addTarget:self action:@selector(agreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:agreeBtn];
    
    UIButton  *proBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    proBtn.frame = CGRectMake(CGRectGetMaxX(agreeBtn.frame) - 10, CGRectGetMaxY(_recWindow.frame) + 20, 180, 30);
    proBtn.backgroundColor = [UIColor clearColor];
    proBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [proBtn setTitleColor:KBlueColor forState:UIControlStateNormal];
    [proBtn setTitle:NSLocalizedString(@"tv_user_license",nil) forState:UIControlStateNormal];
    [proBtn addTarget:self action:@selector(proBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:proBtn];
    
    UIButton  *regBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    regBtn.frame = CGRectMake(RegNextTableViewCellLeftSpace, CGRectGetMaxY(proBtn.frame)+25, RegNextTableViewCellWidth, 45);
    regBtn.backgroundColor = KRedColor;
    regBtn.layer.cornerRadius = 3.0;
    regBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [regBtn setTitle:NSLocalizedString(@"tv_register", nil) forState:UIControlStateNormal];
    [regBtn addTarget:self action:@selector(regBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:regBtn];
    
    UILabel *lbl3 = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(regBtn.frame), MSWIDTH-40, 40)];
    lbl3.textAlignment = NSTextAlignmentCenter;
    lbl3.textColor = [UIColor grayColor];
    lbl3.font = [UIFont systemFontOfSize:16];
    //    lbl1.backgroundColor = [UIColor brownColor];
    lbl3.numberOfLines = 0;
    lbl3.text = @"客服电话：400-915-1000";
//    [self.contentView addSubview:lbl3];
    
    
}

- (void)setPhone:(NSString *)phone {
    _phone = phone;
    if (self.phone) {
        NSMutableString *str1 = [NSMutableString stringWithFormat:@"%@",self.phone];
        [str1 replaceCharactersInRange:NSMakeRange(4, 4) withString:@"****"];
        self.lbl1.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"verify_code_send_to", nil), str1];
    }
    
}

- (void)proBtnClick {
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITextField *textField in [self.contentView subviews]) {
        
        if ([textField isKindOfClass: [UITextField class]]) {
            
            [textField  resignFirstResponder];
        }
    }
    
}

#pragma mark 点击空白处收回键盘
- (void)ControlAction {
    [self hideEnterKeyboard];
}

- (void)hideEnterKeyboard {
    for (UITextField *textField in [self.contentView subviews]) {
        
        if ([textField isKindOfClass: [UITextField class]]) {
            
            [textField  resignFirstResponder];
        }
    }
    
}


#pragma mark - 注册
- (void)regBtnClick {
    if (_nickNameWindow.text.length == 0 ) {
        [KRProgressHud showErrorWithStatus:NSLocalizedString(@"tip_register_input_nickName", nil)];
        return;
    }
    
    if (self.verifyCode.length == 0 ) {
        [KRProgressHud showErrorWithStatus:NSLocalizedString(@"tips_input_verify_code", nil)];
        return;
        
    }
    if (_pwd1Window.text.length == 0 ) {
        [KRProgressHud showErrorWithStatus:NSLocalizedString(@"please_input_your_pwd", nil)];
        return;
    }
    if (_pwd2Window.text.length == 0 ) {
        [KRProgressHud showErrorWithStatus:NSLocalizedString(@"tv_confirm_password_hint", nil)];
        return;
    }
  
    if (self.inviteCodeStatus == 1 && _recWindow.text.length == 0) {
        [KRProgressHud showErrorWithStatus:@"请输入邀请码！"];
        return;
    }
    if (!isAgree) {
        [KRProgressHud showErrorWithStatus:KRLANGGECE(@"tips_agree_license")];
        return;
    }
    
    _typeNum = 1;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *password1 = [NSString encrypt3DES:_pwd1Window.text key:DESkey];
    [parameters setObject:@"2" forKey:@"OPT"];
    [parameters setObject:[[DAConfig userLanguage] substringToIndex:2] forKey:@"language"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:self.name forKey:@"name"];
    [parameters setObject:password1 forKey:@"pwd"];
    [parameters setObject:self.phone forKey:@"cellPhone"];
    [parameters setObject:self.verifyCode forKey:@"code"];
    [parameters setObject:_nickNameWindow.text forKey:@"nick"];
    
    if (_recWindow.text.length == 0) {
        [parameters setObject:@"" forKey:@"referrerName"];
    }else
    {
        [parameters setObject:_recWindow.text forKey:@"referrerName"];
    }
    
    [KRRequestManager sendRequestWithRequestMethodType:RequestGET requestAPICode:@"app/services" requestParameters:parameters requestHeader:nil success:^(id  _Nonnull responseObject) {
        NSDictionary *dics = responseObject;
           
           if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
               
               if (_typeNum == 1) {
                   
                   DLOG(@"注册成功  obj -> %@",dics);
                   
                   [[AppDefaultUtil sharedInstance] setDefaultUserName:self.name];// 保存用户账号
                   [[AppDefaultUtil sharedInstance] setDefaultUserPassword:_pwd1Window.text];
                   [[AppDefaultUtil sharedInstance] setDefaultUserCellPhone:self.phone];// 保存手机号
                   
                   UserInfo *usermodel = [[UserInfo alloc] init];
                   usermodel.userId = [NSString stringWithFormat:@"%@",[dics objectForKey:@"id"]];
                   usermodel.userPwd = _pwd1Window.text;
                   usermodel.userName = self.name;
                   usermodel.isLogin = @"1";
                   usermodel.deviceType = @"ios";
                   usermodel.nickName = _nickNameWindow.text;
//                   AppDelegateInstance.userInfo = usermodel;
                   
                   [[AppDefaultUtil sharedInstance] setNickName:usermodel.nickName];// 保存用户昵称
                   [[AppDefaultUtil sharedInstance] setDefaultUserName:usermodel.userName];
                   [[AppDefaultUtil sharedInstance] setDefaultAccount:self.name];// 保存用户账号
                   [[AppDefaultUtil sharedInstance] setDefaultUserNoPassword:_pwd1Window.text];// 保存用户密码（未加密）
                   NSString *pwdStr = [NSString encrypt3DES:_pwd1Window.text key:DESkey];//用户密码3Des加密
                   [[AppDefaultUtil sharedInstance] setDefaultUserPassword:pwdStr];// 保存用户密码（des加密）
                   [[AppDefaultUtil sharedInstance] setDefaultHeaderImageUrl:usermodel.userImg];// 保存用户头像
                   [[AppDefaultUtil sharedInstance] setdeviceType:usermodel.deviceType];// 保存设备型号
                   [[AppDefaultUtil sharedInstance] setDefaultUserId:usermodel.userId];// 保存设备型号
                   [[AppDefaultUtil sharedInstance] setDefaultIsLogin:usermodel.isLogin.boolValue ];// 保存登陆状态
                 
                   [KRProgressHud showSuccessWithStatus:@"恭喜您注册成功！"];
                   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * 600000000ull)), dispatch_get_main_queue(), ^{
                       [[NSNotificationCenter defaultCenter] postNotificationName:MAIN_REGISTER_SUCCESS object:nil];
//                       [AppDelegateInstance toDeckVC];
                   });
                   
               }else {
               };
               
           }else {
               DLOG(@"返回失败  msg -> %@",[dics objectForKey:@"msg"]);
               
               [KRProgressHud showErrorWithStatus:[dics objectForKey:@"msg"]];
           }
    } faild:^(NSError * _Nonnull error) {
        [KRProgressHud showErrorWithStatus:NSLocalizedString(@"server_maintenance", nil)];
    }];
    
    
//    if (_requestClient == nil) {
//        _requestClient = [[NetWorkClient alloc] init];
//        _requestClient.delegate = self;
//    }
//    [_requestClient requestGet:@"app/services" withParameters:parameters];
//
}

#pragma mark - 同意协议
- (void)agreeBtnClick:(UIButton *)button
{
    if (button.selected == YES) {
        button.selected = NO;
        isAgree = NO;
        
    }else {
        button.selected = YES;
        isAgree = YES;
        
    }
}

#pragma mark - 网络数据回调代理
//-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
//{
//
//    NSDictionary *dics = obj;
//
//    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
//
//        if (_typeNum == 1) {
//
//            DLOG(@"注册成功  obj -> %@",obj);
//
//            [[AppDefaultUtil sharedInstance] setDefaultUserName:self.name];// 保存用户账号
//            [[AppDefaultUtil sharedInstance] setDefaultUserPassword:_pwd1Window.text];
//            [[AppDefaultUtil sharedInstance] setDefaultUserCellPhone:self.phone];// 保存手机号
//
//            UserInfo *usermodel = [[UserInfo alloc] init];
//            usermodel.userId = [NSString stringWithFormat:@"%@",[obj objectForKey:@"id"]];
//            usermodel.userPwd = _pwd1Window.text;
//            usermodel.userName = self.name;
//            usermodel.isLogin = @"1";
//            usermodel.deviceType = @"ios";
//            usermodel.nickName = _nickNameWindow.text;
//            AppDelegateInstance.userInfo = usermodel;
//
//            [[AppDefaultUtil sharedInstance] setNickName:AppDelegateInstance.userInfo.nickName];// 保存用户昵称
//            [[AppDefaultUtil sharedInstance] setDefaultUserName:AppDelegateInstance.userInfo.userName];
//            [[AppDefaultUtil sharedInstance] setDefaultAccount:self.name];// 保存用户账号
//            [[AppDefaultUtil sharedInstance] setDefaultUserNoPassword:_pwd1Window.text];// 保存用户密码（未加密）
//            NSString *pwdStr = [NSString encrypt3DES:_pwd1Window.text key:DESkey];//用户密码3Des加密
//            [[AppDefaultUtil sharedInstance] setDefaultUserPassword:pwdStr];// 保存用户密码（des加密）
//            [[AppDefaultUtil sharedInstance] setDefaultHeaderImageUrl:AppDelegateInstance.userInfo.userImg];// 保存用户头像
//            [[AppDefaultUtil sharedInstance] setdeviceType:AppDelegateInstance.userInfo.deviceType];// 保存设备型号
//            [[AppDefaultUtil sharedInstance] setDefaultUserId:AppDelegateInstance.userInfo.userId];// 保存设备型号
//            [[AppDefaultUtil sharedInstance] setDefaultIsLogin:AppDelegateInstance.userInfo.isLogin.boolValue ];// 保存登陆状态
//
//            [SVProgressHUD showSuccessWithStatus:@"恭喜您注册成功！"];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * 600000000ull)), dispatch_get_main_queue(), ^{
//                [[NSNotificationCenter defaultCenter] postNotificationName:MAIN_REGISTER_SUCCESS object:nil];
//                [AppDelegateInstance toDeckVC];
//            });
//
//        }else {
//        };
//
//    }else {
//        DLOG(@"返回失败  msg -> %@",[obj objectForKey:@"msg"]);
//
//        [KRProgressHud showErrorWithStatus:[obj objectForKey:@"msg"]];
//    }
//}

//// 返回失败
//-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
//{
//    // 服务器返回数据异常
//    //    [KRProgressHud showErrorWithStatus:NSLocalizedString(@"server_maintenance", nil)];
//}

// 无可用的网络
-(void) networkError {
    [KRProgressHud showErrorWithStatus:NSLocalizedString(@"toast_check_network", nil)];
}

- (UIViewController *)appRootViewController {
    UIViewController *RootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *topVC = RootVC;
    
    while (topVC.presentedViewController) {
        
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

- (void)setInviteCodeStatus:(NSInteger)inviteCodeStatus {
    _inviteCodeStatus = inviteCodeStatus;
    switch (_inviteCodeStatus) {
        case 0:
        {
            self.recWindow.hidden = YES;
        }
            break;
        case 1:
        {
            self.recWindow.hidden = NO;
            self.recWindow.placeName = NSLocalizedString(@"tips_invite_code", nil);
            
        }
            break;
        case 2:
        {
            self.recWindow.hidden = NO;
            self.recWindow.placeName = @"请输入推荐人邀请码（选填）";
        }
            break;
        default:
            break;
    }
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
