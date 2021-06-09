package wiki.zex.cloud.example.resp;

import lombok.Data;
import lombok.EqualsAndHashCode;
import wiki.zex.cloud.example.entity.AmAuditHistory;
import wiki.zex.cloud.example.entity.FoDriverExtension;

import java.util.List;

@EqualsAndHashCode(callSuper = true)
@Data
public class FoDriverExtensionResp extends FoDriverExtension {

    private List<AmAuditHistory> histories;

    private String mobile;
}
