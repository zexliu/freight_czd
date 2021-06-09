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
 * @since 2020-07-14
 */
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@ApiModel(value="FoCall对象", description="")
public class FoCall implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.ASSIGN_ID)
    @JsonSerialize(using = JsonLongSerializer.class)

    private Long id;
    @JsonSerialize(using = JsonLongSerializer.class)

    private Long fromUserId;
    @JsonSerialize(using = JsonLongSerializer.class)

    private Long toUserId;
    @JsonSerialize(using = JsonLongSerializer.class)

    private Long goodsId;

    private Boolean type;

    private Boolean status;

    private LocalDateTime createAt;


}
