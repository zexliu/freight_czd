package wiki.zex.cloud.example.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.lly835.bestpay.enums.BestPayTypeEnum;
import com.lly835.bestpay.model.PayResponse;
import org.springframework.security.core.Authentication;
import wiki.zex.cloud.example.entity.FoEvaluation;
import wiki.zex.cloud.example.entity.FoOrder;
import com.baomidou.mybatisplus.extension.service.IService;
import wiki.zex.cloud.example.req.FoEvaluationReq;
import wiki.zex.cloud.example.req.FoOrderReq;
import wiki.zex.cloud.example.req.Pageable;
import wiki.zex.cloud.example.resp.OrderDetails;
import wiki.zex.cloud.example.resp.OrderResp;
import wiki.zex.cloud.example.resp.SimpleDriverResp;
import wiki.zex.cloud.example.security.MyUserDetails;

import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author Zex
 * @since 2020-07-17
 */
public interface IFoOrderService extends IService<FoOrder> {

    IPage<SimpleDriverResp> orderedDrivers(Pageable pageable, Long id);



    IPage<OrderResp> list(Page<OrderResp> page, Long deliveryId, Long userId, Long driverId, Boolean confirmStatus, Boolean transportStatus, Boolean payStatus, Boolean evaluateStatus, Boolean driverEvaluateStatus, Boolean cancelStatus, Boolean refundStatus, Boolean driverPayStatus, Boolean protocolStatus, LocalDateTime startAt, LocalDateTime endAt);

    OrderDetails details(Long id);

    FoOrder cancel(Long id, Authentication authentication, String description);

    FoOrder refund(Long id, Authentication authentication, String description);


    FoOrder create(FoOrderReq req, MyUserDetails myUserDetails, boolean isUser);

    FoOrder confirm(Long id, Authentication authentication);

    FoEvaluation evaluation(Long id, FoEvaluationReq req, Authentication authentication);

    PayResponse driverPay(Long id, MyUserDetails myUserDetails, BestPayTypeEnum channelType, HttpServletRequest request);


    PayResponse masterPay(Long id, MyUserDetails myUserDetails, BestPayTypeEnum channelType, BigDecimal amount, HttpServletRequest request);

}
