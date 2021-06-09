package wiki.zex.cloud.example.service;

import wiki.zex.cloud.example.enums.CaptchaType;

public interface ISyCaptchaService {

    void send(String mobile, CaptchaType authCodeType, Integer expireMinute);

    boolean isPass(String mobile, CaptchaType authCodeType, String authCodeStr);

}
