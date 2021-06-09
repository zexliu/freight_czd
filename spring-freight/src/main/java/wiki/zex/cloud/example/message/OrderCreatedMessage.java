package wiki.zex.cloud.example.message;


import lombok.Data;

import java.io.Serializable;

@Data
public class OrderCreatedMessage implements Serializable {
    private Long orderId;
}
