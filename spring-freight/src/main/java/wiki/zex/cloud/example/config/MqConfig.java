package wiki.zex.cloud.example.config;

import org.springframework.amqp.core.*;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.HashMap;
import java.util.Map;

@Configuration
public class MqConfig {

    public static final String DElAY_PAY_QUEUE = "order.delay.created";
    public static final String DElAY_PAY_EXCHANGE = "order.delay.created";
    public static final String DElAY_PAY_ROUTINGKEY = "order.delay.created";

    public static final String DElAY_COMMENT_QUEUE = "order.delay.used";
    public static final String DElAY_COMMENT_EXCHANGE = "order.delay.used";
    public static final String DElAY_COMMENT_ROUTINGKEY = "order.delay.used";

    //延时支付
    @Bean
    public Queue delayPayQueue() {
        return new Queue(DElAY_PAY_QUEUE, true);
    }

    @Bean
    public CustomExchange delayPayExchange(){
        Map<String,Object> map = new HashMap<>();
        map.put("x-delayed-type", "direct");
        return new CustomExchange(
                DElAY_PAY_EXCHANGE, "x-delayed-message", true, false, map);
    }

    // 绑定延时队列与交换机
    @Bean
    public Binding delayPayBind(Queue delayPayQueue,CustomExchange delayPayExchange) {
        return BindingBuilder.bind(delayPayQueue).to(delayPayExchange).with(DElAY_PAY_ROUTINGKEY).noargs();
    }



    //延时评论
    @Bean
    public Queue delayCommentQueue() {
        return new Queue(DElAY_COMMENT_QUEUE, true);
    }

    @Bean
    public CustomExchange delayCommentExchange(){
        Map<String,Object> map = new HashMap<>();
        map.put("x-delayed-type", "direct");
        return new CustomExchange(
                DElAY_COMMENT_EXCHANGE, "x-delayed-message", true, false, map);
    }

    // 绑定延时队列与交换机
    @Bean
    public Binding delayCommentBind(Queue delayCommentQueue,CustomExchange delayCommentExchange) {
        return BindingBuilder.bind(delayCommentQueue).to(delayCommentExchange).with(DElAY_COMMENT_ROUTINGKEY).noargs();
    }

}
