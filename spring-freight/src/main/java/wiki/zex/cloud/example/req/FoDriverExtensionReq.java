package wiki.zex.cloud.example.req;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import wiki.zex.cloud.example.config.serializers.JsonLongSerializer;
import wiki.zex.cloud.example.enums.AuditStatus;

import java.time.LocalDateTime;

@Data
public class FoDriverExtensionReq {


    private String carLong;

    private String carModel;

    private String nature;

    private String carNo;

    private String vehicleLicense;

    private String vehicleLicenseBackend;


    @ApiModelProperty(value = "身份证图片")
    private String identityCard;

    @ApiModelProperty(value = "身份证图片反面")
    private String identityCardBackend;

    @ApiModelProperty(value = "手持身份证照片")
    private String identityCardTake;

    private String avatar;

    private String realName;

    private String driverLicense;

    private String driverLicenseBackend;

    private String carGroupPhoto;


}
