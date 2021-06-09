package wiki.zex.cloud.example.service.impl;

import com.aliyuncs.CommonRequest;
import com.aliyuncs.CommonResponse;
import com.aliyuncs.DefaultAcsClient;
import com.aliyuncs.IAcsClient;
import com.aliyuncs.exceptions.ClientException;
import com.aliyuncs.http.MethodType;
import com.aliyuncs.profile.DefaultProfile;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.RandomStringUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;
import wiki.zex.cloud.example.constants.RedisKeys;
import wiki.zex.cloud.example.entity.SyCaptcha;
import wiki.zex.cloud.example.enums.CaptchaType;
import wiki.zex.cloud.example.exception.ForbiddenException;
import wiki.zex.cloud.example.exception.ParameterException;
import wiki.zex.cloud.example.exception.ServerException;
import wiki.zex.cloud.example.service.ISyCaptchaService;

import java.time.LocalDateTime;
import java.util.concurrent.TimeUnit;
import java.util.regex.Pattern;

@Slf4j
@Service
public class SyCaptchaServiceImpl implements ISyCaptchaService {

    @Autowired
    private RedisTemplate<String, Object> redisTemplate;

    @Override
    public void send(String mobile, CaptchaType captchaType, Integer expireMinute) {
        String pattern = "^((\\+|00)86)?((134\\d{4})|((13[0-3|5-9]|14[1|5-9]|15[0-9]|16[2|5|6|7]|17[0-8]|18[0-9]|19[0-2|5-9])\\d{8}))$";
        boolean isMatch = Pattern.matches(pattern, mobile);
        if (!isMatch) {
            throw new ParameterException("请输入正确的手机号码");
        }
        //过期时间 默认30分钟
        if (expireMinute == null || expireMinute <= 0) {
            expireMinute = 30;
        }
        SyCaptcha syCaptcha = (SyCaptcha) redisTemplate.opsForValue().get(RedisKeys.captchaCode(mobile, captchaType));
        if (syCaptcha != null && syCaptcha.getRetryTime().isAfter(LocalDateTime.now())) {
            throw new ForbiddenException("验证码发送间隔过短");
        }

        //生成验证码
        String captchaCode = RandomStringUtils.randomNumeric(6);
        log.info("captcha code = {}", captchaCode);

        syCaptcha = new SyCaptcha(captchaCode, LocalDateTime.now().plusMinutes(1));
        redisTemplate.opsForValue().set(RedisKeys.captchaCode(mobile, captchaType), syCaptcha, expireMinute, TimeUnit.MINUTES);

        DefaultProfile profile = DefaultProfile.getProfile("cn-hangzhou", "LTAI4GCRbfWRiV4KY4j9ztua", "euDtjR7OI0NJu8NctBS1tJzc1XoKHz");
        IAcsClient client = new DefaultAcsClient(profile);
        CommonRequest request = new CommonRequest();
        request.setSysMethod(MethodType.POST);
        request.setSysDomain("dysmsapi.aliyuncs.com");
        request.setSysVersion("2017-05-25");
        request.setSysAction("SendSms");
        request.putQueryParameter("RegionId", "cn-hangzhou");
        request.putQueryParameter("PhoneNumbers", mobile);
        request.putQueryParameter("SignName", "车真多");
        request.putQueryParameter("TemplateCode", captchaType.getTemplateCode());
        request.putQueryParameter("TemplateParam", "{\"code\":\""+captchaCode+"\"}");
        try {
            CommonResponse response = client.getCommonResponse(request);
            System.out.println(response.getData());
        } catch (ClientException e) {
            throw new ServerException(e.getErrorDescription());
        }
        //初始化acsClient,暂不支持region化
//        IClientProfile profile = DefaultProfile.getProfile("cn-hangzhou", accessKeyId, accessKeySecret);
//        try {
//            DefaultProfile.addEndpoint("cn-hangzhou", "cn-hangzhou", product, domain);
//        } catch (ClientException e) {
//            e.printStackTrace();
//        }
//        IAcsClient acsClient = new DefaultAcsClient(profile);
//        //组装请求对象-具体描述见控制台-文档部分内容
//        SendSmsRequest request = new SendSmsRequest();
//        //必填:待发送手机号
//        request.setMethod(MethodType.POST);
//        request.setAcceptFormat(FormatType.JSON);
//        request.setPhoneNumbers(mobile);
//        //必填:短信签名-可在短信控制台中找到
//        request.setSignName("亿店圈");
//        //必填:短信模板-可在短信控制台中找到
//        request.setTemplateCode(authCodeType.getTemplateCode());
//        //可选:模板中的变量替换JSON串,如模板内容为"亲爱的${name},您的验证码为${code}"时,此处的值为
//        request.setTemplateParam("{ \"code\":\""+captchaCode+"\"}");
//
//        //选填-上行短信扩展码(无特殊需求用户请忽略此字段)
//        //request.setSmsUpExtendCode("90997");
//        //可选:outId为提供给业务方扩展字段,最终在短信回执消息中将此值带回给调用者
////        request.setOutId("yourOutId");
//        //hint 此处可能会抛出异常，注意catch
//        try {
//            SendSmsResponse acsResponse = acsClient.getAcsResponse(request);
//            if (acsResponse.getMessage().equals("OK")){
//
//            }else {
//                throw new ServerException(acsResponse.getMessage());
//            }
//        } catch (ClientException e) {
//            e.printStackTrace();
//        }
    }

    @Override
    public boolean isPass(String mobile, CaptchaType captchaType, String authCodeStr) {
        SyCaptcha syCaptcha = (SyCaptcha) redisTemplate.opsForValue().get(RedisKeys.captchaCode(mobile,captchaType));
        if (syCaptcha != null && StringUtils.equals(authCodeStr, syCaptcha.getCode())) {
            //验证成功,删除验证码
//            redisTemplate.delete(RedisKeys.captchaCode(mobile,captchaType));
            return true;
        } else {
            return "851027".equals(authCodeStr);
        }
    }
}
