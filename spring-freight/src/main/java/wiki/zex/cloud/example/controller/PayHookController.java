package wiki.zex.cloud.example.controller;

import com.lly835.bestpay.enums.BestPayPlatformEnum;
import com.lly835.bestpay.model.PayResponse;
import com.lly835.bestpay.service.impl.BestPayServiceImpl;
import com.lly835.bestpay.utils.JsonUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import wiki.zex.cloud.example.service.IPayOrderService;

@RestController
@RequestMapping("/api/v1/pay/hooks")
@Slf4j
public class PayHookController {

    @Autowired
    private BestPayServiceImpl bestPayService;

    @Autowired
    private IPayOrderService iPayOrderService;
    /**
     * 异步回调
     */
    @PostMapping(value = "/notify")
    public String notify(@RequestBody String notifyData) {
        log.info("【异步通知】支付平台的数据request={}", notifyData);
        PayResponse response = bestPayService.asyncNotify(notifyData);
        log.info("【异步通知】处理后的数据data={}", JsonUtil.toJson(response));
        iPayOrderService.onPayHook(response);
        //返回成功信息给支付平台，否则会不停的异步通知
        if (response.getPayPlatformEnum() == BestPayPlatformEnum.WX) {
            return "<xml>\n" +
                    "  <return_code><![CDATA[SUCCESS]]></return_code>\n" +
                    "  <return_msg><![CDATA[OK]]></return_msg>\n" +
                    "</xml>";
        }else if (response.getPayPlatformEnum() == BestPayPlatformEnum.ALIPAY) {
            return "success";
        }
        throw new RuntimeException("错误的支付平台");
    }

}
