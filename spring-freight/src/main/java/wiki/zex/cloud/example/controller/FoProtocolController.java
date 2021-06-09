package wiki.zex.cloud.example.controller;


import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import wiki.zex.cloud.example.entity.FoDeliverGoods;
import wiki.zex.cloud.example.entity.FoProtocol;
import wiki.zex.cloud.example.req.FoProtocolReq;
import wiki.zex.cloud.example.resp.SimpleResp;
import wiki.zex.cloud.example.security.MyUserDetails;
import wiki.zex.cloud.example.service.IFoDeliverGoodsService;
import wiki.zex.cloud.example.service.IFoProtocolService;

/**
 * <p>
 * 前端控制器
 * </p>
 *
 * @author Zex
 * @since 2020-07-30
 */
@RestController
@RequestMapping("/api/v1/protocols")
public class FoProtocolController {

    @Autowired
    private IFoProtocolService iFoProtocolService;

    @Autowired
    private IFoDeliverGoodsService iFoDeliverGoodsService;


    @GetMapping("/{orderId}")
    public FoProtocol getOne(@PathVariable("orderId") Long orderId) {
        FoProtocol protocol = iFoProtocolService.getOne(new LambdaQueryWrapper<FoProtocol>().eq(FoProtocol::getOrderId, orderId));
        if (protocol == null) {
            protocol = iFoDeliverGoodsService.getByOrderId(orderId);
        }
        return protocol;
    }


    @PostMapping
    @PreAuthorize("isAuthenticated()")
    public FoProtocol create(@RequestBody FoProtocolReq req,Authentication authentication){
        return  iFoProtocolService.create(req,authentication);
    }


    @PostMapping("/agree/{id}")
    @PreAuthorize("isAuthenticated()")
    public SimpleResp agree(@PathVariable Long id ,Authentication authentication){
          iFoProtocolService.agree(id,authentication);
        return SimpleResp.SUCCESS;
    }
}
