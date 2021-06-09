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
import wiki.zex.cloud.example.enums.HttpMethodType;

/**
 * <p>
 * 权限管理
 * </p>
 *
 * @author Zex
 * @since 2020-05-31
 */
@Data
@EqualsAndHashCode(callSuper = false)
@ApiModel(value="SyPermission对象", description="权限管理")
public class SyPermission implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.ASSIGN_ID)
    @JsonSerialize(using = JsonLongSerializer.class)
    private Long id;

    @ApiModelProperty(value = "权限名称")
    private String permissionName;

    @ApiModelProperty(value = "权限编码")
    private String permissionCode;

    @ApiModelProperty(value = "资源路径")
    private String permissionPath;

    @ApiModelProperty(value = "排序")
    private Integer seq;

    @ApiModelProperty(value = "描述")
    private String description;

    @ApiModelProperty(value = "所属模块")
    @JsonSerialize(using = JsonLongSerializer.class)
    @TableField(updateStrategy= FieldStrategy.IGNORED)
    private Long parentId;

    @ApiModelProperty(value = "创建时间")
    private LocalDateTime createAt;

    @ApiModelProperty(value = "方法类型")
    private HttpMethodType methodType;


}
