package wiki.zex.cloud.example.resp;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import lombok.Data;
import wiki.zex.cloud.example.config.serializers.JsonLongSerializer;

import java.time.LocalDateTime;

@Data
public class SimpleDriverResp {
    @JsonSerialize(using = JsonLongSerializer.class)

    Long id;
    String username;
    String mobile;
    String nickname;
    String avatar;
    LocalDateTime createAt;
    String carLong;
    String carModel;
}
