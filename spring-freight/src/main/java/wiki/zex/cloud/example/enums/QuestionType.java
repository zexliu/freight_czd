package wiki.zex.cloud.example.enums;

import com.baomidou.mybatisplus.core.enums.IEnum;

public enum QuestionType implements IEnum<Integer> {

    SINGLE_CHOICE(0),
    MULTIPLE_CHOICE(1);
    QuestionType(int code) {
        this.value = code;
    }
    private int value;

    @Override
    public Integer getValue() {
        return this.value;
    }

}