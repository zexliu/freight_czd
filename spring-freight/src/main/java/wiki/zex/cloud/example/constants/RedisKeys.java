package wiki.zex.cloud.example.constants;

import wiki.zex.cloud.example.enums.CaptchaType;

public class RedisKeys {



    public static String captchaCode(String mobile, CaptchaType captchaType) {
        return "CAPTCHA_CODE_"+captchaType.name()+"_"+mobile;
    }

    public static String notifyRepeatKey(String orderId) {
        return "PAY_NOTIFY_SEQUENCE:" + orderId;
    }

}
