package wiki.zex.cloud.example.security;

import org.springframework.security.access.AccessDecisionManager;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.access.ConfigAttribute;
import org.springframework.security.authentication.InsufficientAuthenticationException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.stereotype.Component;

import java.util.Collection;

@Component
public class MyAccessDecisionManager implements AccessDecisionManager {

    /**
     * 判断当前登录的用户是否具备当前请求 URL 所需要的角色信息，如果不具备,就抛出AccessDeniedException异常
     * @param authentication
     * 参数1：当前登录用户的信息
     * @param o
     * 参数2：FilterInvocation对象，可以取当前请求对象等
     * @param collection
     * 参数3：MyFilterInvocationSecurityMetadataSource 中getAttributes 方法的返回值，即当前请求URL所需的角色
     * @throws AccessDeniedException
     * @throws InsufficientAuthenticationException
     */
    @Override
    public void decide(Authentication authentication, Object o, Collection<ConfigAttribute> collection) throws AccessDeniedException, InsufficientAuthenticationException {
        Collection <? extends GrantedAuthority> grantedAuthorities = authentication.getAuthorities();
        //角色信息对比

        StringBuilder builder = new StringBuilder("[");
        for(ConfigAttribute configAttribute:collection){
            builder.append(configAttribute.getAttribute()).append(",");
            if ("ROLE_ANONYMOUS".equals(configAttribute.getAttribute())){
                return;
            }
            //全新判断
            for (GrantedAuthority grantedAuthority:grantedAuthorities){
                //当前用户具备访问当前URL的权限
                if (configAttribute.getAttribute().equals(grantedAuthority.getAuthority())){
                    return;
                }
            }

        }
        builder.deleteCharAt(builder.length() - 1 ).append("]");
        //当前用户不具备访问当前URL的权限，抛出异常
        throw new AccessDeniedException(builder.toString());
    }

    @Override
    public boolean supports(ConfigAttribute configAttribute) {
        return true;
    }

    @Override
    public boolean supports(Class<?> aClass) {
        return true;
    }
}

