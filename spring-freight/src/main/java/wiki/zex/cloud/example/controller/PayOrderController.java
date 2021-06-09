package wiki.zex.cloud.example.controller;


import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import org.springframework.web.bind.annotation.RestController;
import wiki.zex.cloud.example.entity.PayOrder;
import wiki.zex.cloud.example.enums.OrderType;
import wiki.zex.cloud.example.enums.PayType;
import wiki.zex.cloud.example.req.Pageable;
import wiki.zex.cloud.example.service.IPayOrderService;

import java.time.LocalDateTime;

/**
 * <p>
 * 前端控制器
 * </p>
 *
 * @author Zex
 * @since 2020-07-30
 */
@RestController
@RequestMapping("/api/v1/order/pay")
public class PayOrderController {

    @Autowired
    private IPayOrderService iPayOrderService;

    @GetMapping
    public IPage<PayOrder> list(Pageable pageable, String orderId, Long userId, String channelType,
                                String thirdPartyId, PayType orderType, Integer status,
                                LocalDateTime startAt, LocalDateTime endAt) {
        return iPayOrderService.page(pageable.convert(), new LambdaQueryWrapper<PayOrder>()
                .like(StringUtils.isNotBlank(orderId), PayOrder::getFoOrderId, orderId)
                .eq(userId != null, PayOrder::getUserId, userId)
                .eq(StringUtils.isNotBlank(channelType), PayOrder::getChannelType, channelType)
                .like(StringUtils.isNotBlank(thirdPartyId), PayOrder::getThirdPartyId, thirdPartyId)
                .eq(orderType != null, PayOrder::getOrderType, orderType)
                .eq(status != null, PayOrder::getStatus, status)
                .ge(startAt != null, PayOrder::getCreateAt, startAt)
                .le(endAt != null, PayOrder::getCreateAt, endAt)
        );
    }


}
