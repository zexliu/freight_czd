package wiki.zex.cloud.example.resp;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import lombok.Data;
import wiki.zex.cloud.example.config.serializers.JsonLongSerializer;

@Data
public class DeliveryGoodsMessage {

    private Integer type = 1;
    @JsonSerialize(using = JsonLongSerializer.class)

    private Long deliveryId;
    @JsonSerialize(using = JsonLongSerializer.class)

    private Long onlineId;


}
