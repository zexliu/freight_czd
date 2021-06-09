package wiki.zex.cloud.example.controller;


import com.baomidou.mybatisplus.core.metadata.IPage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import wiki.zex.cloud.example.entity.FoCall;
import wiki.zex.cloud.example.req.FoCallReq;
import wiki.zex.cloud.example.req.Pageable;
import wiki.zex.cloud.example.resp.FoCallResp;
import wiki.zex.cloud.example.service.IFoCallService;

import javax.validation.Valid;

/**
 * <p>
 * 前端控制器
 * </p>
 *
 * @author Zex
 * @since 2020-07-14
 */
@RestController
@RequestMapping("/api/v1/calls")
public class FoCallController {


    @Autowired
    private IFoCallService iFoCallService;

    @PostMapping
    @PreAuthorize("isAuthenticated()")
    public FoCall create(@RequestBody @Valid FoCallReq req, Authentication authentication) {
        return iFoCallService.create(req, authentication);
    }


    @GetMapping
    @PreAuthorize("isAuthenticated()")
    public IPage<FoCallResp> list(Pageable pageable, Authentication authentication) {
        return iFoCallService.list(pageable.convert(),authentication);
    }

}
