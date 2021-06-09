package wiki.zex.cloud.example.service;

import com.lly835.bestpay.model.PayResponse;
import wiki.zex.cloud.example.entity.PayOrder;
import com.baomidou.mybatisplus.extension.service.IService;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author Zex
 * @since 2020-07-30
 */
public interface IPayOrderService extends IService<PayOrder> {

    void onPayHook(PayResponse response);

    PayOrder getByFoOrderId(Long id, Long driverId);

}
