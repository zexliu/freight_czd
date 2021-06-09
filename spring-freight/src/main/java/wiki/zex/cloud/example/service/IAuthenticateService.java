package wiki.zex.cloud.example.service;

import org.springframework.security.core.Authentication;
import wiki.zex.cloud.example.req.AuthenticateDriverReq;
import wiki.zex.cloud.example.req.AuthenticateOwnerReq;

public interface IAuthenticateService {
    void authOwner(Authentication authentication, AuthenticateOwnerReq req);

    void authDriver(Authentication authentication, AuthenticateDriverReq req);

}
