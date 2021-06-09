package wiki.zex.cloud.example.enums;

import com.baomidou.mybatisplus.core.enums.IEnum;

public enum AuditTargetType implements IEnum<Integer> {

    USER_AUTHENTICATION(1),DRIVER_AUTHENTICATION(2);

    AuditTargetType(int code) {
        this.value = code;
    }

    private int value;

    @Override
    public Integer getValue() {
        return this.value;
    }

}