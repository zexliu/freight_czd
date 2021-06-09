package wiki.zex.cloud.example.entity;

import com.baomidou.mybatisplus.annotation.FieldStrategy;
import com.baomidou.mybatisplus.annotation.IdType;
import java.time.LocalDateTime;

import com.baomidou.mybatisplus.annotation.TableField;
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
 * @since 2020-08-21
 */
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@ApiModel(value="FoAnnouncement对象", description="")
public class FoAnnouncement implements Serializable {
    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.ASSIGN_ID)
    @JsonSerialize(using = JsonLongSerializer.class)
    private Long id;
    @ApiModelProperty(value = "标题")
    private String title;
    @ApiModelProperty(value = "内容")
    private String content;
    @ApiModelProperty(value = "有效开始时间")

    @TableField(updateStrategy = FieldStrategy.IGNORED)
    private LocalDateTime validStartAt;

    @ApiModelProperty(value = "有效结束时间")
    @TableField(updateStrategy = FieldStrategy.IGNORED)
    private LocalDateTime validEndAt;

    @ApiModelProperty(value = "创建时间")
    private LocalDateTime createAt;

    @ApiModelProperty(value = "公告类型")
    private Integer announcementType;

    @ApiModelProperty(value = "参数")
    private String params;

    @ApiModelProperty(value = "有效状态")
    private Boolean validStatus;

    @ApiModelProperty(value = "封面图")
    private String coverImage;

}
