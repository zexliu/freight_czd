package wiki.zex.cloud.example.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;
import wiki.zex.cloud.example.entity.FoDeliverGoods;
import wiki.zex.cloud.example.entity.FoDriverExtension;
import wiki.zex.cloud.example.entity.FoOrder;
import wiki.zex.cloud.example.resp.MeDriverStatisticalResp;
import wiki.zex.cloud.example.resp.MeStatisticalResp;
import wiki.zex.cloud.example.security.MyUserDetails;
import wiki.zex.cloud.example.service.*;

import java.math.BigDecimal;

@Service
public class StatisticalServiceImpl implements IStatisticalService {

    @Autowired
    private IFoTransactionService iFoTransactionService;

    @Autowired
    private IFoDeliverGoodsService iFoDeliverGoodsService;

    @Autowired
    private IFoOrderService iFoOrderService;

    @Autowired
    private IFoDriverExtensionService iFoDriverExtensionService;

    @Override
    public Object meStatisticalResp(Authentication authentication) {
        MyUserDetails myUserDetails = (MyUserDetails) authentication.getPrincipal();
        if (myUserDetails.getClientId().equals("master_client")){
            MeStatisticalResp resp = new MeStatisticalResp();
            BigDecimal balance = iFoTransactionService.balance(null, null, null, null, myUserDetails.getId());
            resp.setTransactionAmount(balance);
            int deliveryCount = iFoDeliverGoodsService.count(new LambdaQueryWrapper<FoDeliverGoods>().eq(FoDeliverGoods::getUserId, myUserDetails.getId()));
            resp.setDeliveryCount(deliveryCount);
            int orderCount = iFoOrderService.count(new LambdaQueryWrapper<FoOrder>().eq(FoOrder::getUserId, myUserDetails.getId()));
            resp.setOrderCount(orderCount);
            return resp;
        }else {
            BigDecimal balance = iFoTransactionService.balance(null, null, null, null, myUserDetails.getId());
            FoDriverExtension extension = iFoDriverExtensionService.getByUserId(myUserDetails.getId());
            MeDriverStatisticalResp resp = new MeDriverStatisticalResp();
            resp.setTransactionAmount(balance);
            resp.setCarLong(extension.getCarLong());
            resp.setCarModel(extension.getCarModel());
            return  resp;
        }

    }
}
