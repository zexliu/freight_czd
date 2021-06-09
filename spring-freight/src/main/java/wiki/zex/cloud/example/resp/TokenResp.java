package wiki.zex.cloud.example.resp;


import lombok.Data;

@Data
public class TokenResp {

    private String accessToken;

    private String refreshToken;

}
