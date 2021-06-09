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
 * 菜单管理
 * </p>
 *
 * @author Zex
 * @since 2020-05-31
 */
@Data
@EqualsAndHashCode(callSuper = false)
@ApiModel(value="SyMenu对象", description="菜单管理")
public class SyMenu implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.ASSIGN_ID)
    @JsonSerialize(using = JsonLongSerializer.class)
    private Long id;

    @ApiModelProperty(value = "菜单名称")
    private String menuName;

    @ApiModelProperty(value = "菜单编码")
    private String menuCode;

    @ApiModelProperty(value = "菜单图标")
    private String menuIcon;

    @ApiModelProperty(value = "页面路径")
    private String menuPath;

    @ApiModelProperty(value = "所属菜单")
    @JsonSerialize(using = JsonLongSerializer.class)
    private Long parentId;

    @ApiModelProperty(value = "创建时间")
    private LocalDateTime createAt;

    @ApiModelProperty(value = "描述")
    private String description;

    @ApiModelProperty(value = "排序")
    private String seq;

    @ApiModelProperty(value = "重定向")
    private String redirect;

    @ApiModelProperty(value = "组件")
    private String component;

    @ApiModelProperty(value = "是否隐藏")
    private Boolean hidden;
}
