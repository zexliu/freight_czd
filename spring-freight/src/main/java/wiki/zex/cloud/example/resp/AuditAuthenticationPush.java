package wiki.zex.cloud.example.resp;

import lombok.Data;

@Data
public class AuditAuthenticationPush {

    String body;

    Long userId;

    boolean isUser;


}
