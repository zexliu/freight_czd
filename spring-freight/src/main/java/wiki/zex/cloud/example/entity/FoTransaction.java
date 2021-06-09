package wiki.zex.cloud.example.entity;

import com.baomidou.mybatisplus.annotation.IdType;

import java.math.BigDecimal;
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
import wiki.zex.cloud.example.enums.TransactionType;

/**
 * <p>
 * 
 * </p>
 *
 * @author Zex
 * @since 2020-08-17
 */
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@ApiModel(value="FoTransaction对象", description="")
public class FoTransaction implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.ASSIGN_ID)
    @JsonSerialize(using = JsonLongSerializer.class)
    private Long id;
    @JsonSerialize(using = JsonLongSerializer.class)
    private Long userId;
    @JsonSerialize(using = JsonLongSerializer.class)
    private Long targetId;

    private TransactionType type;

    private BigDecimal amount;

    private Boolean incrStatus;

    private LocalDateTime createAt;


}
