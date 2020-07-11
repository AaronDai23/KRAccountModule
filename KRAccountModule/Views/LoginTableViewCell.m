//
//  LoginTableViewCell.m
//  kreditbro
//
//  Created by 戴培琼 on 2019/3/23.
//  Copyright © 2019 lai. All rights reserved.
//

#import "LoginTableViewCell.h"
#import "ColorTools.h"
#import "LoginWindowTextField.h"
#import "CustomTextField.h"
#import "JXLRPopTipView.h"
#import "RegisterViewController.h"
#import "AppDefaultUtil.h"
#import "Macros.h"
//#import ""
//#import "TabViewController.h"
//#import "KRFindViewController.h"
#import "KRNetworkConfig.h"
#import "DAConfig.h"
#import "KRRequestManager.h"
#import "NSString+encryptDES.h"
#import "UserInfo.h"
#import "KRProgressHud.h"
#import "KRNotificationConstant.h"
#import "QCheckBox.h"

#define loginTableViewCellWidthWind  MSWIDTH - 40

@interface LoginTableViewCell ()
@property (nonatomic, assign) BOOL isLook;
@property (nonatomic, strong) UIButton *signBtn;
@property (nonatomic, strong) UIView *reminderView;
@property (nonatomic, strong) JXLRPopTipView *tipView;
@property (nonatomic, strong) UIButton *registerButton;
@end

@implementation LoginTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self createView];
        self.accessoryType = UITableViewCellAccessoryNone;
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    return self;
}

- (void)createView {
    _isRemember = YES;
    // 用户名的边框
    UIControl *viewControl = [[UIControl alloc] initWithFrame:self.bounds];
    [viewControl addTarget:self action:@selector(ControlAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:viewControl];
    
    // 手机号 输入框
    _phoneWindow = [[CustomTextField alloc] initWithFrame:CGRectMake(20, 30, loginTableViewCellWidthWind, 55)];
    [_phoneWindow setLeftImage:@"Find_phone" rightImage:nil placeName:NSLocalizedString(@"please_input_phone", nil)];
//    _phoneWindow.keyboardType = UIKeyboardTypePhonePad;
    _phoneWindow.delegate = self;
    _phoneWindow.clearButtonMode = UITextFieldViewModeWhileEditing;
    ;
  
    
    // 密码 输入框
    _passWindow = [[CustomTextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_phoneWindow.frame) + 16, loginTableViewCellWidthWind, 55)];
    _passWindow.secureTextEntry = YES;
    if(_phoneWindow.text.length != 0){
        _passWindow.text = [[AppDefaultUtil sharedInstance] getDefaultUserNoPassword];
    }
   [_passWindow setLeftImage:@"login_pwd" rightImage:@"login_pwd_swicthOff" placeName:NSLocalizedString(@"please_input_your_pwd", nil)];
    __weak CustomTextField *weakPassField = _passWindow;
    KRWeakSelf(self);
    [_passWindow setTapActionBlock:^{
        KRStrongSelf(self);
        if (self.isLook) {
            [weakPassField.rightBtn setImage:[UIImage imageNamed:@"login_pwd_swicthOff"]forState:UIControlStateNormal];
            weakPassField.secureTextEntry = YES;
        }else{
            
            [weakPassField.rightBtn setImage:[UIImage imageNamed:@"login_pwd_swicthOn"]forState:UIControlStateNormal];
            weakPassField.secureTextEntry = NO;
        }
        self.isLook = !self.isLook;
    }];
    
    [self.contentView addSubview:_phoneWindow];
    [self.contentView addSubview:_passWindow];
    
    
    //记住密码
    UIButton *rememberPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];//button的类型
    //    rememberPwdBtn.backgroundColor = [UIColor brownColor];
    //    rememberPwdBtn.frame =CGRectMake(0, 175, 120, 30);//button的frame
    rememberPwdBtn.frame =CGRectMake(30, CGRectGetMaxY(_passWindow.frame) + 15, 160, 30);//button的frame
     NSBundle *mainBundle = [NSBundle bundleForClass:NSClassFromString(@"QCheckBox")];
    
    NSLog(@"path:%@",mainBundle.bundlePath);
