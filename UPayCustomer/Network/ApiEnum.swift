
//
//  ApiEnum.swift
//  ShoppingGo
//
//  Created by 飞亦 on 2017/6/9.
//  Copyright © 2017年 飞亦. All rights reserved.
//

import Foundation

enum ApiString : String {
    //用户相关
    case login =                     "/app/login"                           //用户登录
    case logout =                    "/app/logout"                          //用户登出
    case register =                  "/user/register"                       //用户注册
    case firstResetLoginPsd =        "/app/user/firstModPwd"                //第一次修改登录密码
    case firstResetTradePsd =        "/app/user/setSafePwd"                 //第一次设置交易密码
    case resetLoginPsd =             "/app/user/modPwd"                     //重设登录密码
    case resetTradePsd =             "/app/user/modSafePwd"                 //重设交易密码
    case getImageCode =              "/app/validateCode"                    //图片验证码
    case certId =                    "/app/cm/userValid/save"               //身份认证
    //通用相关
    case uploadImage =               "/app/fileup"                          //上传文件
    case configuration =             "/app/wallet/ticker"                   //平台配置
    
    //订单
    case orderList_otc =             "/app/otc/trade/list"                  //订单列表-平台价
    case orderBuyList_otc =          "/app/otc/advert/merSell/list/v2"      //订单买入列表-平台价
    case orderBuyOrSell_otc =        "/app/otc/trade/cmBuyAndSell"          //订单买卖-平台价
    case orderBuyOrSellDetail_otc =  "/app/otc/trade/info"                  //订单详情-平台价
    case orderCancelOrClose_otc =    "/app/otc/trade/cmCancleOrder"         //订单取消或关闭-平台价
    case orderRollBack_otc =         "/app/otc/trade/tobeRolledBack"        //订单回滚(已取消或关闭)-平台价
    case orderConfirmPay_otc =       "/app/otc/trade/cmConfirmPay"          //订单确认支付-平台价
    case orderConfirmOrNot_otc =     "/app/otc/trade/mertConfirm"           //订单确认（已收款或未收款）-平台价
    
    //广告
    case adList_otc =                "/app/otc/advert/list"                 //广告列表-平台价
    case adPublish_otc =             "/app/otc/advert/publish"              //发布广告-平台价
    case adUse_otc =                 "/app/otc/advert/start"                //上架广告-平台价
    case adNotUse_otc =              "/app/otc/advert/stop"                 //下架广告-平台价
    case adDelete_otc =              "/app/otc/advert/delete"               //删除广告-平台价
    case adEdit_otc =                "/app/otc/advert/edit"                 //编辑广告-平台价
    
    case adQuickSell_otc =           "/app/otc/advert/onekeyPublish"        //一键导入卖单-平台价
    
    case adUse_custom =              "/app/custom/advert/up"                //上架广告-自定价
    case adNotUse_custom =           "/app/custom/advert/down"              //下架广告-自定价
    case adDelete_custom =           "/app/custom/advert/del"               //删除广告-自定价
    
    
    //资产
    case wallet =                    "/app/wallet/detail"                   //钱包
    case propertyRecords =           "/app/wallet/record/list"              //资产记录
    case coinList =                  "/app/wallet/coin/list"                //币种列表
    case coinExport =                "/app/coinTransferRecord/save"         //提币
    case coinExportList =            "/app/coinTransferRecord/list"         //提币记录
    case coinEntity =                "/app/wallet/coin/info"                //币配置
    
    //向平台买币
    case buyPlatformList =           "/app/bigPayRecord/list"               //订单列表-向平台买币
    case buyingPlatform =            "/app/bigPayRecord/save"               //下单
    case buyPlatformDetail =         "/app/bigPayRecord/view"               //详情
    case buyPlatformConfirm =        "/app/bigPayRecord/confirm"            //确认支付
    case buyPlatformCancel =         "/app/bigPayRecord/cancel"             //取消
    case buyPlatformDelete =         "/app/bigPayRecord/delete"             //删除
    
    //收款账号相关
    case receiptAccountList =        "/app/depositAccount/list"             //收款账号列表
    case receiptAccountAddOrEdit =   "/app/depositAccount/save"             //编辑&添加收款账号
    case receiptAccountUseOrNot =    "/app/depositAccount/updateUseStatus"  //上下架收款账号
    case receiptAccountDelete =      "/app/depositAccount/delete"           //删除收款账号
    
    
    
    case propertyTransfer =          "/api/home/wallet/withdraw"            //转账
    case propertyExchange =          "/api/wallet/exchange"                 //兑换
    case propertyExchangeList =      "/api/wallet/exchange/list"            //兑换列表
    
    case propertyAddressAdd =        "/api/home/wallet/address/add"         //添加地址
    case propertyAddressEdit =       "/api/home/wallet/address/update"      //编辑地址
    case propertyAddressDel =        "/api/home/wallet/address/del"         //删除地址
    case propertyAddressList =       "/api/home/wallet/address"             //地址列表
   
   
    case my =                        "/api/user"                            //我的
    case noticeLists =               "/api/home/notice"                     //消息列表
    case promotion =                 "/api/user/spread"                     //推广
    case community =                 "/api/user/team"                       //社区
    case income =                    "/api/user/profit"                     //收益
    case incomeRecords =             "/api/user/bonus"                      //收益明细
    
