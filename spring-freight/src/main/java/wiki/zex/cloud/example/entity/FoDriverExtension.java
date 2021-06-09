package wiki.zex.cloud.example.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import java.time.LocalDateTime;
import com.baomidou.mybatisplus.annotation.TableId;
import java.io.Serializable;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;
import wiki.zex.cloud.example.config.serializers.JsonLongSerializer;
import wiki.zex.cloud.example.enums.AuditStatus;

/**
 * <p>
 * 
 * </p>
 *
 * @author Zex
 * @since 2020-07-17
 */
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@ApiModel(value="FoDriverExtension对象", description="")
public class FoDriverExtension implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.ASSIGN_ID)
    @JsonSerialize(using = JsonLongSerializer.class)
    private Long id;
    @JsonSerialize(using = JsonLongSerializer.class)
    private Long userId;

    private String carLong;

    private String carModel;

    private LocalDateTime createAt;

    private String nature;

    private String carNo;

    private String vehicleLicense;

    private String vehicleLicenseBackend;

    private AuditStatus auditStatus;

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