//        NSBundle *resourcesBundle = [NSBundle bundleWithPath:[mainBundle pathForResource:@"CheckBox" ofType:@"bundle"]];
    NSString *path = [mainBundle pathForResource:@"checkbox1_checked.png" ofType:nil inDirectory:@"CheckBox.bundle"];
    

    [rememberPwdBtn setImage: [UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
    [rememberPwdBtn setImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateSelected];
    rememberPwdBtn.imageEdgeInsets = UIEdgeInsetsMake(22,-20,22,40);
    [rememberPwdBtn setTitle:@"sss" forState:UIControlStateNormal];
    rememberPwdBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    rememberPwdBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [rememberPwdBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    NSLog(@"= %f = ",rememberPwdBtn.titleLabel.bounds.size.width);
    //    NSLog(@"= %f = ",rememberPwdBtn.titleLabel.bounds.size.width);
    
    //    rememberPwdBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -rememberPwdBtn.titleLabel.bounds.size.width+15, 0, 0);
    rememberPwdBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -64+15, 0, 0);
    
    [rememberPwdBtn addTarget:self action:@selector(rememberPwdBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:rememberPwdBtn];
    
    
    //找回密码
    UIButton  *findPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    findPwdBtn.frame = CGRectMake(MSWIDTH-130-20, CGRectGetMaxY(_passWindow.frame) + 15, 130, 30);
    [findPwdBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    findPwdBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [findPwdBtn setTitle:[NSString stringWithFormat:@"%@",NSLocalizedString(@"tv_get_pw", nil)] forState:UIControlStateNormal];
    findPwdBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [findPwdBtn addTarget:self action:@selector(findPwdBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:findPwdBtn];
    
    
    _signBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _signBtn.frame = CGRectMake(20, CGRectGetMaxY(findPwdBtn.frame) + 40, MSWIDTH-40, 45);
    _signBtn.backgroundColor = KRedColor;
    _signBtn.layer.cornerRadius = 3.0;
    [_signBtn setTitle:NSLocalizedString(@"tv_login1", nil) forState:UIControlStateNormal];
    [_signBtn addTarget:self action:@selector(signBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_signBtn];
    
    self.registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _registerButton.frame = CGRectMake(20, CGRectGetMaxY(_signBtn.frame) + 10, MSWIDTH-40, 25);
//    _registerButton.backgroundColor = KRedColor;
    [_registerButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _registerButton.layer.cornerRadius = 3.0;
    _registerButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_registerButton setTitle:NSLocalizedString(@"register_now", nil) forState:UIControlStateNormal];
    [_registerButton addTarget:self action:@selector(regItemClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_registerButton];
    
    
}

#pragma 单选框选中触发方法
- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked {
    DLOG(@"did tap on CheckBox:%@ checked:%d", checkbox.titleLabel.text, checked);
    [[AppDefaultUtil sharedInstance]  setRemeberUser:checked];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITextField *textField in [self.contentView subviews]) {
        if ([textField isKindOfClass: [UITextField class]]) {
            [textField  resignFirstResponder];
        }
    }
}
#pragma ===============

/**
 * 密码输入框右边的开关按钮
 * 切换密码是否明文
 */
- (void)switchAction:(UISwitch *)sender
{
    UISwitch *switchButton = sender;
    
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        _passWindow.secureTextEntry = YES;
    }else {
        _passWindow.secureTextEntry = NO;
    }
}

#pragma mark - 记住密码
- (void)rememberPwdBtnClick:(UIButton *)button
{
    if (button.selected == YES) {
        _isRemember = NO;
        button.selected = NO;
    }else
    {
        _isRemember = YES;
        button.selected = YES;
    }
}

#pragma mark  找回密码?
- (void)findPwdBtnClick
{
//    KRFindViewController *vc = [[KRFindViewController alloc] init];
//    [self.deleagate.navigationController pushViewController:vc animated:YES];
}

#pragma mark  注册
- (void)regItemClick
{
    [self hideEnterKeyboard];
    RegisterViewController *VC = [[RegisterViewController alloc] init];
    [self.deleagate.navigationController pushViewController:VC animated:YES];
}

#pragma mark - 点击登录
- (void)signBtnClick
{
    [self hideEnterKeyboard];
    if ([_phoneWindow isEditing]|| [_passWindow isEditing]) {
        [_passWindow resignFirstResponder];
        [_passWindow resignFirstResponder];
    }
    
    if (!self.tipView) {
        self.tipView  = [[JXLRPopTipView alloc] initWithFrame:CGRectMake(0, 0, MSWIDTH, self.superview.frame.size.height)];
    }
    
    if (_phoneWindow.text.length == 0) {
        [self.tipView.topBtn setTitle:NSLocalizedString(@"title_tips", nil) forState:UIControlStateNormal];
        self.tipView.titleLbl1.text = NSLocalizedString(@"login_err_input_acu", nil);
        [self.tipView.bottomBtn setTitle:NSLocalizedString(@"dialog_sure", nil) forState:UIControlStateNormal];
        [self.tipView.bottomBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.tipView];
        return;
    }
    if (_passWindow.text.length == 0) {

        [self.tipView.topBtn setTitle:NSLocalizedString(@"title_tips", nil) forState:UIControlStateNormal];
        self.tipView.titleLbl1.text = NSLocalizedString(@"login_err_input_pwd", nil);
        [self.tipView.bottomBtn setTitle:NSLocalizedString(@"dialog_sure", nil) forState:UIControlStateNormal];
        [self.tipView.bottomBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.tipView];
        return;
    }
    [self ControlAction];// 关闭键盘
    // 不在加载
    [self requestData];
}


#pragma mark - tipView
- (void)sureBtnClick
{
    if ([self.tipView.bottomBtn.titleLabel.text isEqualToString:NSLocalizedString(@"dialog_sure", nil)]) {
        [self.tipView removeFromSuperview];
    }
}

#pragma mark 点击 找回密码 按钮
- (void)getBackPassword
{
//    RetrievePasswordViewCdontroller *retrievePassword = [[RetrievePasswordViewController alloc] init];
//
//    [self.navigationController pushViewController:retrievePassword animated:YES];
}

#pragma mark 点击空白处收回键盘
- (void)ControlAction
{
    [self hideEnterKeyboard];
}

- (void)hideEnterKeyboard {
    for (UITextField *textField in [self.contentView subviews]) {
        
        if ([textField isKindOfClass: [UITextField class]]) {
            
            [textField  resignFirstResponder];
        }
    }
}

#pragma mark - 请求数据
- (void)requestData
{
    //暂时先用登录接口，后面要新增判断账号是否存在接口
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *name = _phoneWindow.text;
    NSString *password = [NSString encrypt3DES:_passWindow.text key:DESkey];
    [parameters setObject:@"1" forKey:@"OPT"];
    [parameters setObject:[[DAConfig userLanguage] substringToIndex:2] forKey:@"language"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:name forKey:@"name"];
    [parameters setObject:password forKey:@"pwd"];
    [parameters setObject:@"2" forKey:@"deviceType"];
    
    [KRRequestManager sendRequestWithRequestMethodType:RequestGET requestAPICode:@"app/services" requestParameters:parameters requestHeader:nil success:^(id  _Nonnull responseObject) {
        NSDictionary *obj = responseObject;
           
           if ([[NSString stringWithFormat:@"%@",[obj objectForKey:@"error"]] isEqualToString:@"-1"]) {
               
               DLOG(@"返回成功  username -> %@",[obj objectForKey:@"username"]);
               DLOG(@"返回成功  nick -> %@",[obj objectForKey:@"nick"]);
               DLOG(@"返回成功  id -> %@",[obj objectForKey:@"id"]);
               DLOG(@"返回成功  vipStatus -> %@",[obj objectForKey:@"vipStatus"]);
               DLOG(@"返回成功  imgUrl is  -> %@",[NSString stringWithFormat:@"%@%@", Baseurl, [obj objectForKey:@"headImg"]]);
               
               UserInfo *usermodel = [[UserInfo alloc] init];
               usermodel.userName = [obj objectForKey:@"username"];
                usermodel.nickName = [obj objectForKey:@"nick"];
               if ([[NSString stringWithFormat:@"%@",[obj objectForKey:@"headImg"]] hasPrefix:@"http"]) {
                   
                   usermodel.userImg = [NSString stringWithFormat:@"%@",[obj objectForKey:@"headImg"]];
               }
               else
               {
                   usermodel.userImg = [NSString stringWithFormat:@"%@%@", Baseurl, [obj objectForKey:@"headImg"]];
               }
               
               
               if([[NSString stringWithFormat:@"%@",[obj objectForKey:@"creditRating"]] hasPrefix:@"http"])
               {
                   usermodel.userCreditRating = [obj objectForKey:@"creditRating"];
                   
               }else{
                   usermodel.userCreditRating =  [NSString stringWithFormat:@"%@%@", Baseurl, [obj objectForKey:@"creditRating"]];
               }
               
               usermodel.userLimit = [obj objectForKey:@"creditLimit"];
               usermodel.isVipStatus = [obj objectForKey:@"vipStatus"];
               usermodel.userId = [obj objectForKey:@"id"];
               usermodel.isLogin = @"1";
               usermodel.deviceType = @"2";
               usermodel.accountAmount = [NSString stringWithFormat:@"%.2f", [[obj objectForKey:@"accountAmount"] doubleValue]];
               usermodel.availableBalance = [NSString stringWithFormat:@"%.2f", [[obj objectForKey:@"availableBalance"] doubleValue]];
               
//               AppDelegateInstance.userInfo = usermodel;
               
               [[AppDefaultUtil sharedInstance] setNickName:usermodel.nickName];// 保存用户昵称
               [[AppDefaultUtil sharedInstance] setDefaultUserName:usermodel.userName];
             
               //[[NSNotificationCenter defaultCenter] postNotificationName:@"addItem" object:nil userInfo:nil];
               
               [self loginSuccess:usermodel];// 登录成功
               
           }else {
               DLOG(@"返回失败  msg -> %@",[obj objectForKey:@"msg"]);
               [[AppDefaultUtil sharedInstance] setDefaultUserNoPassword:@""];// 清除用户密码
               if (!self.tipView) {
                    self.tipView  = [[JXLRPopTipView alloc] initWithFrame:CGRectMake(0, 0, MSWIDTH, self.superview.frame.size.height)];
               }
               
               [self.tipView.topBtn setTitle:NSLocalizedString(@"title_tips", nil) forState:UIControlStateNormal];
               self.tipView.titleLbl1.text = [NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]];
               [self.tipView.bottomBtn setTitle:NSLocalizedString(@"dialog_sure", nil) forState:UIControlStateNormal];
               [self.tipView.bottomBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
               [self.contentView addSubview:self.tipView];
               
           }
           _isLoading  = NO;
    } faild:^(NSError * _Nonnull error) {
        [KRProgressHud showErrorWithStatus:NSLocalizedString(@"toast_request_failed", nil)];
           _isLoading  = NO;
    }];
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark  HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
    _isLoading = YES;
}

//// 返回成功
//-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
//{
//    NSDictionary *dics = obj;
//
//    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
//
//        DLOG(@"返回成功  username -> %@",[obj objectForKey:@"username"]);
//        DLOG(@"返回成功  nick -> %@",[obj objectForKey:@"nick"]);
//        DLOG(@"返回成功  id -> %@",[obj objectForKey:@"id"]);
//        DLOG(@"返回成功  vipStatus -> %@",[obj objectForKey:@"vipStatus"]);
//        DLOG(@"返回成功  imgUrl is  -> %@",[NSString stringWithFormat:@"%@%@", Baseurl, [obj objectForKey:@"headImg"]]);
//
//        UserInfo *usermodel = [[UserInfo alloc] init];
//        usermodel.userName = [obj objectForKey:@"username"];
//         usermodel.nickName = [obj objectForKey:@"nick"];
//        if ([[NSString stringWithFormat:@"%@",[obj objectForKey:@"headImg"]] hasPrefix:@"http"]) {
//
//            usermodel.userImg = [NSString stringWithFormat:@"%@",[obj objectForKey:@"headImg"]];
//        }
//        else
//        {
//            usermodel.userImg = [NSString stringWithFormat:@"%@%@", Baseurl, [obj objectForKey:@"headImg"]];
//        }
//
//
//        if([[NSString stringWithFormat:@"%@",[obj objectForKey:@"creditRating"]] hasPrefix:@"http"])
//        {
//            usermodel.userCreditRating = [obj objectForKey:@"creditRating"];
//
//        }else{
//            usermodel.userCreditRating =  [NSString stringWithFormat:@"%@%@", Baseurl, [obj objectForKey:@"creditRating"]];
//        }
//
//        usermodel.userLimit = [obj objectForKey:@"creditLimit"];
//        usermodel.isVipStatus = [obj objectForKey:@"vipStatus"];
//        usermodel.userId = [obj objectForKey:@"id"];
//        usermodel.isLogin = @"1";
//        usermodel.deviceType = @"2";
//        usermodel.accountAmount = [NSString stringWithFormat:@"%.2f", [[obj objectForKey:@"accountAmount"] doubleValue]];
//        usermodel.availableBalance = [NSString stringWithFormat:@"%.2f", [[obj objectForKey:@"availableBalance"] doubleValue]];
//
//        AppDelegateInstance.userInfo = usermodel;
//
//        [[AppDefaultUtil sharedInstance] setNickName:AppDelegateInstance.userInfo.nickName];// 保存用户昵称
//        [[AppDefaultUtil sharedInstance] setDefaultUserName:AppDelegateInstance.userInfo.userName];
//
//        //[[NSNotificationCenter defaultCenter] postNotificationName:@"addItem" object:nil userInfo:nil];
//
//        [self loginSuccessm];// 登录成功
//
//    }else {
//        DLOG(@"返回失败  msg -> %@",[obj objectForKey:@"msg"]);
//        [[AppDefaultUtil sharedInstance] setDefaultUserNoPassword:@""];// 清除用户密码
//        if (!self.tipView) {
//             self.tipView  = [[JXLRPopTipView alloc] initWithFrame:CGRectMake(0, 0, MSWIDTH, self.superview.frame.size.height)];
//        }
//
//        [self.tipView.topBtn setTitle:NSLocalizedString(@"title_tips", nil) forState:UIControlStateNormal];
//        self.tipView.titleLbl1.text = [NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]];
//        [self.tipView.bottomBtn setTitle:NSLocalizedString(@"dialog_sure", nil) forState:UIControlStateNormal];
//        [self.tipView.bottomBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView addSubview:self.tipView];
//
//    }
//    _isLoading  = NO;
//}

////返回失败
//-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
//{
//    [KRProgressHud showErrorWithStatus:NSLocalizedString(@"toast_request_failed", nil)];
//    _isLoading  = NO;
//}

//无可用的网络
-(void) networkError
{
    [KRProgressHud showErrorWithStatus:NSLocalizedString(@"toast_check_network", nil)];
    _isLoading  = NO;
}


-(void) loginSuccess:(UserInfo *)userInfo {
    // 保存账号密码到UserDefault
    [[AppDefaultUtil sharedInstance] setDefaultUserName:userInfo.userName];// 保存用户昵称
    [[AppDefaultUtil sharedInstance] setDefaultAccount:_phoneWindow.text];// 保存用户账号
    [[AppDefaultUtil sharedInstance] setDefaultUserNoPassword:_passWindow.text];// 保存用户密码（未加密）
    NSString *pwdStr = [NSString encrypt3DES:_passWindow.text key:DESkey];//用户密码3Des加密
    [[AppDefaultUtil sharedInstance] setDefaultUserPassword:pwdStr];// 保存用户密码（des加密）
    [[AppDefaultUtil sharedInstance] setDefaultHeaderImageUrl:userInfo.userImg];// 保存用户头像
    [[AppDefaultUtil sharedInstance] setdeviceType:userInfo.deviceType];// 保存设备型号
    [[AppDefaultUtil sharedInstance] setDefaultUserId:userInfo.userId];// 保存设备型号
    [[AppDefaultUtil sharedInstance] setDefaultIsLogin:userInfo.isLogin.boolValue ];// 保存登陆状态


    //    DLOG(@"name is =======> %@",_nameWindow.text);
    //    DLOG(@"gest is =======> %@",[[AppDefaultUtil sharedInstance] getGesturesPasswordWithAccount:_nameWindow.text]);
    // 通知全局广播 LeftMenuController 修改UI操作
    [[NSNotificationCenter defaultCenter]  postNotificationName:ME_LOGING_SUCCESS_UPDATE object:nil];
    
    if (self.loginSuccess) {
        self.loginSuccess();
    }
}


@end
