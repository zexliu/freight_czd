package wiki.zex.cloud.example.resp;

import lombok.Data;
import lombok.EqualsAndHashCode;
import wiki.zex.cloud.example.entity.AmAuditHistory;
import wiki.zex.cloud.example.entity.FoDeliveryExtension;

import java.util.List;

@Data
@EqualsAndHashCode(callSuper = true)
public class FoDeliveryExtensionResp extends FoDeliveryExtension {
    private String mobile;
    private List<AmAuditHistory> histories;
}
