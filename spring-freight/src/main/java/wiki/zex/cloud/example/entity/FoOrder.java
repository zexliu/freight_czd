package wiki.zex.cloud.example.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

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
 * @since 2020-07-17
 */
@Data
@EqualsAndHashCode(callSuper = false)
@ApiModel(value="FoOrder对象", description="")
public class FoOrder implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.ASSIGN_ID)
    @JsonSerialize(using = JsonLongSerializer.class)
    private Long id;
    @JsonSerialize(using = JsonLongSerializer.class)
    private Long deliveryId;
    @JsonSerialize(using = JsonLongSerializer.class)

    private Long userId;
    @JsonSerialize(using = JsonLongSerializer.class)

    private Long driverId;

    private BigDecimal amount;

    private BigDecimal freightAmount;

    private Boolean confirmStatus;

    private Boolean transportStatus;

    private Boolean payStatus;

    private Boolean evaluateStatus;

    private Boolean driverEvaluateStatus;

    private Boolean driverPayStatus;

    private Boolean cancelStatus;

    private Boolean refundStatus;

    private Integer protocolStatus;

    private BigDecimal masterPayAmount;

    private LocalDateTime createAt;


}
