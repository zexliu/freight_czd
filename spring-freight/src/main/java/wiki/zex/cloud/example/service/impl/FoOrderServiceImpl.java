package wiki.zex.cloud.example.service.impl;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.lly835.bestpay.enums.BestPayTypeEnum;
import com.lly835.bestpay.model.PayRequest;
import com.lly835.bestpay.model.PayResponse;
import com.lly835.bestpay.model.RefundRequest;
import com.lly835.bestpay.model.RefundResponse;
import com.lly835.bestpay.service.impl.BestPayServiceImpl;
import org.apache.commons.lang3.StringUtils;
import org.springframework.amqp.core.MessageDeliveryMode;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.transaction.annotation.Transactional;
import wiki.zex.cloud.example.async.DeliveryGoodsAsyncTask;
import wiki.zex.cloud.example.config.MqConfig;
import wiki.zex.cloud.example.entity.*;
import wiki.zex.cloud.example.enums.OrderType;
import wiki.zex.cloud.example.enums.PayType;
import wiki.zex.cloud.example.enums.TransactionType;
import wiki.zex.cloud.example.enums.UserType;
import wiki.zex.cloud.example.exception.ForbiddenException;
import wiki.zex.cloud.example.exception.NotFoundException;
import wiki.zex.cloud.example.mapper.FoOrderMapper;
import wiki.zex.cloud.example.message.OrderCreatedMessage;
import wiki.zex.cloud.example.req.FoEvaluationReq;
import wiki.zex.cloud.example.req.FoOrderReq;
import wiki.zex.cloud.example.req.Pageable;
import wiki.zex.cloud.example.resp.OrderDetails;
import wiki.zex.cloud.example.resp.OrderResp;
import wiki.zex.cloud.example.resp.PushOrderMsg;
import wiki.zex.cloud.example.resp.SimpleDriverResp;
import wiki.zex.cloud.example.security.MyUserDetails;
import wiki.zex.cloud.example.service.*;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;
import wiki.zex.cloud.example.utils.DecimalUtils;
import wiki.zex.cloud.example.utils.NetWorkUtil;

import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * <p>
 * 服务实现类
 * </p>
 *
 * @author Zex
 * @since 2020-07-17
 */
@Service
public class FoOrderServiceImpl extends ServiceImpl<FoOrderMapper, FoOrder> implements IFoOrderService {

    @Autowired
    private RabbitTemplate rabbitTemplate;
    @Autowired
    private DeliveryGoodsAsyncTask deliveryGoodsAsyncTask;

    @Autowired
    private IFoDeliverGoodsService iFoDeliverGoodsService;

    @Autowired
    private IFoOrderProcessService iFoOrderProcessService;

    @Autowired
    private IRefundOrderService iRefundOrderService;

    @Autowired
    private BestPayServiceImpl driverPayService;
    private BestPayServiceImpl masterPayService;

    @Autowired
    private IPayOrderService iPayOrderService;

    @Autowired
    private IFoTransactionService iFoTransactionService;

    @Autowired
    private IFoEvaluationService iFoEvaluationService;

    @Override
    public IPage<SimpleDriverResp> orderedDrivers(Pageable pageable, Long id) {
        return baseMapper.orderedDrivers(pageable.convert(), id);
    }

