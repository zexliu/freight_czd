package wiki.zex.cloud.example.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import wiki.zex.cloud.example.entity.SyUser;
import wiki.zex.cloud.example.service.ISyUserService;


@Service("captchaUserDetailsService")
public class CaptchaUserDetailsService extends AbstractUserDetailsService {

    @Autowired
    private ISyUserService iSyUserService;

    @Override
    SyUser loadUser(String username) {
        return iSyUserService.findByMobile(username);
    }

}
