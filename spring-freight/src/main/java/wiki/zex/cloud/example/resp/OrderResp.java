package wiki.zex.cloud.example.resp;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import lombok.Data;
import wiki.zex.cloud.example.config.serializers.JsonLongSerializer;

import java.math.BigDecimal;
import java.time.LocalDateTime;
@Data
public class OrderResp {
    @JsonSerialize(using = JsonLongSerializer.class)

    private Long orderId;
    @JsonSerialize(using = JsonLongSerializer.class)

    private Long userId;
    @JsonSerialize(using = JsonLongSerializer.class)

    private Long driverId;
    @JsonSerialize(using = JsonLongSerializer.class)

    private Long deliveryId;

   private String driverNickname;

   private String driverAvatar;

   private String userNickname;

   private String userAvatar;

   private String driverMobile;

   private String userMobile;

    private String loadProvinceCode;

    private String loadCityCode;

    private String loadDistrictCode;

    private String unloadProvinceCode;

    private String unloadCityCode;

    private String unloadDistrictCode;
    private String categoryName;

    private LocalDateTime loadStartAt;

    private LocalDateTime loadEndAt;

    private BigDecimal amount;
    private BigDecimal freightAmount;

    private Boolean confirmStatus;

    private Boolean transportStatus;

    private Boolean payStatus;

    private Boolean evaluateStatus;

    private Boolean driverEvaluateStatus;

    private Boolean cancelStatus;

    private Boolean refundStatus;

    private Integer protocolStatus;
    private Boolean driverPayStatus;
    private String carNo;

    private LocalDateTime createAt;

}
