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
 * 部门表
 * </p>
 *
 * @author Zex
 * @since 2020-05-29
 */
@Data
@EqualsAndHashCode(callSuper = false)
@ApiModel(value="SyDept对象", description="部门表")
public class SyDept implements Serializable {

    private static final long serialVersionUID = 1L;

    @JsonSerialize(using = JsonLongSerializer.class)
    @TableId(value = "id", type = IdType.ASSIGN_ID)
    private Long id;

    @ApiModelProperty(value = "部门名称")
    private String deptName;

    @ApiModelProperty(value = "部门编码")
    private String deptCode;

    @ApiModelProperty(value = "父级ID")
    @JsonSerialize(using = JsonLongSerializer.class)
    @TableField(updateStrategy= FieldStrategy.IGNORED)
    private Long parentId;

    @ApiModelProperty(value = "地址")
    private String address;

    @ApiModelProperty(value = "传真")
    private String fax;

    @ApiModelProperty(value = "电话")
    private String phone;

    @ApiModelProperty(value = "创建时间")
    private LocalDateTime createAt;

    @ApiModelProperty(value = "描述")
    private String description;

    @ApiModelProperty(value = "排序")
    private Integer seq;

}
