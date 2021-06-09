package wiki.zex.cloud.example.controller;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.web.bind.annotation.*;
import wiki.zex.cloud.example.enums.CaptchaType;
import wiki.zex.cloud.example.exception.ParameterException;
import wiki.zex.cloud.example.resp.SimpleResp;
import wiki.zex.cloud.example.service.ISyCaptchaService;

import java.util.regex.Pattern;

@Api(tags = "验证码接口")

@RestController
@RequestMapping("/api/v1/captcha")
public class SyCaptchaController {

    @Autowired
    private ISyCaptchaService iSyCaptchaService;

    @PostMapping("/code/{type}")
    @ApiOperation("发送验证码")
    public SimpleResp sendCode(@RequestParam String mobile, @PathVariable CaptchaType type) {
        iSyCaptchaService.send(mobile, type, 30);
        return SimpleResp.SUCCESS;
    }


}
