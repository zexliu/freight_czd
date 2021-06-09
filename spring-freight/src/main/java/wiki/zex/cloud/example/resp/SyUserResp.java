package wiki.zex.cloud.example.resp;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import lombok.Data;
import lombok.EqualsAndHashCode;
import wiki.zex.cloud.example.config.serializers.JsonListLongSerializer;
import wiki.zex.cloud.example.entity.SyUser;

import java.util.List;

@Data
@EqualsAndHashCode(callSuper = true)
public class SyUserResp extends SyUser {
    @JsonSerialize(using = JsonListLongSerializer.class)
    List<Long> roleIds;

    @JsonSerialize(using = JsonListLongSerializer.class)
    List<Long> deptIds;
}
