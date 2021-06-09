package wiki.zex.cloud.example.resp;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SimpleResp {

    private String message;

    static {
        SUCCESS = new SimpleResp("SUCCESS");
        FAILURE = new SimpleResp("FAILURE");
    }
    public static final SimpleResp SUCCESS ;
    public static final SimpleResp FAILURE ;

}
