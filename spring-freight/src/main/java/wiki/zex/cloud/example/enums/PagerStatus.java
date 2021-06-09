package wiki.zex.cloud.example.enums;

import com.baomidou.mybatisplus.core.enums.IEnum;

public enum PagerStatus implements IEnum<Integer> {

    GENERATED(0),
    SUBMITTED(1);
    PagerStatus(int code) {
        this.value = code;
    }
    private int value;

    @Override
    public Integer getValue() {
        return this.value;
    }

}