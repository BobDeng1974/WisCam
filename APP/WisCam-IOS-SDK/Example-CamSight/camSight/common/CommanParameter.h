//
//  CommanParameter.h
//  AoSmart
//
//  Created by rakwireless on 16/1/21.
//  Copyright © 2016年 rak. All rights reserved.
//
#import <UIKit/UIKit.h>

///////////   key    /////////////
#define CHOOSE_MODULE_KEY @"CHOOSE_MODULE_KEY"
#define MODULE_VERSION_KEY @"MODULE_VERSION_KEY"
#define MODULE_IP_KEY @"MODULE_IP_KEY"
#define MODULE_PASSWORD_KEY @"MODULE_PASSWORD_KEY"
#define MODULE_USERNAME_KEY @"MODULE_USERNAME_KEY"

///////////   size     /////////////
#define view_fix_height 376  //UI设计时总高度，通过这个值和屏幕高度的比例，设置每个控件的高度
#define view_fix_width 667   //UI设计时总宽度，通过这个值和屏幕宽度的比例，设置每个控件的宽度
#define viewH [UIScreen mainScreen].bounds.size.height  //屏幕高度
#define viewW [UIScreen mainScreen].bounds.size.width   //屏幕宽度
#define diff_top  viewH*20/view_fix_height         //距离上边界距离
#define diff_x  10           //距离左右边界距离
#define easy_add_progress_size viewH*36/view_fix_height 
#define main_title_size viewH*20/view_fix_height   //主界面标题大小
#define choose_text_size viewH*18/view_fix_height
#define main_text_size viewH*16/view_fix_height
#define contact_text_size viewH*14/view_fix_height
#define about_copyright_size viewH*12/view_fix_height
#define menu_title_size viewH*30/view_fix_height 
#define list_row_height viewH*44/view_fix_height
#define diff_bottom  20
#define title_size  36
#define main_help_size  22
#define add_title_size  22
#define add_text_size  18
#define add_bg  242
#define diff_help_x 5
#define list_group_height 44
#define action_list_row_height viewH*75/view_fix_height

///////////   color     /////////////
#define MAIN_STATUS_COLOR [UIColor colorWithRed:(169 / 255.0f) green:(173 / 255.0f) blue:(186 / 255.0f) alpha:1.0]
#define MAIN_TITLE_COLOR [UIColor colorWithRed:(92 / 255.0f) green:(108 / 255.0f) blue:(159 / 255.0f) alpha:1.0]  //主界面标题颜色
#define MAIN_BG_COLOR [UIColor colorWithRed:(244 / 255.0f) green:(246 / 255.0f) blue:(247 / 255.0f) alpha:1.0]  //主界面背景颜色
#define MAIN_ADD_NOTE_COLOR [UIColor colorWithRed:(150 / 255.0f) green:(163 / 255.0f) blue:(174 / 255.0f) alpha:1.0]  
#define MAIN_REFRESH_NOTE_COLOR [UIColor colorWithRed:(209 / 255.0f) green:(210 / 255.0f) blue:(214 / 255.0f) alpha:1.0] 
#define MENU_LIST_TEXT_COLOR [UIColor colorWithRed:(79 / 255.0f) green:(87 / 255.0f) blue:(109 / 255.0f) alpha:1.0] 
#define CHOOSE_MODULE_BG_COLOR [UIColor colorWithRed:(250 / 255.0f) green:(250 / 255.0f) blue:(250 / 255.0f) alpha:1.0]
#define CHOOSE_MODULE_TEXT_COLOR [UIColor colorWithRed:(142 / 255.0f) green:(143 / 255.0f) blue:(152 / 255.0f) alpha:1.0]
#define CONTACT_US_TEXT_COLOR [UIColor colorWithRed:(150 / 255.0f) green:(163 / 255.0f) blue:(174 / 255.0f) alpha:1.0]
#define CONTACT_US_TEXT_LINE [UIColor colorWithRed:(234 / 255.0f) green:(234 / 255.0f) blue:(234 / 255.0f) alpha:1.0]
#define CONTACT_US_TEXT_SMALL [UIColor colorWithRed:(198 / 255.0f) green:(198 / 255.0f) blue:(198 / 255.0f) alpha:1.0]
#define ABOUT_TEXT_COPYRIGHT [UIColor colorWithRed:(180 / 255.0f) green:(181 / 255.0f) blue:(186 / 255.0f) alpha:1.0]
#define AP_ADD_STEP1_NOTE [UIColor colorWithRed:(60 / 255.0f) green:(0.0f) blue:(0.0f) alpha:1.0]
#define LIST_BG_COLOR [UIColor colorWithRed:(238 / 255.0f) green:(240 / 255.0f) blue:(241 / 255.0f) alpha:1.0]
#define YELLOW_TEXT_COLOR [UIColor colorWithRed:(241 / 255.0f) green:(149 / 255.0f) blue:(44 / 255.0f) alpha:1.0]
#define TX_RX_BG_COLOR [UIColor colorWithRed:(224 / 255.0f) green:(227 / 255.0f) blue:(239 / 255.0f) alpha:1.0]
#define ALTER_BG_COLOR [UIColor colorWithRed:(55 / 255.0f) green:(60 / 255.0f) blue:(74 / 255.0f) alpha:0.4]

@interface CommanParameter : NSObject
@end
