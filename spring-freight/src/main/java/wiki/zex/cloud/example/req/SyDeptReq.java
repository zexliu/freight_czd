package wiki.zex.cloud.example.req;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotBlank;
import java.util.List;

@Data
public class SyDeptReq {

    @ApiModelProperty(value = "部门名称")
    @NotBlank
    @Length(min = 2,max = 32)
    private String deptName;

    @ApiModelProperty(value = "部门编码")
    @Length(min = 2,max = 32)
    @NotBlank
    private String deptCode;

    @ApiModelProperty(value = "部门英文名")
    @Length(max = 64)
    private String deptEnName;

    @ApiModelProperty(value = "父级ID")
    private Long parentId;

    @ApiModelProperty(value = "地址")
    @Length(max = 200)
    private String address;

    @ApiModelProperty(value = "传真")
    @Length(max = 32)
    private String fax;

    @ApiModelProperty(value = "电话")
    @Length(max = 32)
    private String phone;

    @ApiModelProperty(value = "描述")
    @Length(max = 200)
    private String description;


    @ApiModelProperty(value = "排序")
    private Integer seq;

    @ApiModelProperty(value = "关联的角色ID集合")
    private List<Long> roleIds;


}
