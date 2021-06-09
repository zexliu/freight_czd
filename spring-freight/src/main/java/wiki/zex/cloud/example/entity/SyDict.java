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
 * 数据字典
 * </p>
 *
 * @author Zex
 * @since 2020-06-02
 */
@Data
@EqualsAndHashCode(callSuper = false)
@ApiModel(value="SyDict对象", description="数据字典")
public class SyDict implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.ASSIGN_ID)
    @JsonSerialize(using = JsonLongSerializer.class)
    private Long id;
    @ApiModelProperty(value = "字典名称")
    private String dictName;
    @ApiModelProperty(value = "字典编码")
    private String dictCode;
    @ApiModelProperty(value = "描述")
    private String description;
    @ApiModelProperty(value = "创建时间")
    private LocalDateTime createAt;


}
