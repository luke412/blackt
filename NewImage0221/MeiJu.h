//
//  MeiJu.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/6.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#ifndef MeiJu_h
#define MeiJu_h

//启动页超时时间
#define QiDingYeTimeOut   3

//动画最大滑动比
#define max_weiyi_bi   0.35

//自助调温 一键理疗的每秒前进秒数
#define MIAO_SHU   1

#define TOU_XIANG_KEY   @"TOU_XIANG_KEY"    //存取头像的key
#define MEI_TIAN_MIAO_SHU  86400            //每天的秒数
#define RequestTimeOut   10

#define BangDing         @"0"     // 设备绑定上报
#define JieBang          @"1"     // 设备解绑上报

/** 雁验证码类型 */
typedef enum  {
    WEN_BEN = 0,
    YU_YIN
}YANZHENGMA_TYPE;

/** 网络状态 */
typedef enum  {
    WIFI = 0,
    _3G4G,
    UNKNOW,
    MEI_WANG,
    QI_PA
}NETWORKSTATUS;


#endif /* MeiJu_h */
