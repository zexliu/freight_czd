package wiki.zex.cloud.example.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import wiki.zex.cloud.example.req.AuthenticateDriverReq;
import wiki.zex.cloud.example.req.AuthenticateOwnerReq;
import wiki.zex.cloud.example.resp.SimpleResp;
import wiki.zex.cloud.example.service.IAuthenticateService;

import javax.validation.Valid;

@RestController
@RequestMapping("/api/v1/authenticate")
public class AuthenticateController {

    @Autowired
    private IAuthenticateService iAuthenticateService;


    @PostMapping("/shipper")
    @PreAuthorize("isAuthenticated()")
    public SimpleResp owner(Authentication authentication, @RequestBody @Valid AuthenticateOwnerReq req){
        iAuthenticateService.authOwner(authentication,req);
        return SimpleResp.SUCCESS;
    }


    @PostMapping("/driver")
    @PreAuthorize("isAuthenticated()")
    public SimpleResp driver(Authentication authentication, @RequestBody @Valid AuthenticateDriverReq req){
        iAuthenticateService.authDriver(authentication,req);
        return SimpleResp.SUCCESS;
    }

}
