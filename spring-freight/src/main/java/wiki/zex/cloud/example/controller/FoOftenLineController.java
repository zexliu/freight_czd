package wiki.zex.cloud.example.controller;


import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import wiki.zex.cloud.example.entity.FoDeliverGoods;
import wiki.zex.cloud.example.entity.FoOftenLine;
import wiki.zex.cloud.example.req.FoOftenLineReq;
import wiki.zex.cloud.example.req.Pageable;
import wiki.zex.cloud.example.resp.SimpleResp;
import wiki.zex.cloud.example.security.MyUserDetails;
import wiki.zex.cloud.example.service.IFoOftenLineService;

import javax.validation.Valid;
import java.time.LocalDateTime;

/**
 * <p>
 *  前端控制器
 * </p>
 *
 * @author Zex
 * @since 2020-07-12
 */
@RestController
@RequestMapping("/api/v1/often/lines")
public class FoOftenLineController {

    @Autowired
    private IFoOftenLineService iFoOftenLineService;

    @GetMapping
    @PreAuthorize("isAuthenticated()")
    public IPage<FoOftenLine> page(Pageable pageable, Authentication authentication) {
        return iFoOftenLineService.page(pageable.convert(),authentication);
    }
    @PostMapping
    @PreAuthorize("isAuthenticated()")
    public FoOftenLine create(@Valid @RequestBody FoOftenLineReq req, Authentication authentication) {
        return iFoOftenLineService.create(req,authentication);
    }

    @PutMapping("/{id}")
    @PreAuthorize("isAuthenticated()")
    public FoOftenLine update(@PathVariable  Long id,@Valid @RequestBody FoOftenLineReq req, Authentication authentication) {
        return iFoOftenLineService.update(id,req,authentication);
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("isAuthenticated()")
    public SimpleResp delete(@PathVariable Long id, Authentication authentication){
        MyUserDetails myUserDetails = (MyUserDetails) authentication.getPrincipal();
         iFoOftenLineService.remove(new LambdaUpdateWrapper<FoOftenLine>()
                .eq(FoOftenLine::getId,id)
                .eq(FoOftenLine::getUserId,myUserDetails.getId()));
        return SimpleResp.SUCCESS;
    }


}
