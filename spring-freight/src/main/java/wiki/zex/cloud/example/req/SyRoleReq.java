package wiki.zex.cloud.example.req;

import lombok.Data;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotBlank;
import java.util.List;

@Data
public class SyRoleReq {

    @NotBlank
    @Length(min = 2, max = 30)
    private String roleName;
    @NotBlank
    @Length(min = 2, max = 30)
    private String roleCode;
    @Length(max = 200)
    private String description;
    private Integer seq;
    private List<Long> permissionIds;
    private List<Long> menuIds;
}
