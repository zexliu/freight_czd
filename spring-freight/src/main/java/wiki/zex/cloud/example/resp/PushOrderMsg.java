package wiki.zex.cloud.example.resp;


import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class PushOrderMsg {

    private  Long orderId;

    private Long deliveryId;

    private String loadProvinceCode;

    private String loadCityCode;

    private String loadDistrictCode;

    private String unloadProvinceCode;
    private String unloadCityCode;
    private String unloadDistrictCode;

    private String carLongs;

    private String carModels;
    //傻逼需求修改
    private String weight;
    //傻逼需求修改
    private String volume;
    private String mobile;

    private String nickname;

    private BigDecimal amount;

    private BigDecimal freightAmount;
    private LocalDateTime loadStartAt;
    private LocalDateTime loadEndAt;


}
