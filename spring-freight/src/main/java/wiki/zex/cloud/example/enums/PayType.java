package wiki.zex.cloud.example.enums;

import com.baomidou.mybatisplus.core.enums.IEnum;

public enum PayType implements IEnum<Integer> {
    DRIVER_GOODS_DEPOSIT(1,"司机通过货源支付定金"),
    DRIVER_DEPOSIT(2,"司机支付定金"),
    MASTER_FREIGHT(3,"用户支付运费"),
    ;
    private final String description;
    private final Integer value;

    PayType(Integer value, String description) {
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
