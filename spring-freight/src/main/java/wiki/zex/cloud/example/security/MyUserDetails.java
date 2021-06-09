package wiki.zex.cloud.example.security;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Data;
import lombok.EqualsAndHashCode;
import org.apache.commons.collections.CollectionUtils;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import wiki.zex.cloud.example.entity.SyPermission;
import wiki.zex.cloud.example.entity.SyUser;
import wiki.zex.cloud.example.resp.SyRoleResp;
//import wiki.zex.cloud.example.resp.SyRoleResp;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

@EqualsAndHashCode(callSuper = true)
@Data
public class MyUserDetails extends SyUser implements UserDetails {

    private LocalDateTime credentialsExpireAt;

    private List<SyRoleResp> roles;

    private String clientId;

    @Override
    @JsonIgnore
    public Collection<? extends GrantedAuthority> getAuthorities() {
        if (CollectionUtils.isEmpty(roles)) {
            return new ArrayList<>();
        }
        List<GrantedAuthority> grantedAuthorities = new ArrayList<>();
        for (SyRoleResp role : roles) {
            for (SyPermission permission : role.getPermissions()) {
                grantedAuthorities.add(new SimpleGrantedAuthority(permission.getPermissionCode()));
            }
            grantedAuthorities.add(new SimpleGrantedAuthority("ROLE_" + role.getRoleCode()));
        }
        return grantedAuthorities;
    }


    @Override
    public boolean isAccountNonExpired() {
        return getExpireAt() == null || getExpireAt().isAfter(LocalDateTime.now());
    }

    @Override
    public boolean isAccountNonLocked() {
        return getLocked() == null || !getLocked();
    }

    @Override
    public boolean isCredentialsNonExpired() {
        // TODO: 2020/5/18 credentialsExpire check
//        return getCredentialsExpireAt() != null && getCredentialsExpireAt().isAfter(LocalDateTime.now());

        return true;
    }


    @Override
    public boolean isEnabled() {
        return getEnable() == null || getEnable() ;
    }
}
