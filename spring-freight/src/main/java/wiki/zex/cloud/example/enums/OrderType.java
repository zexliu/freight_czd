package wiki.zex.cloud.example.enums;

import com.baomidou.mybatisplus.core.enums.IEnum;

public enum  OrderType implements IEnum<Integer> {
    USER_CANCEL_ORDER(-1,"用户取消订单"),
    SYSTEM_CANCEL_ORDER(0,"30分钟未支付定金系统取消订单"),
    CREATE_ORDER(1,"用户指定司机创建订单")    ,
    DRIVER_CREATE_ORDER(2,"司机支付定金创建订单")    ,
    USER_REFUND_DRIVER_ORDER(3,"用户取消司机订单并退款")  ,
    PROTOCOL_CREATE(4,"发起协议申请")  ,
    PROTOCOL_AGREE(5,"同意协议内容")  ,
    USER_CONFIRM_ORDER(6,"用户确认订单"),
    DRIVER_CANCEL_ORDER(7,"司机拒绝订单"),
    USER_EVALUATION(8,"货主评价司机"),
    DRIVER_EVALUATION(9,"司机评价货主"),
    DRIVER_PAY_ORDER(10,"司机支付定金"),
    USER_PAY_FREIGHT(10,"货主支付运费"),
    ;
    private final String description;
    private final Integer value;

    OrderType(Integer value, String description) {
        this.description = description;
        this.value = value;
    }

    public String getDescription() {
        return description;
    }

    @Override
    public Integer getValue() {
        return value;
    }


}
