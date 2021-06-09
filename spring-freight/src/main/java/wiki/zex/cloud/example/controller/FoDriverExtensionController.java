package wiki.zex.cloud.example.controller;


import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import wiki.zex.cloud.example.entity.FoDeliveryExtension;
import wiki.zex.cloud.example.entity.FoDriverExtension;
import wiki.zex.cloud.example.enums.AuditStatus;
import wiki.zex.cloud.example.req.FoDeliveryExtensionReq;
import wiki.zex.cloud.example.req.FoDriverExtensionReq;
import wiki.zex.cloud.example.req.Pageable;
import wiki.zex.cloud.example.resp.FoDeliveryExtensionResp;
import wiki.zex.cloud.example.resp.FoDriverExtensionResp;
import wiki.zex.cloud.example.resp.SimpleResp;
import wiki.zex.cloud.example.security.MyUserDetails;
import wiki.zex.cloud.example.service.IFoDeliveryExtensionService;
import wiki.zex.cloud.example.service.IFoDriverExtensionService;

/**
 * <p>
 *  前端控制器
 * </p>
 *
 * @author Zex
 * @since 2020-07-17
 */
@RestController
@RequestMapping("/api/v1/driver/extension")
public class FoDriverExtensionController {
    @Autowired
    private IFoDriverExtensionService iFoDriverExtensionService;

    @PostMapping
    @PreAuthorize("isAuthenticated()")
    public FoDriverExtension create(@RequestBody FoDriverExtensionReq req, Authentication authentication){
        return iFoDriverExtensionService.create(req,authentication);
    }


    @PutMapping("/{id}")
    @PreAuthorize("isAuthenticated()")
    public FoDriverExtension update(@PathVariable Long id ,@RequestBody  FoDriverExtensionReq req,Authentication authentication){
        return iFoDriverExtensionService.update(id,req,authentication);
    }



    @GetMapping("/self")
    @PreAuthorize("isAuthenticated()")
    public FoDriverExtensionResp get(Authentication authentication){
        return  iFoDriverExtensionService.get(authentication);

    }


    @GetMapping
    public IPage<FoDriverExtensionResp> list(Pageable pageable, AuditStatus auditStatus){
        return  iFoDriverExtensionService.findPage(pageable.convert(),auditStatus);
    }


}
