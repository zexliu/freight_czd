package wiki.zex.cloud.example.resp;

import lombok.Data;
import lombok.EqualsAndHashCode;
import wiki.zex.cloud.example.entity.FoCall;


@Data
@EqualsAndHashCode(callSuper = false)
public class FoCallResp extends FoCall {
    String fromAvatar;
    String fromMobile;
    String fromNickname;
    String toAvatar;
    String toMobile;
    String toNickname;
    String loadProvinceCode;
    String loadCityCode;
    String loadDistrictCode;
    String unloadProvinceCode;
    String unloadCityCode;
    String unloadDistrictCode;
    Integer goodsStatus;
    String carLongs;
    String carModels;
    String weight;
    String volume;
}
