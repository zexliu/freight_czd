package wiki.zex.cloud.example.req;


import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import org.hibernate.validator.constraints.Length;
import javax.validation.constraints.NotBlank;

@Data
public class SyMenuReq {

    @ApiModelProperty(value = "菜单名称")
    @NotBlank
    private String menuName;

    @ApiModelProperty(value = "菜单编码")
    @NotBlank
    private String menuCode;

    @ApiModelProperty(value = "菜单图标")
    private String menuIcon;

    @ApiModelProperty(value = "页面路径")
    @Length(max = 200)
    private String menuPath;

    @ApiModelProperty(value = "所属菜单")
    private Long parentId;


    @ApiModelProperty(value = "描述")
    @Length(max = 200)
    private String description;

    @ApiModelProperty(value = "排序")
    private String seq;

    @ApiModelProperty(value = "重定向")
    @Length(max = 200)
    private String redirect;

    @ApiModelProperty(value = "组件")
    @Length(max = 200)
    private String component;

    @ApiModelProperty(value = "是否隐藏")
    private Boolean hidden;
}
