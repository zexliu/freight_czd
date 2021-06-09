package wiki.zex.cloud.example.req;

import lombok.Data;

@Data
public class FoCallReq {

    private Long toUserId;

    private Long goodsId;

    private Boolean type;

    private Boolean status;
}
