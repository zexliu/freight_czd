package wiki.zex.cloud.example.req;

import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import org.hibernate.validator.constraints.Length;
import javax.validation.constraints.NotBlank;

@Data
public class SyDictEntryReq {

    @ApiModelProperty(value = "字典编码")
    @NotBlank
    @Length(min = 1,max = 30)
    private String dictCode;

    @ApiModelProperty(value = "字典项名称")
    @NotBlank
    @Length(min = 1,max = 30)
    private String dictEntryName;

    @ApiModelProperty(value = "字典项值")
    @NotBlank
    @Length(min = 1,max = 30)
    private String dictEntryValue;

    @ApiModelProperty(value = "描述")
    @Length(max = 200)
    private String description;

    @ApiModelProperty(value = "排序")
    private Integer seq;

    @ApiModelProperty(value = "可用状态")
    private Boolean enable;
}
