package wiki.zex.cloud.example.req;

import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotBlank;

@Data
public class QaQuestionStoreReq {


    @ApiModelProperty(value = "题库名称")
    @NotBlank
    @Length(min = 2,max = 32)
    private String questionStoreName;

    @ApiModelProperty(value = "描述")
    private String description;
}
