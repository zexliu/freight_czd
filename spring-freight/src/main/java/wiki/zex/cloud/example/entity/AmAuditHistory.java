package wiki.zex.cloud.example.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import java.time.LocalDateTime;
import com.baomidou.mybatisplus.annotation.TableId;
import java.io.Serializable;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;
import wiki.zex.cloud.example.enums.AuditStatus;
import wiki.zex.cloud.example.enums.AuditTargetType;

/**
 * <p>
 * 
 * </p>
 *
 * @author Zex
 * @since 2020-09-21
 */
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@ApiModel(value="AmAuditHistory对象", description="")
public class AmAuditHistory implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.ASSIGN_ID)
    private Long id;

    private Long targetId;

    private AuditTargetType targetType;

    private String snapshot;

    private AuditStatus status;

    private String message;

    private Long operatorId;

    private String operatorIp;

    private LocalDateTime createAt;


}
