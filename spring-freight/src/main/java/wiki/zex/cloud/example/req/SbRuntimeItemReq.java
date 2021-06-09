package wiki.zex.cloud.example.req;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.time.LocalTime;

/**
 * <p>
 * 时刻表数据项
 * </p>
 *
 * @author Zex
 * @since 2020-06-15
 */
@Data
@EqualsAndHashCode(callSuper = false)
@ApiModel(value="SbRuntimeItem对象", description="时刻表数据项")
public class SbRuntimeItemReq implements Serializable {

    @ApiModelProperty(value = "所属时刻表")
    private Long tableId;

    @ApiModelProperty(value = "始发站ID")
    private Long startStationId;

    @ApiModelProperty(value = "终点站ID")
    private Long endStationId;

    @ApiModelProperty(value = "车次")
    private String trainNo;

    @ApiModelProperty(value = "服务号")
    private String serviceNo;

    @ApiModelProperty(value = "备注")
    private String description;

    @ApiModelProperty(value = "开点")
    private LocalTime startAt;

    @ApiModelProperty(value = "到点")
    private LocalTime endAt;

    @ApiModelProperty(value = "总里程")
    private Float distance;

    @ApiModelProperty(value = "是否上行")
    private Boolean up;


}
