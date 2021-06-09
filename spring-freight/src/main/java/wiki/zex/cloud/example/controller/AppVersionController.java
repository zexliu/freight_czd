package wiki.zex.cloud.example.controller;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import org.springframework.web.bind.annotation.RestController;
import wiki.zex.cloud.example.entity.AppVersion;
import wiki.zex.cloud.example.service.IAppVersionService;

/**
 * <p>
 *  前端控制器
 * </p>
 *
 * @author Zex
 * @since 2020-09-11
 */
@RestController
@RequestMapping("/api/v1/app/version")
public class AppVersionController {

    @Autowired
    private IAppVersionService iAppVersionService;


    @GetMapping
    public AppVersion appVersion(Integer versionCode, Integer type ,Integer deviceType){
        return   iAppVersionService.getByVersionCode(versionCode,type,deviceType);
    }


}
