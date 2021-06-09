package wiki.zex.cloud.example.req;

import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.time.LocalDateTime;


@Data
public class FoAnnouncementReq {

    @ApiModelProperty(value = "标题")
    private String title;

    @ApiModelProperty(value = "封面图")
    private String coverImage;

    @ApiModelProperty(value = "内容")
    private String content;
    @ApiModelProperty(value = "有效开始时间")

    private LocalDateTime validStartAt;
    @ApiModelProperty(value = "有效结束时间")

    private LocalDateTime validEndAt;

    @ApiModelProperty(value = "公告类型")
    private Integer announcementType;
    @ApiModelProperty(value = "参数")
    private String params;

    @ApiModelProperty(value = "有效状态")
    private Boolean validStatus;
}
