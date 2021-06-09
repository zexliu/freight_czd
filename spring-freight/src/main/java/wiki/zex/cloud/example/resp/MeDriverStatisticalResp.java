package wiki.zex.cloud.example.resp;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class MeDriverStatisticalResp {

    private BigDecimal transactionAmount;

    private String carLong;

    private String carModel;
}
