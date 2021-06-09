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
 * 
 * </p>
 *
 * @author Zex
 * @since 2020-08-18
 */
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@ApiModel(value="FoEvaluation对象", description="")
public class FoEvaluation implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.ASSIGN_ID)
    @JsonSerialize(using = JsonLongSerializer.class)
    private Long id;
    @JsonSerialize(using = JsonLongSerializer.class)
    private Long orderId;

    private String tags;

    private String description;

    private LocalDateTime createAt;

    private Boolean anonymous;
    @JsonSerialize(using = JsonLongSerializer.class)
    private Long userId;
    @JsonSerialize(using = JsonLongSerializer.class)
    private Long targetId;

    private Integer type;
    private Integer level;


}
