package wiki.zex.cloud.example.resp;

import lombok.Data;
import lombok.EqualsAndHashCode;
import wiki.zex.cloud.example.entity.FoDeliverGoods;

import java.util.List;

@Data
@EqualsAndHashCode(callSuper = false)
public class FoDeliverDetails extends FoDeliverGoods {

    List<FoCallResp> calls;
    private String avatar;
    private String nickname;
    private String mobile;
    private String companyName;

}
