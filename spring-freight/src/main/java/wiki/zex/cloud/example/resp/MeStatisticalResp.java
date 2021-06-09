package wiki.zex.cloud.example.resp;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class MeStatisticalResp {
    BigDecimal transactionAmount;
    Integer deliveryCount;
    Integer orderCount;

}
