package wiki.zex.cloud.example.controller;


import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import wiki.zex.cloud.example.entity.FoDeliveryExtension;
import wiki.zex.cloud.example.enums.AuditStatus;
import wiki.zex.cloud.example.req.FoDeliveryExtensionReq;
import wiki.zex.cloud.example.req.Pageable;
import wiki.zex.cloud.example.resp.FoDeliveryExtensionResp;
import wiki.zex.cloud.example.resp.SimpleResp;
import wiki.zex.cloud.example.security.MyUserDetails;
import wiki.zex.cloud.example.service.IFoDeliveryExtensionService;

import java.util.List;

/**
 * <p>
 * 用户发货 拓展信息 前端控制器
 * </p>
 *
 * @author Zex
 * @since 2020-07-02
 */
@RestController
@RequestMapping("/api/v1/delivery/extension")
public class FoDeliveryExtensionController {

    @Autowired
    private IFoDeliveryExtensionService iFoDeliveryExtensionService;

    @PostMapping
    @PreAuthorize("isAuthenticated()")
    public FoDeliveryExtension create(@RequestBody  FoDeliveryExtensionReq req,Authentication authentication){
        return iFoDeliveryExtensionService.create(req,authentication);
    }


    @PutMapping("/{id}")
    @PreAuthorize("isAuthenticated()")
    public FoDeliveryExtension update(@PathVariable Long id ,@RequestBody  FoDeliveryExtensionReq req,Authentication authentication){
        return iFoDeliveryExtensionService.update(id,req,authentication);
    }


    @GetMapping("/self")
    @PreAuthorize("isAuthenticated()")
    public FoDeliveryExtensionResp get(Authentication authentication){
        return  iFoDeliveryExtensionService.get(authentication);

    }


    @GetMapping
    public IPage<FoDeliveryExtensionResp> list(Pageable pageable, AuditStatus auditStatus){
        return  iFoDeliveryExtensionService.findPage(pageable.convert(),auditStatus);
    }


}
