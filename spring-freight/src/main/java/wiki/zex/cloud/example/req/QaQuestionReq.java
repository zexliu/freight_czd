package wiki.zex.cloud.example.req;

import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import org.hibernate.validator.constraints.Length;
import wiki.zex.cloud.example.enums.QuestionType;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;


@Data
public class QaQuestionReq {

    @ApiModelProperty(value = "题库编号")
    @NotNull
    private Long questionStoreId;

    @ApiModelProperty(value = "问题类型")
    @NotNull
    private QuestionType questionType;

    @ApiModelProperty(value = "问题内容")
    @NotBlank
    private String questionContent;

    @ApiModelProperty(value = "答案选项")
    @NotBlank
    @Length(min = 2,max = 255)
    private String questionAnswerItems;

    @ApiModelProperty(value = "正确答案")
    @NotBlank
    @Length(min = 1,max = 30)
    private String questionAnswer;

    @ApiModelProperty(value = "分值")
    @NotNull
    private Integer questionScore;

}
