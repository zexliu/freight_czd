package wiki.zex.cloud.example.req;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotBlank;
import java.io.Serializable;

/**
 * <p>
 * 
 * </p>
 *
 * @author Zex
 * @since 2020-06-12
 */
@Data
@EqualsAndHashCode(callSuper = false)
@ApiModel(value="SbStation对象", description="")
public class SbStationReq implements Serializable {


    @ApiModelProperty(value = "车站名称")
    @NotBlank
    @Length(min = 2,max = 30)
    private String stationName;

    @ApiModelProperty(value = "车站编码")
    @NotBlank
    @Length(min = 2,max = 30)
    private String stationCode;

    private Long nextStationId;

    @ApiModelProperty(value = "下站距离")
    private Float nextStationDistance;

    @ApiModelProperty(value = "排序")
    private Integer seq;

    @ApiModelProperty(value = "描述")
    @Length(max = 200)
    private String description;


}
