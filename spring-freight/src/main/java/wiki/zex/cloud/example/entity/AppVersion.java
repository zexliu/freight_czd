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

/**
 * <p>
 * 
 * </p>
 *
 * @author Zex
 * @since 2020-09-11
 */
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@ApiModel(value="AppVersion对象", description="")
public class AppVersion implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.ASSIGN_ID)
    @JsonSerialize(using = JsonLongSerializer.class)
    private Long id;

    private Integer type;

    private Integer deviceType;

    private Integer versionCode;

    private String versionName;

    private String content;

    private LocalDateTime createAt;

    private Boolean isForce;

    private String downloadUrl;

    private String sha256checksum;

}
