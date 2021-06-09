package wiki.zex.cloud.example.req;

import lombok.Data;
import wiki.zex.cloud.example.enums.ClientType;
import wiki.zex.cloud.example.enums.OAuthGrantType;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

@Data
public class TokenReq {

    @NotBlank
    private String username;
    @NotBlank
    private String password;

    @NotNull
    private OAuthGrantType grantType;

    @NotNull
    private ClientType clientType;
}
