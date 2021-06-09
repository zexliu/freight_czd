package wiki.zex.cloud.example.req;

import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

@Data
public class FoDeliveryExtensionReq {

    @ApiModelProperty(value = "发货性质")
    private String nature;
    @ApiModelProperty(value = "营业执照")
    private String businessLicense;

    @ApiModelProperty(value = "身份证图片")
    private String identityCard;

    @ApiModelProperty(value = "身份证图片反面")
    private String identityCardBackend;

    @ApiModelProperty(value = "手持身份证照片")
    private String identityCardTake;

    private String shopGroupPhoto;

    private String avatar;

    private String realName;

    private String companyName;


}
