package wiki.zex.cloud.example.req;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * <p>
 * 时刻表
 * </p>
 *
 * @author Zex
 * @since 2020-06-15
 */
@Data
@EqualsAndHashCode(callSuper = false)
@ApiModel(value="SbRuntimeTable对象", description="时刻表")
public class SbRuntimeTableReq implements Serializable {


    @ApiModelProperty(value = "时刻表名称")
    private String tableName;

    @ApiModelProperty(value = "描述")
    private String description;



}
