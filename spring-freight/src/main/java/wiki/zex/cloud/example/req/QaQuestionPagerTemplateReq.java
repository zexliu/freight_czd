package wiki.zex.cloud.example.req;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import org.hibernate.validator.constraints.Length;
import wiki.zex.cloud.example.config.serializers.JsonLongSerializer;

@Data
public class QaQuestionPagerTemplateReq {


    @ApiModelProperty(value = "题库编号")
    @JsonSerialize(using = JsonLongSerializer.class)
    private Long questionStoreId;

    @ApiModelProperty(value = "题目数量")
    private Integer questionCount;

    @ApiModelProperty(value = "模板名称")
    @Length(min = 2,max = 30)
    private String pagerTemplateName;

    @ApiModelProperty(value = "描述")
    @Length(max = 200)
    private String description;

}