    @Override
    @Transactional
    public FoOrder create(FoOrderReq req, MyUserDetails myUserDetails, boolean isUser) {

        FoDeliverGoods deliverGoods = iFoDeliverGoodsService.getById(req.getDeliveryId());
        if (deliverGoods == null) {
            throw new NotFoundException();
        }
        FoOrder foOrder = new FoOrder();
        BeanUtils.copyProperties(req, foOrder);
        foOrder.setUserId(deliverGoods.getUserId());
        foOrder.setDriverPayStatus(!isUser); //司机支付状态
        save(foOrder);
        deliverGoods.setStatus(0);
        iFoDeliverGoodsService.updateById(deliverGoods);

        PushOrderMsg pushOrderMsg = new PushOrderMsg();
        pushOrderMsg.setAmount(foOrder.getAmount());
        pushOrderMsg.setCarLongs(deliverGoods.getCarLongs());
        pushOrderMsg.setCarModels(deliverGoods.getCarModels());
        pushOrderMsg.setDeliveryId(deliverGoods.getId());
        pushOrderMsg.setFreightAmount(req.getFreightAmount());
        pushOrderMsg.setLoadProvinceCode(deliverGoods.getLoadProvinceCode());
        pushOrderMsg.setLoadCityCode(deliverGoods.getLoadCityCode());
        pushOrderMsg.setLoadDistrictCode(deliverGoods.getLoadDistrictCode());
        pushOrderMsg.setUnloadCityCode(deliverGoods.getUnloadCityCode());
        pushOrderMsg.setUnloadProvinceCode(deliverGoods.getUnloadProvinceCode());
        pushOrderMsg.setUnloadDistrictCode(deliverGoods.getUnloadDistrictCode());
        pushOrderMsg.setMobile(myUserDetails.getMobile());
        pushOrderMsg.setNickname(myUserDetails.getNickname());
        pushOrderMsg.setOrderId(foOrder.getId());
        pushOrderMsg.setVolume(deliverGoods.getVolume());
        pushOrderMsg.setWeight(deliverGoods.getWeight());
        pushOrderMsg.setLoadStartAt(deliverGoods.getLoadStartAt());
        pushOrderMsg.setLoadEndAt(deliverGoods.getLoadEndAt());
        deliveryGoodsAsyncTask.pushOrder(!isUser, isUser ? foOrder.getDriverId() : foOrder.getUserId(), pushOrderMsg);
        if (isUser) {
            //待支付定金 定时任务
            OrderCreatedMessage message = new OrderCreatedMessage();
            message.setOrderId(foOrder.getId());
            rabbitTemplate.convertAndSend(MqConfig.DElAY_PAY_EXCHANGE, MqConfig.DElAY_PAY_QUEUE, message, processor -> {
                processor.getMessageProperties().setDeliveryMode(MessageDeliveryMode.PERSISTENT);
                processor.getMessageProperties().setDelay(30 * 60 * 1000); //30分钟...
                return processor;
            });
        }
        iFoOrderProcessService.createProcess(foOrder.getId(), foOrder, isUser ? foOrder.getUserId() : foOrder.getDriverId(), isUser ? UserType.USER : UserType.DRIVER, isUser ? OrderType.CREATE_ORDER : OrderType.DRIVER_CREATE_ORDER, null);
        return foOrder;
    }

    @Override
    @Transactional
    public FoOrder confirm(Long id, Authentication authentication) {
        FoOrder foOrder = validOrder(id);
        MyUserDetails myUserDetails = (MyUserDetails) authentication.getPrincipal();
        if (!foOrder.getUserId().equals(myUserDetails.getId())) {
            throw new ForbiddenException();
        }
        if (foOrder.getConfirmStatus()) {
            throw new ForbiddenException();
        }

        foOrder.setConfirmStatus(true);
        updateById(foOrder);
        iFoOrderProcessService.createProcess(id, foOrder, myUserDetails.getId(), UserType.USER, OrderType.USER_CONFIRM_ORDER, null);
        return foOrder;
    }

    @Override
    public FoEvaluation evaluation(Long id, FoEvaluationReq req, Authentication authentication) {
        FoOrder foOrder = validOrder(id);
        MyUserDetails myUserDetails = (MyUserDetails) authentication.getPrincipal();
        FoEvaluation foEvaluation = new FoEvaluation();

        if (myUserDetails.getClientId().equals("master_client") ) {
            if (!foOrder.getUserId().equals(myUserDetails.getId())|| foOrder.getEvaluateStatus()) {
                throw new ForbiddenException();
            }
            foEvaluation.setType(1);
            foEvaluation.setTargetId(foOrder.getDriverId());
            foOrder.setEvaluateStatus(true);

        } else {
            if (!foOrder.getDriverId().equals(myUserDetails.getId()) || foOrder.getDriverEvaluateStatus()) {
                throw new ForbiddenException();
            }
            foEvaluation.setType(2);
            foEvaluation.setTargetId(foOrder.getUserId());
            foOrder.setDriverEvaluateStatus(true);
        }
        foEvaluation.setUserId(myUserDetails.getId());
        foEvaluation.setAnonymous(req.getAnonymous());
        foEvaluation.setDescription(req.getDescription());
        foEvaluation.setTags(req.getTags());
        foEvaluation.setOrderId(id);
        foEvaluation.setLevel(req.getLevel());
        updateById(foOrder);
        iFoEvaluationService.save(foEvaluation);
        iFoOrderProcessService.createProcess(id, foOrder, myUserDetails.getId(), myUserDetails.getClientId().equals("master_client") ? UserType.USER : UserType.DRIVER, myUserDetails.getClientId().equals("master_client") ? OrderType.USER_EVALUATION : OrderType.DRIVER_EVALUATION, null);
        return foEvaluation;

    }

