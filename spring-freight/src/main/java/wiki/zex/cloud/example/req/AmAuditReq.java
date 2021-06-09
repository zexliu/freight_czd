package wiki.zex.cloud.example.req;

import lombok.Data;
import wiki.zex.cloud.example.enums.AuditStatus;
import wiki.zex.cloud.example.enums.AuditTargetType;

import javax.validation.constraints.NotNull;

@Data
public class AmAuditReq {

    @NotNull
    private AuditTargetType targetType;
    @NotNull
    private  Long targetId;
    @NotNull
    private AuditStatus auditStatus;
    private String message;
}
