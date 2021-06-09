package wiki.zex.cloud.example.resp;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import lombok.Data;
import lombok.EqualsAndHashCode;
import wiki.zex.cloud.example.config.serializers.JsonListLongSerializer;
import wiki.zex.cloud.example.entity.SyDept;

import java.util.List;

@Data
@EqualsAndHashCode(callSuper = true)
public class SyDeptDetails extends SyDept {
    @JsonSerialize(using = JsonListLongSerializer.class)
    private List<Long> roleIds;

}
