package wiki.zex.cloud.example.enums;

import com.baomidou.mybatisplus.core.enums.IEnum;
import org.apache.commons.lang3.StringUtils;

public enum  GenderType implements IEnum<Integer> {

    UNKNOWN(0),
    MALE(1),
    FEMALE(2);
    GenderType(int code) {
        this.value = code;
    }
    private int value;

    @Override
    public Integer getValue() {
        return this.value;
    }

}