    @Override
    public PayResponse driverPay(Long id, MyUserDetails myUserDetails, BestPayTypeEnum channelType, HttpServletRequest request) {
        if (!myUserDetails.getClientId().equals("driver_client")){
            throw new ForbiddenException();
        }
        FoOrder foOrder = getById(id);
        if (foOrder.getCancelStatus()){
            throw new ForbiddenException("订单已取消");
        }
        if (foOrder.getConfirmStatus()){
            throw new ForbiddenException("订单已完成");
        }
        if (!foOrder.getDriverId().equals(myUserDetails.getId())){
            throw new ForbiddenException("订单不属于该司机");
        }
        if (foOrder.getDriverPayStatus()){
            throw new ForbiddenException("已经支付过定金了");
        }

        PayOrder payOrder = new PayOrder();
        payOrder.setAmount(foOrder.getAmount());
        payOrder.setChannelType(channelType.name());
        payOrder.setCreateAt(LocalDateTime.now());
        payOrder.setFoDeliveryId(foOrder.getDeliveryId());
        payOrder.setOrderType(PayType.DRIVER_DEPOSIT);
        payOrder.setStatus(0);
        payOrder.setSubject("支付定金");
        payOrder.setUserId(myUserDetails.getId());
        payOrder.setFoOrderId(id);
        iPayOrderService.save(payOrder);

        PayRequest payRequest = createPayRequest(channelType, request, payOrder);

        return driverPayService.pay(payRequest);
    }

    private PayRequest createPayRequest(BestPayTypeEnum channelType, HttpServletRequest request, PayOrder payOrder) {
        PayRequest payRequest = new PayRequest();
        payRequest.setAttach(payOrder.getBody());
        payRequest.setOrderName(payOrder.getSubject());
        payRequest.setOrderAmount(payOrder.getAmount().doubleValue());
        payRequest.setOrderId(payOrder.getId().toString());
        payRequest.setSpbillCreateIp(NetWorkUtil.getRequestIp(request));
        payRequest.setPayTypeEnum(channelType);
        return payRequest;
    }

    @Override
    public PayResponse masterPay(Long id, MyUserDetails myUserDetails, BestPayTypeEnum channelType, BigDecimal amount, HttpServletRequest request) {
        if (!myUserDetails.getClientId().equals("master_client")){
            throw new ForbiddenException();
        }
        FoOrder foOrder = getById(id);
        if (foOrder.getCancelStatus()){
            throw new ForbiddenException("订单已取消");
        }
        if (foOrder.getConfirmStatus()){
            throw new ForbiddenException("订单已完成");
        }
        if (!foOrder.getUserId().equals(myUserDetails.getId())){
            throw new ForbiddenException("订单不属于该货主");
        }

        PayOrder payOrder = new PayOrder();
        payOrder.setAmount(amount);
        payOrder.setChannelType(channelType.name());
        payOrder.setCreateAt(LocalDateTime.now());
        payOrder.setFoDeliveryId(foOrder.getDeliveryId());
        payOrder.setOrderType(PayType.MASTER_FREIGHT);
        payOrder.setStatus(0);
        payOrder.setSubject("支付运费");
        payOrder.setUserId(myUserDetails.getId());
        payOrder.setFoOrderId(id);
        iPayOrderService.save(payOrder);
        PayRequest payRequest = createPayRequest(channelType, request, payOrder);
        return masterPayService.pay(payRequest);
    }

