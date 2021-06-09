package wiki.zex.cloud.example.controller;

import io.swagger.annotations.Api;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import wiki.zex.cloud.example.resp.MeStatisticalResp;
import wiki.zex.cloud.example.service.IStatisticalService;

@RestController
@Api(tags = "统计信息")
@RequestMapping("/api/v1/statistical")
public class StatisticalController {

    @Autowired
    private IStatisticalService iStatisticalService;
    @GetMapping("/me")
    public Object meStatisticalResp(Authentication authentication){
        return iStatisticalService.meStatisticalResp(authentication);
    }


}
