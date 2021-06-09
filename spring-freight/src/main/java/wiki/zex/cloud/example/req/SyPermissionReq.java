package wiki.zex.cloud.example.req;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import org.hibernate.validator.constraints.Length;
import wiki.zex.cloud.example.enums.HttpMethodType;

import javax.validation.constraints.Max;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import java.time.LocalDateTime;

@Data
public class SyPermissionReq {

    @ApiModelProperty(value = "权限名称")
    @NotBlank
    @Length(min = 2,max = 30)
    private String permissionName;

    @ApiModelProperty(value = "权限编码")
    @NotBlank
    @Length(min = 2,max = 30)
    private String permissionCode;

    @ApiModelProperty(value = "资源路径")
    @NotBlank
    @Length(min = 6,max = 200)
    private String permissionPath;


    @ApiModelProperty(value = "描述")
    @Length(max = 200)
    private String description;

    @ApiModelProperty(value = "所属模块")
    private Long parentId;

    @ApiModelProperty(value = "方法类型")
    @NotNull
    private HttpMethodType methodType;

    @ApiModelProperty(value = "排序")
    @NotNull
    private Integer seq;
}
