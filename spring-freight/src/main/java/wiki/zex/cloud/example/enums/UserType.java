package wiki.zex.cloud.example.enums;

import com.baomidou.mybatisplus.core.enums.IEnum;

public enum UserType implements IEnum<Integer> {
    USER(1),
    SYSTEM(0),
    DRIVER(2);
    private final Integer value;

    UserType(Integer value) {
        this.value = value;
    }

    @Override
    public Integer getValue() {
        return value;
    }
}
