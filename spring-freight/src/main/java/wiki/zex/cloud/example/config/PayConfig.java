package wiki.zex.cloud.example.config;

import com.lly835.bestpay.config.AliPayConfig;
import com.lly835.bestpay.config.WxPayConfig;
import com.lly835.bestpay.service.impl.BestPayServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * @version 1.0 2017/3/2
 * @auther <a href="mailto:lly835@163.com">廖师兄</a>
 * @since 1.0
 */
@Configuration
public class PayConfig {

    @Autowired
    private WechatAccountConfig accountConfig;

    @Autowired
    private AliPayAccountConfig aliPayAccountConfig;

    @Bean
    public WxPayConfig masterConfig() {
        WxPayConfig wxPayConfig = new WxPayConfig();
        wxPayConfig.setMchId(accountConfig.getMchId());
        wxPayConfig.setAppId(accountConfig.getMasterAppId());
        wxPayConfig.setMchKey(accountConfig.getMchKey());
        wxPayConfig.setKeyPath(accountConfig.getKeyPath());
        wxPayConfig.setNotifyUrl(accountConfig.getNotifyUrl());
        wxPayConfig.setAppAppId(accountConfig.getMasterAppId());
        return wxPayConfig;
    }


    @Bean
    public WxPayConfig driverConfig() {
        WxPayConfig wxPayConfig = new WxPayConfig();
        wxPayConfig.setMchId(accountConfig.getMchId());
        wxPayConfig.setAppId(accountConfig.getDriverAppId());
        wxPayConfig.setMchKey(accountConfig.getMchKey());
        wxPayConfig.setKeyPath(accountConfig.getKeyPath());
        wxPayConfig.setNotifyUrl(accountConfig.getNotifyUrl());
        wxPayConfig.setAppAppId(accountConfig.getDriverAppId());
        return wxPayConfig;
    }

    @Bean
    public AliPayConfig aliPayConfig() {
        AliPayConfig aliPayConfig = new AliPayConfig();
        aliPayConfig.setNotifyUrl(aliPayAccountConfig.getNotifyUrl());
        aliPayConfig.setAppId(aliPayAccountConfig.getAppId());
        aliPayConfig.setPrivateKey(aliPayAccountConfig.getPrivateKey());
        aliPayConfig.setAliPayPublicKey(aliPayAccountConfig.getAliPayPublicKey());
        aliPayConfig.setSandbox(aliPayAccountConfig.getSandbox());
        aliPayConfig.setReturnUrl(aliPayAccountConfig.getReturnUrl());
        return aliPayConfig;
    }

    @Bean
    public BestPayServiceImpl driverPayService(WxPayConfig driverConfig, AliPayConfig aliPayConfig) {
        BestPayServiceImpl bestPayService = new BestPayServiceImpl();
        bestPayService.setWxPayConfig(driverConfig);
        bestPayService.setAliPayConfig(aliPayConfig);
        return bestPayService;
    }

    @Bean
    public BestPayServiceImpl bestPayService(AliPayConfig aliPayConfig) {
        BestPayServiceImpl bestPayService = new BestPayServiceImpl();
        WxPayConfig wxPayConfig = new WxPayConfig();
        wxPayConfig.setMchId(accountConfig.getMchId());
        wxPayConfig.setMchKey(accountConfig.getMchKey());
        wxPayConfig.setKeyPath(accountConfig.getKeyPath());
        wxPayConfig.setNotifyUrl(accountConfig.getNotifyUrl());
        bestPayService.setWxPayConfig(wxPayConfig);
        bestPayService.setAliPayConfig(aliPayConfig);
        return bestPayService;
    }


    @Bean
    public BestPayServiceImpl masterPayService(WxPayConfig masterConfig, AliPayConfig aliPayConfig) {
        BestPayServiceImpl bestPayService = new BestPayServiceImpl();
        bestPayService.setWxPayConfig(masterConfig);
        bestPayService.setAliPayConfig(aliPayConfig);
        return bestPayService;
    }
}
