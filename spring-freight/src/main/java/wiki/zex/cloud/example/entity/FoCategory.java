package wiki.zex.cloud.example.entity;

import com.baomidou.mybatisplus.annotation.FieldStrategy;
import com.baomidou.mybatisplus.annotation.IdType;
import java.time.LocalDateTime;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import java.io.Serializable;
import java.util.List;

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
 * @since 2020-07-04
 */
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@ApiModel(value="FoCategory对象", description="")
public class FoCategory implements Serializable {

    private static final long serialVersionUID = 1L;

    @JsonSerialize(using = JsonLongSerializer.class)
    @TableId(value = "id", type = IdType.ASSIGN_ID)
    private Long id;

    private String categoryName;

    @ApiModelProperty(value = "分类编码")
    private String categoryCode;

    @ApiModelProperty(value = "父级ID")
    @JsonSerialize(using = JsonLongSerializer.class)
    @TableField(updateStrategy= FieldStrategy.IGNORED)
    private Long parentId;

    @ApiModelProperty(value = "描述")
    private String description;

    @ApiModelProperty(value = "创建时间")
    private LocalDateTime createAt;
    @ApiModelProperty(value = "排序")
    private Integer seq;

    private Boolean isHot;

}
