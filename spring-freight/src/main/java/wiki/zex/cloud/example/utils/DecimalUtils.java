package wiki.zex.cloud.example.utils;

import java.math.BigDecimal;

public class DecimalUtils {

    public static BigDecimal divide(BigDecimal v1,BigDecimal v2){
        return v1.divide(v2,2,BigDecimal.ROUND_HALF_UP);
    }

    public static BigDecimal multiply(BigDecimal v1,BigDecimal v2){
        return v1.multiply(v2).setScale(2,BigDecimal.ROUND_HALF_UP);
    }

    public static BigDecimal add(BigDecimal v1,BigDecimal v2){
        return v1.add(v2);
    }

    public static BigDecimal subtract(BigDecimal v1,BigDecimal v2){
        return v1.subtract(v2);
    }


    //大于等于
    public static boolean ge(BigDecimal v1,BigDecimal v2){
        return v1.compareTo(v2) > -1;
    }

    //小于等于
    public static boolean le(BigDecimal v1,BigDecimal v2){
        return v1.compareTo(v2) < 1;
    }

    //大于
    public static boolean gt(BigDecimal v1,BigDecimal v2){
        return v1.compareTo(v2) > 0;
    }

    //小于
    public static boolean lt(BigDecimal v1,BigDecimal v2){
        return v1.compareTo(v2) < 0;
    }

    //等于
    public static boolean eq(BigDecimal v1,BigDecimal v2){
        return v1.compareTo(v2) == 0 ;
    }
    //不等于
    public static boolean ne(BigDecimal v1,BigDecimal v2){
        return v1.compareTo(v2) != 0 ;
    }
}
