package wiki.zex.cloud.example.req;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class FoOrderReq {

    private Long deliveryId;

    private Long driverId;

    private BigDecimal amount;

    private BigDecimal freightAmount;

}
