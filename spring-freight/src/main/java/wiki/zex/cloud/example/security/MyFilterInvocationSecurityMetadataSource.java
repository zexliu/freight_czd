package wiki.zex.cloud.example.security;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.ConfigAttribute;
import org.springframework.security.access.SecurityConfig;
import org.springframework.security.web.FilterInvocation;
import org.springframework.security.web.access.intercept.FilterInvocationSecurityMetadataSource;
import org.springframework.stereotype.Component;
import org.springframework.util.AntPathMatcher;
import wiki.zex.cloud.example.entity.SyPermission;
import wiki.zex.cloud.example.enums.HttpMethodType;
import wiki.zex.cloud.example.service.ISyPermissionService;
import wiki.zex.cloud.example.service.ISyRoleService;

import java.util.Collection;
import java.util.List;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Component
public class MyFilterInvocationSecurityMetadataSource implements FilterInvocationSecurityMetadataSource {
    //创建一个AntPathMatcher实例，主要用来实现ant风格的URL匹配。
    private AntPathMatcher antPathMatcher = new AntPathMatcher();

    @Autowired
    private ISyPermissionService iSyPermissionService;

    @Autowired
    private ISyRoleService iSyRoleService;

    /**
     * @param o 参数是一个FilterInvocation，可以从中去除请求的url
     * @return Collection<ConfigAttribute>:表示当前请求 URL 所需的角色。
     * @throws IllegalArgumentException
     */
    @Override
    public Collection<ConfigAttribute> getAttributes(Object o) throws IllegalArgumentException {
        //从FilterInvocation 中提取出当前请求的url
        String requestUrl = ((FilterInvocation) o).getRequestUrl();

        String method = ((FilterInvocation) o).getHttpRequest().getMethod();
        //从数据库中取出资源信息
        List<SyPermission> permissions = iSyPermissionService.list();
        for (SyPermission permission : permissions) {
            //匹配资源的URL
            if ((permission.getMethodType() == HttpMethodType.ALL || StringUtils.equals(permission.getMethodType().name(), method))
                    && antPathMatcher.match(permission.getPermissionPath(), requestUrl)) {
                //获取权限关联的角色信息
                List<String> roleCodes = iSyRoleService.findRoleCodesByPermissionId(permission.getId());
                if (CollectionUtils.isNotEmpty(roleCodes)){
                    roleCodes = roleCodes.stream().map(s -> "ROLE_" + s).collect(Collectors.toList());
                }
                //添加权限编码
                roleCodes.add(permission.getPermissionCode());
                String[] codes = roleCodes.toArray(new String[0]);
                return SecurityConfig.createList(codes);
            }
        }

        return SecurityConfig.createList("ROLE_ANONYMOUS");
    }

    /**
     * @return 返回所有定义好的权限资源, Spring Security 在启动时会校验
     * 相关配置是否正确 ，如果不需要校验，那么该方法直接返回 null 即可
     */
    @Override
    public Collection<ConfigAttribute> getAllConfigAttributes() {
        return null;
    }

    /**
     * @param aClass
     * @return 返回类对象是否支持校验
     */
    @Override
    public boolean supports(Class<?> aClass) {
        return FilterInvocation.class.isAssignableFrom(aClass);
    }
}