    case feedback =                  "/api/user/feedback"                   //意见反馈
    case version =                   "/app/appVersion"                      //版本更新


    case mnemonic =                  "/api/user/get/mnemonic/v2"            //获取助记词
    case privateKey =                "/api/user/get/masterMrivateKey/v2"    //获取私钥
    case modifyPsd =                 "/api/user/forgetLoginPwd"             //修改密码
    
    case find =                      "/api/find/banner"                     //发现
    case financial =                 "/api/contract"                        //理财账户
    case financialProgram =          "/api/contract/level"                  //理财计划
    case financialJoin =             "/api/contract/buy"                    //加入理财计划
    case financialProgramRecords =   "/api/contract/list"                   //理财账户及计划
    case financialRecords =          "/api/contract/plan/list"              //理财记录
    case financialRecordDetail =     "/api/contract/plan/detail"            //理财记录详情
    case financialRelease =          "/api/contract/plan/relieve"           //解除理财计划
    
    case walletList =                "/api/wallet"                          //钱包币资产
    
    //不加/API将不会验证登录状态
    //case quotesList =                "/api/market/list"                     //行情列表
    case quotesList =                "/market/list"                         //行情列表
    
    
    case getChatID =                 "/planA/common/getServiceId"          //获取会话ID
    
    case buyCancel =                 "/planA/order/cancel"                 //买单取消
    case buyConfirm =                "/planA/order/payConfirm"             //买单付款确认
    
    case sellConfirm =               "/planA/order/receiptConfirm"         //卖单付款确认
    
    case tradeList =                 "/planA/wallet/recordList"            //交易列表
    case tradeDetail =               "/planA/wallet/recordDetail"          //交易详情
    
    
    case harvestDiamond =            "/planA/home/takeMineral"             //收获水晶
    case inviteInfo =                "/planA/user/inviteInfo"              //邀请好友页面，包含我的邀请码，累计获得ipe数量等
    
    case taskList =                  "/planA/user/powerTask"               //提升智慧页面,包含未完成任务
    case taskRecord =                "/planA/fixedTask/record"             //固定任务完成记录
    
    case property  =                 "/planA/user/ipeInfo"                 //我的资产
    case propertyRecord =            "/planA/user/coinRecord"              //资产记录
    
    case powerRecord =               "/planA/user/powerRecord"             //算力记录
    
    case liveAuth =                  "/planA/fixedTask/faceAuth"           //人脸身份识别
    
    case weChat =                    "/planA/fixedTask/wechatSubscribe"    //关注公众号验证码验证
    case createWallet =              "/planA/fixedTask/createWallet"       //创建链上钱包
    case copyWallet  =               "/planA/fixedTask/backupWallet"       //备份链上钱包
    case myProperty  =               "/planA/my/asset"                     //我的资产
    
    case profileInfo =               "/planA/user/baseInfo"                //我的基础信息 ，昵称，头像，注册排行
    case myIdentity  =               "/planA/user/identityInfo"            //我的实名信息
    case modifyNickName  =           "/planA/user/updateNickname"          //修改昵称
    case modifyAvatar  =             "/planA/user/updateHeadImg"           //修改头像
    case addName  =                  "/planA/user/updateRealName"          //添加实名
    case payList  =                  "/planA/depositAccounts/list"         //支付方式列表
    case bankList  =                 "/planA/depositAccounts/bankList"     //银行列表
    case validateTradePassword  =    "/planA/depositAccounts/validateSafePassword" //验证资金密码
    case editPayStyle  =             "/planA/depositAccounts/save"         //添加、修改支付方式
    case deletePayStyle  =           "/planA/depositAccounts/delete"       //删除支付方式
 
    case modifyLogPsdSendCode =      "/planA/user/updateLoginPwd/sendMobileCode" //修改登录密码发送验证码
    case modifyLogPsd =              "/planA/user/updateLoginPwd/doUpdate" //修改登录密码
    case modifyTradePsdSendCode =    "/planA/user/updateSafePwd/sendMobileCode" //修改资金密码发送验证码
    case modifyTradePsdValidateCode = "/planA/user/updateSafePwd/validateMobileCode"//修改资金密码校验验证码
    case modifyTradePsd =            "/planA/user/updateSafePwd/doUpdate"  //修改资金密码
    
    case tradePsdInit =              "/planA/user/safePwdInit"             //资金密码初始化
    
    
    
    
    
    case articleList =               "/planA/article/list"                 //文章列表
    case articleDetails  =           "/planA/article/detail"               //文章详情
    case articleLike =               "/planA/article/like"                 //文章点赞，不允许取消
    case articleRead =               "/planA/article/read"                 //阅读任务
    case articleCommentList =        "/planA/article/commentList"          //评论列表
    case articleComment =            "/planA/article/comment"              //发表评论
    case articleCommentDelete =      "/planA/article/deleteComment"        //删除评论
    case articelQueryByBlockChain =  "/planA/article/chainInfo"            //查看文章上链信息
    
    case paperList  =                "/planA/thesis/list"                  //论文列表
    case paperDetail  =              "/planA/thesis/detail"                //论文详情
    case paperTrade   =              "/planA/thesis/trade"                 //论文购买
    
    case modifiyPwd       = "/user/updatePassword"
    case personInfo       = "/user/realInfo"

}
