package wiki.zex.cloud.example.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Service;
import wiki.zex.cloud.example.entity.SyUser;
import wiki.zex.cloud.example.service.ISyUserService;


@Service("usernamePasswordUserDetailsService")
@Primary
public class UsernamePasswordUserDetailsService extends AbstractUserDetailsService {

    @Autowired
    private ISyUserService iSyUserService;

    @Override
    SyUser loadUser(String username) {
        return iSyUserService.findByUsername(username);
    }

}
