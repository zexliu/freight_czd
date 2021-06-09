package wiki.zex.cloud.example.enums;

import com.baomidou.mybatisplus.core.enums.IEnum;

public enum FeedbackStatus implements IEnum<Integer> {

    //待处理
    PENDING(1), PROCESSED(2),IGNORE(3);

    FeedbackStatus(int code) {
        this.value = code;
    }
    private int value;

    @Override
    public Integer getValue() {
        return this.value;
    }

}