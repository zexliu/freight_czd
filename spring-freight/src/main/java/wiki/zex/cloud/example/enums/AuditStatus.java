package wiki.zex.cloud.example.enums;

import com.baomidou.mybatisplus.core.enums.IEnum;

public enum AuditStatus implements IEnum<Integer> {

    PENDING(1),
    PASSED(2),
    REJECTED(3);
    AuditStatus(int code) {
        this.value = code;
    }
    private int value;

    @Override
    public Integer getValue() {
        return this.value;
    }

}