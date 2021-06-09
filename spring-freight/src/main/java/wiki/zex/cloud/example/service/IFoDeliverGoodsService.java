package wiki.zex.cloud.example.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.lly835.bestpay.enums.BestPayTypeEnum;
import com.lly835.bestpay.model.PayResponse;
import org.springframework.security.core.Authentication;
import wiki.zex.cloud.example.entity.FoDeliverGoods;
import com.baomidou.mybatisplus.extension.service.IService;
import wiki.zex.cloud.example.entity.FoProtocol;
import wiki.zex.cloud.example.req.FoDeliverGoodsReq;
import wiki.zex.cloud.example.resp.FoDeliverDetails;
import wiki.zex.cloud.example.resp.FoDeliverGoodsResp;

import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * <p>
 * 发货信息 服务类
 * </p>
 *
 * @author Zex
 * @since 2020-07-08
 */
public interface IFoDeliverGoodsService extends IService<FoDeliverGoods> {

    FoDeliverGoods create(FoDeliverGoodsReq req, Authentication authentication);

    FoDeliverGoods update(Long id, FoDeliverGoodsReq req, Authentication authentication);

    IPage<FoDeliverGoodsResp> queryList(Page<FoDeliverGoods> convert, Long userId, Integer status,
                                        Integer deleteStatus, Integer markStatus, LocalDateTime startAt,
                                        LocalDateTime endAt,LocalDateTime loadStartAt,LocalDateTime loadEndAt,
                                        String loadProvinceCode, String loadCityCode, String loadDistrictCode,
                                        String unloadProvinceCode, String unloadCityCode, String unloadDistrictCode,
                                        String loadAreas,String unloadAreas,
                                        String carType, String weights, String carLongs, String carModels, String categoryName, String order);

    FoDeliverDetails details(Long id, Authentication authentication);

    PayResponse driverPay(Long id, Authentication authentication, BestPayTypeEnum channelType, BigDecimal amount, BigDecimal freightAmount, HttpServletRequest request);


    FoProtocol getByOrderId(Long orderId);


}
