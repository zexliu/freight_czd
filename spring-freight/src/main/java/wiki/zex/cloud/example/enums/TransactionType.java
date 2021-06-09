package wiki.zex.cloud.example.enums;

import com.baomidou.mybatisplus.core.enums.IEnum;

public enum TransactionType implements IEnum<Integer> {
    DRIVER_DEPOSIT(1,"司机支付定金"),
    REFUND_DRIVER_DEPOSIT(-1,"退还司机定金"),
    MASTER_FREIGHT(2,"用户支付运费"),
    ;
    private final String description;
    private final Integer value;

    TransactionType(Integer value, String description) {
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