    @Override
    public IPage<OrderResp> list(Page<OrderResp> page, Long deliveryId, Long userId, Long driverId, Boolean confirmStatus, Boolean transportStatus, Boolean payStatus, Boolean evaluateStatus, Boolean driverEvaluateStatus, Boolean cancelStatus, Boolean refundStatus, Boolean driverPayStatus, Boolean protocolStatus, LocalDateTime startAt, LocalDateTime endAt) {
        return baseMapper.list(page, deliveryId, userId, driverId, confirmStatus, transportStatus, payStatus, evaluateStatus, driverEvaluateStatus, cancelStatus, refundStatus, driverPayStatus, protocolStatus,startAt,endAt);
    }

    @Override
    public OrderDetails details(Long id) {
        return baseMapper.details(id);
    }

    @Override
    public FoOrder cancel(Long id, Authentication authentication, String description) {
        MyUserDetails myUserDetails = (MyUserDetails) authentication.getPrincipal();

        FoOrder foOrder = validOrder(id);

        if (StringUtils.equals(myUserDetails.getClientId(), "master_client")) {
            if (!foOrder.getUserId().equals(myUserDetails.getId())) {
                throw new ForbiddenException();
            }
        } else {
            if (!foOrder.getDriverId().equals(myUserDetails.getId())) {
                throw new ForbiddenException();
            }
        }

        if (foOrder.getCancelStatus() || foOrder.getDriverPayStatus()) {
            throw new ForbiddenException();
        }
        foOrder.setCancelStatus(true);
        updateById(foOrder);

        iFoOrderProcessService.createProcess(foOrder.getId(), foOrder, foOrder.getUserId(), UserType.USER, OrderType.USER_CANCEL_ORDER, description);
        deliveryGoodsAsyncTask.pushCancelOrder(foOrder, myUserDetails);
        return foOrder;
    }

    @Override
    @Transactional
    public FoOrder refund(Long id, Authentication authentication, String description) {
        MyUserDetails myUserDetails = (MyUserDetails) authentication.getPrincipal();
        FoOrder foOrder = validOrder(id);
        if (!foOrder.getUserId().equals(myUserDetails.getId())) {
            throw new ForbiddenException();
        }
        if (foOrder.getRefundStatus() || foOrder.getCancelStatus() || !foOrder.getDriverPayStatus()) {
            throw new ForbiddenException();
        }
        BigDecimal balance = iFoTransactionService.balance(null, null, null, null, myUserDetails.getId());

        if (DecimalUtils.lt(balance, foOrder.getAmount())) {
            throw new ForbiddenException("余额不足");
        }
        FoTransaction transaction = new FoTransaction();
        transaction.setAmount(foOrder.getAmount());
        transaction.setIncrStatus(false);
        transaction.setTargetId(foOrder.getId());
        transaction.setType(TransactionType.REFUND_DRIVER_DEPOSIT);
        transaction.setUserId(myUserDetails.getId());
        iFoTransactionService.save(transaction);

        RefundRequest refundRequest = new RefundRequest();
        PayOrder payOrder = iPayOrderService.getByFoOrderId(id,foOrder.getDriverId());
        refundRequest.setPayTypeEnum(BestPayTypeEnum.getByName(payOrder.getChannelType()));
        refundRequest.setOrderId(payOrder.getId().toString());
        refundRequest.setOrderAmount(foOrder.getAmount().doubleValue());
        RefundResponse refund = driverPayService.refund(refundRequest);
        RefundOrder refundOrder = new RefundOrder();
        refundOrder.setAmount(BigDecimal.valueOf(refund.getOrderAmount()));
        refundOrder.setChannelType(payOrder.getChannelType());
        refundOrder.setDescription(description);
        refundOrder.setOrderId(payOrder.getId());
        refundOrder.setStatus(true);
        refundOrder.setThirdPartyId(refund.getOutRefundNo());
        refundOrder.setUserId(payOrder.getUserId());
        iRefundOrderService.save(refundOrder);
        foOrder.setRefundStatus(true);
        updateById(foOrder);
        iFoOrderProcessService.createProcess(foOrder.getId(), foOrder, foOrder.getUserId(), UserType.USER, OrderType.USER_REFUND_DRIVER_ORDER, description);
        return foOrder;
    }


    private FoOrder validOrder(Long id) {

        FoOrder foOrder = getById(id);
        if (foOrder == null) {
            throw new NotFoundException("订单不存在");
        }
        return foOrder;
    }
}
