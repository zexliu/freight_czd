package wiki.zex.cloud.example.message;

import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import wiki.zex.cloud.example.config.MqConfig;
import wiki.zex.cloud.example.enums.OrderType;
import wiki.zex.cloud.example.entity.FoOrder;
import wiki.zex.cloud.example.enums.UserType;
import wiki.zex.cloud.example.service.IFoOrderProcessService;
import wiki.zex.cloud.example.service.IFoOrderService;

@Component
@Slf4j
public class MessageReceiver {

    @Autowired
    private IFoOrderService iFoOrderService;

    @Autowired
    private IFoOrderProcessService iFoOrderProcessService;
    @RabbitListener(queues = MqConfig.DElAY_PAY_QUEUE)
    public void cancelOrder(OrderCreatedMessage msg){
        log.info("received order created msg  = {}",msg);
        FoOrder order = iFoOrderService.getById(msg.getOrderId());
        if (order == null || order.getDriverPayStatus() || order.getConfirmStatus()){
            return;
        }
        //设置订单为已过期
        order.setCancelStatus(true);
        iFoOrderService.updateById(order);
        iFoOrderProcessService.createProcess(order.getId(),order,0L, UserType.SYSTEM, OrderType.SYSTEM_CANCEL_ORDER, null);
    }
}
