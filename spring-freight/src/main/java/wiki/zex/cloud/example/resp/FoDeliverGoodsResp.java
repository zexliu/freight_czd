package wiki.zex.cloud.example.resp;

import lombok.Data;
import lombok.EqualsAndHashCode;
import wiki.zex.cloud.example.entity.FoDeliverGoods;

@Data
@EqualsAndHashCode(callSuper = false)
public class FoDeliverGoodsResp extends FoDeliverGoods {

   private String avatar;

    private  String nickname;

    private   Long evaluationCount;

    private  Long callCount;

    private  Long lookCount;

    private   String mobile;

}
