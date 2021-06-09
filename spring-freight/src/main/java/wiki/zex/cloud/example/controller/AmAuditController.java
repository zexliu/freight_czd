package wiki.zex.cloud.example.controller;


import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import wiki.zex.cloud.example.req.AmAuditReq;
import wiki.zex.cloud.example.resp.SimpleResp;
import wiki.zex.cloud.example.security.MyUserDetails;
import wiki.zex.cloud.example.service.IAmAuditHistoryService;
import wiki.zex.cloud.example.utils.NetWorkUtil;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

/**
 * <p>
 *  前端控制器
 * </p>
 *
 * @author Zex
 * @since 2020-02-19
 */
@RestController
@RequestMapping("/api/v1/audits")
@Api(tags = "审核操作相关接口")
public class AmAuditController {
//
    @Autowired
    private IAmAuditHistoryService iAmAuditHistoryService;


    @PostMapping
    @ApiOperation("审核记录")
    public SimpleResp audit(@RequestBody @Valid AmAuditReq req, HttpServletRequest request, Authentication authentication){
        MyUserDetails myUserDetails = (MyUserDetails) authentication.getPrincipal();
        String ip = NetWorkUtil.getRequestIp(request);
        iAmAuditHistoryService.audit(req,ip, myUserDetails.getId());
        return SimpleResp.SUCCESS;
    }


}
