package wiki.zex.cloud.example.req;

import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotBlank;

@Data
public class SyDictReq {


    @NotBlank
    @Length(min = 2,max = 30)
    private String dictName;

    @NotBlank
    @Length(min = 2,max = 30)
    private String dictCode;

    @ApiModelProperty(value = "描述")
    @Length(max = 200)
    private String description;
}
