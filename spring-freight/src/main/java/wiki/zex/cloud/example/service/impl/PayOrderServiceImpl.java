package wiki.zex.cloud.example.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.lly835.bestpay.model.PayResponse;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.transaction.annotation.Transactional;
import wiki.zex.cloud.example.constants.RedisKeys;
import wiki.zex.cloud.example.entity.FoOrder;
import wiki.zex.cloud.example.entity.FoTransaction;
import wiki.zex.cloud.example.entity.PayOrder;
import wiki.zex.cloud.example.entity.SyUser;
import wiki.zex.cloud.example.enums.OrderType;
import wiki.zex.cloud.example.enums.TransactionType;
import wiki.zex.cloud.example.enums.UserType;
import wiki.zex.cloud.example.exception.ForbiddenException;
import wiki.zex.cloud.example.mapper.PayOrderMapper;
import wiki.zex.cloud.example.req.FoOrderReq;
import wiki.zex.cloud.example.security.MyUserDetails;
import wiki.zex.cloud.example.service.*;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;
import wiki.zex.cloud.example.utils.DecimalUtils;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.concurrent.TimeUnit;

import static wiki.zex.cloud.example.enums.PayType.*;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author Zex
 * @since 2020-07-30
 */
@Service
public class    PayOrderServiceImpl extends ServiceImpl<PayOrderMapper, PayOrder> implements IPayOrderService {

    @Autowired
    private StringRedisTemplate stringRedisTemplate;

    @Autowired
    private IFoOrderService iFoOrderService;

    @Autowired
    private IPayOrderService iPayOrderService;

    @Autowired
    private ISyUserService iSyUserService;

    @Autowired
    private IFoOrderProcessService iFoOrderProcessService;

    @Autowired
    private IFoTransactionService iFoTransactionService;

    @Override
    @Transactional
    public void onPayHook(PayResponse response) {
        //防止 微信 支付宝 重复 调用
        String repeatKey = stringRedisTemplate.opsForValue().get(RedisKeys.notifyRepeatKey(response.getOutTradeNo()));
        if (repeatKey != null) {
           return;
        }
        //设置五秒的超时时间
        stringRedisTemplate.opsForValue().set(RedisKeys.notifyRepeatKey(response.getOutTradeNo()),
                response.getOutTradeNo(), 5L, TimeUnit.SECONDS);

        PayOrder payOrder = getById(response.getOrderId());
        if (payOrder.getStatus() == 1){
            return;
        }
        if (DecimalUtils.ne(payOrder.getAmount(), BigDecimal.valueOf(response.getOrderAmount()))){
            throw new ForbiddenException();
        }
        payOrder.setStatus(1);
        payOrder.setPayAt(LocalDateTime.now());

        if (payOrder.getOrderType() == DRIVER_GOODS_DEPOSIT){
            FoOrderReq foOrderReq = new FoOrderReq();
            foOrderReq.setDriverId(payOrder.getUserId());
            foOrderReq.setFreightAmount(new BigDecimal(payOrder.getBody()));
            foOrderReq.setAmount(payOrder.getAmount());
            foOrderReq.setDeliveryId(payOrder.getFoDeliveryId());
            SyUser syUser = iSyUserService.getById(payOrder.getUserId());
            MyUserDetails myUserDetails = new MyUserDetails();
            BeanUtils.copyProperties(syUser,myUserDetails);
            FoOrder foOrder = iFoOrderService.create(foOrderReq, myUserDetails, false);
            payOrder.setFoOrderId(foOrder.getId());
            addDriverDeposit(foOrder);
        }else if (payOrder.getOrderType() == DRIVER_DEPOSIT){
            FoOrder foOrder = iFoOrderService.getById(payOrder.getFoOrderId());
            foOrder.setDriverPayStatus(true);
            iFoOrderService.updateById(foOrder);
             addDriverDeposit(foOrder);
            iFoOrderProcessService.createProcess(foOrder.getId(), foOrder, foOrder.getDriverId(), UserType.DRIVER, OrderType.DRIVER_PAY_ORDER , null);
        }else if (payOrder.getOrderType() == MASTER_FREIGHT){
            FoOrder foOrder = iFoOrderService.getById(payOrder.getFoOrderId());
            foOrder.setPayStatus(true);
            foOrder.setMasterPayAmount(DecimalUtils.add(foOrder.getMasterPayAmount(),payOrder.getAmount()));
            iFoOrderService.updateById(foOrder);
            addMasterFreight(foOrder);
            iFoOrderProcessService.createProcess(foOrder.getId(),foOrder,foOrder.getUserId(),UserType.USER,OrderType.USER_PAY_FREIGHT,null);
        }
        iPayOrderService.updateById(payOrder);

    }

    //司机支付定金 用户加钱
    private void addDriverDeposit(FoOrder foOrder) {
        FoTransaction transaction = new FoTransaction();
        transaction.setAmount(foOrder.getAmount());
        transaction.setIncrStatus(true);
        transaction.setTargetId(foOrder.getId());
        transaction.setType(TransactionType.DRIVER_DEPOSIT);
        transaction.setUserId(foOrder.getUserId());
        iFoTransactionService.save(transaction);
    }


    //用户支付运费 司机加钱
    private void addMasterFreight(FoOrder foOrder) {
        FoTransaction transaction = new FoTransaction();
        transaction.setAmount(foOrder.getAmount());
        transaction.setIncrStatus(true);
        transaction.setTargetId(foOrder.getId());
        transaction.setType(TransactionType.MASTER_FREIGHT);
        transaction.setUserId(foOrder.getUserId());
        iFoTransactionService.save(transaction);
    }

    @Override
    public PayOrder getByFoOrderId(Long id, Long driverId) {
        return getOne(new LambdaQueryWrapper<PayOrder>().eq(PayOrder::getFoOrderId,id).eq(PayOrder::getUserId,driverId).eq(PayOrder::getStatus,1));
    }
}
