package wiki.zex.cloud.example.enums;

import com.baomidou.mybatisplus.core.enums.IEnum;

public enum HttpMethodType implements IEnum<Integer> {

    ALL(0),
    GET(1),
    POST(2),
    PUT(3),
    DELETE(4);

    HttpMethodType(int code) {
        this.value = code;
    }

    private int value;

    @Override
    public Integer getValue() {
        return this.value;
    }

}