package wiki.zex.cloud.example.controller;


import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.lly835.bestpay.enums.BestPayTypeEnum;
import com.lly835.bestpay.model.PayResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import wiki.zex.cloud.example.entity.FoDeliverGoods;
import wiki.zex.cloud.example.req.FoDeliverGoodsReq;
import wiki.zex.cloud.example.req.Pageable;
import wiki.zex.cloud.example.resp.FoDeliverDetails;
import wiki.zex.cloud.example.resp.FoDeliverGoodsResp;
import wiki.zex.cloud.example.resp.SimpleResp;
import wiki.zex.cloud.example.security.MyUserDetails;
import wiki.zex.cloud.example.service.IFoDeliverGoodsService;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * <p>
 * 发货信息 前端控制器
 * </p>
 *
 * @author Zex
 * @since 2020-07-08
 */
@RestController
@RequestMapping("/api/v1/deliver/goods")
public class FoDeliverGoodsController {

    @Autowired
    private IFoDeliverGoodsService iFoDeliverGoodsService;

    @PostMapping
    @PreAuthorize("isAuthenticated()")
    public FoDeliverGoods create(@RequestBody @Valid FoDeliverGoodsReq req, Authentication authentication) {
        return iFoDeliverGoodsService.create(req, authentication);
    }


    @PostMapping("/{id}/driver/pay")
    @PreAuthorize("isAuthenticated()")
    public PayResponse driverPay(@PathVariable Long id , Authentication authentication,@RequestParam BestPayTypeEnum channelType , @RequestParam  BigDecimal amount, @RequestParam  BigDecimal freightAmount, HttpServletRequest request) {
        return iFoDeliverGoodsService.driverPay(id,authentication,channelType,amount,freightAmount,request);
    }


    @GetMapping("/{id}")
    public FoDeliverDetails details(@PathVariable  Long id,Authentication authentication){
        return iFoDeliverGoodsService.details(id,authentication);
    }

    @PutMapping("/{id}")
    @PreAuthorize("isAuthenticated()")
    public FoDeliverGoods update(@PathVariable  Long id ,@RequestBody @Valid FoDeliverGoodsReq req, Authentication authentication) {
        return iFoDeliverGoodsService.update(id,req, authentication);
    }

    @PutMapping("/{id}/markStatus")
    @PreAuthorize("isAuthenticated()")
    public SimpleResp update(@PathVariable  Long id ,@RequestParam  Integer markStatus,Authentication authentication) {
        MyUserDetails myUserDetails = (MyUserDetails) authentication.getPrincipal();
        iFoDeliverGoodsService.update(new LambdaUpdateWrapper<FoDeliverGoods>()
                .set(FoDeliverGoods::getMarkStatus, markStatus)
                .eq(FoDeliverGoods::getId, id)
                .eq(FoDeliverGoods::getUserId,myUserDetails.getId()));
        return  SimpleResp.SUCCESS;
    }

    @GetMapping
    public IPage<FoDeliverGoodsResp> page(Pageable pageable, Long userId, Integer status, Integer deleteStatus,
                                          Integer markStatus, LocalDateTime startAt, LocalDateTime endAt, LocalDateTime loadStartAt,LocalDateTime loadEndAt,
                                          String loadProvinceCode, String loadCityCode, String loadDistrictCode, String unloadProvinceCode,
                                          String unloadCityCode, String unloadDistrictCode,String loadAreas,String unloadAreas, String carType, String weights, String carLongs , String carModels, String categoryName, String order) {
        return iFoDeliverGoodsService.queryList(pageable.convert(),userId,status,deleteStatus,markStatus,startAt,endAt,loadStartAt,loadEndAt,loadProvinceCode,loadCityCode,loadDistrictCode,unloadProvinceCode,unloadCityCode,unloadDistrictCode,
                loadAreas,unloadAreas, carType,weights,carLongs,carModels,categoryName,order);
//        return iFoDeliverGoodsService.page(pageable.convert(), new LambdaQueryWrapper<FoDeliverGoods>()
//                .eq(userId != null, FoDeliverGoods::getUserId, userId)
//                .eq(status != null, FoDeliverGoods::getStatus, status)
//                .eq(deleteStatus != null, FoDeliverGoods::getDeleteStatus, deleteStatus)
//                .eq(markStatus != null, FoDeliverGoods::getMarkStatus, markStatus)
//                .eq(StringUtils.isNotBlank(loadProvinceCode),FoDeliverGoods::getLoadProvinceCode,loadProvinceCode)
//                .eq(StringUtils.isNotBlank(loadCityCode),FoDeliverGoods::getLoadCityCode,loadCityCode)
//                .eq(StringUtils.isNotBlank(loadDistrictCode),FoDeliverGoods::getLoadDistrictCode,loadDistrictCode)
//                .eq(StringUtils.isNotBlank(unloadProvinceCode),FoDeliverGoods::getUnloadProvinceCode,unloadProvinceCode)
//                .eq(StringUtils.isNotBlank(unloadCityCode),FoDeliverGoods::getUnloadCityCode,unloadCityCode)
//                .eq(StringUtils.isNotBlank(unloadDistrictCode),FoDeliverGoods::getUnloadDistrictCode,unloadDistrictCode)
//                .ge(startAt != null ,FoDeliverGoods::getCreateAt,startAt)
//                .le(endAt != null ,FoDeliverGoods::getCreateAt,endAt));
    }

    @GetMapping("/self")
    @PreAuthorize("isAuthenticated()")
    public IPage<FoDeliverGoodsResp> page(Pageable pageable,  Authentication authentication,Integer status,Integer deleteStatus,Integer markStatus, LocalDateTime startAt, LocalDateTime endAt, LocalDateTime loadStartAt,LocalDateTime loadEndAt,String loadProvinceCode,String loadCityCode,String loadDistrictCode,String unloadProvinceCode,
                                      String unloadCityCode,String unloadDistrictCode,String loadAreas,String unloadAreas,String carType, String weights, String carLongs ,String carModels, String categoryName,String order) {
        MyUserDetails myUserDetails = (MyUserDetails) authentication.getPrincipal();
        return page(pageable, myUserDetails.getId(), status, deleteStatus, markStatus,startAt,endAt,loadStartAt,loadEndAt,loadProvinceCode,loadCityCode,loadDistrictCode,unloadProvinceCode,unloadCityCode,unloadDistrictCode,loadAreas,unloadAreas,carType,weights,carLongs,carModels,categoryName,order);
    }


    @DeleteMapping("/{id}")
    @PreAuthorize("isAuthenticated()")
    public SimpleResp delete(@PathVariable Long id,Authentication authentication) {
        MyUserDetails myUserDetails = (MyUserDetails) authentication.getPrincipal();
        iFoDeliverGoodsService.update(new LambdaUpdateWrapper<FoDeliverGoods>()
                .set(FoDeliverGoods::getDeleteStatus, 1)
                .set(FoDeliverGoods::getStatus, 0)
                .eq(FoDeliverGoods::getId, id)
                .eq(FoDeliverGoods::getUserId,myUserDetails.getId()));
        return  SimpleResp.SUCCESS;
    }
}
