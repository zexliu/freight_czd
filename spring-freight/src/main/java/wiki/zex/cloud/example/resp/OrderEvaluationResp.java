package wiki.zex.cloud.example.resp;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import lombok.Data;
import wiki.zex.cloud.example.config.serializers.JsonLongSerializer;

import java.time.LocalDateTime;

@Data
public class OrderEvaluationResp {
    private String userAvatar;
    private String userName;
    private String driverAvatar;
    private String driverName;
    private String loadProvinceCode;
    private String loadCityCode;
    private String loadDistrictCode;
    private String unloadProvinceCode;
    private String unloadCityCode;
    private String unloadDistrictCode;
    private String categoryName;
    @JsonSerialize(using = JsonLongSerializer.class)
    private Long orderId;
    @JsonSerialize(using = JsonLongSerializer.class)
    private Long userEvaluationId;
    private String userTags;
    private String userDescription;
    private LocalDateTime userCreateAt;
    private Integer userLevel;
    @JsonSerialize(using = JsonLongSerializer.class)
    private Long driverEvaluationId;
    private String driverTags;
    private String driverDescription;
    private LocalDateTime driverCreateAt;
    private Integer driverLevel;
}
