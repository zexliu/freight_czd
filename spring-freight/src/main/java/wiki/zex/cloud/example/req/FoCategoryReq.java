package wiki.zex.cloud.example.req;

import com.sun.mail.imap.protocol.BODY;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotBlank;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class FoCategoryReq {



    @NotBlank
    @Length(min = 2,max = 32)
    private String categoryName;
    @NotBlank
    @ApiModelProperty(value = "分类编码")
    @Length(min = 2,max = 32)
    private String categoryCode;

    @ApiModelProperty(value = "父级ID")
    private Long parentId;

    @ApiModelProperty(value = "描述")
    @Length(max = 200)
    private String description;


    @ApiModelProperty(value = "排序")
    private Integer seq;

    @ApiModelProperty(value = "关联的字典项")
    List<String> dictEntryValues;

    @ApiModelProperty(value = "是否热门")
    private Boolean isHot;
}
