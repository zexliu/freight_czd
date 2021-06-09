package wiki.zex.cloud.example.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import java.io.Serializable;
import java.time.LocalDateTime;

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
 * 用户发货 拓展信息
 * </p>
 *
 * @author Zex
 * @since 2020-07-02
 */
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@ApiModel(value="FoDeliveryExtension对象", description="用户发货 拓展信息")
public class FoDeliveryExtension implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.ASSIGN_ID)
    @JsonSerialize(using = JsonLongSerializer.class)
    private Long id;

    @JsonSerialize(using = JsonLongSerializer.class)
    private Long userId;

    @ApiModelProperty(value = "发货性质")
    private String nature;
    @ApiModelProperty(value = "营业执照")
    private String businessLicense;

    private AuditStatus auditStatus;

    @ApiModelProperty(value = "身份证图片")
    private String identityCard;

    @ApiModelProperty(value = "身份证图片反面")
    private String identityCardBackend;

    @ApiModelProperty(value = "手持身份证照片")
    private String identityCardTake;


    private String avatar;

    private String realName;

    private String shopGroupPhoto;

    private String companyName;

    private LocalDateTime createAt;

}
