package wiki.zex.cloud.example.security;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.oauth2.provider.token.UserAuthenticationConverter;
import org.springframework.util.StringUtils;

import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.Map;

public class MyUserAuthenticationConverter  implements UserAuthenticationConverter {
    private Collection<? extends GrantedAuthority> defaultAuthorities;
    private UserDetailsService userDetailsService;

    public MyUserAuthenticationConverter() {
    }

    public void setUserDetailsService(UserDetailsService userDetailsService) {
        this.userDetailsService = userDetailsService;
    }

    public void setDefaultAuthorities(String[] defaultAuthorities) {
        this.defaultAuthorities = AuthorityUtils.commaSeparatedStringToAuthorityList(StringUtils.arrayToCommaDelimitedString(defaultAuthorities));
    }

    public Map<String, ?> convertUserAuthentication(Authentication authentication) {
        Map<String, Object> response = new LinkedHashMap<>();
        response.put("user_name", authentication.getName());
        if (authentication.getAuthorities() != null && !authentication.getAuthorities().isEmpty()) {
            response.put("authorities", AuthorityUtils.authorityListToSet(authentication.getAuthorities()));
        }

        return response;
    }

    public Authentication extractAuthentication(Map<String, ?> map) {
        if (map.containsKey("user_name")) {
            Object principal = map.get("user_name");
            Collection<? extends GrantedAuthority> authorities = this.getAuthorities(map);
            if (this.userDetailsService != null) {
                UserDetails user = this.userDetailsService.loadUserByUsername((String)map.get("user_name"));
                if (user instanceof  MyUserDetails){
                    ((MyUserDetails) user).setClientId((String) map.get("client_id"));
                }
                authorities = user.getAuthorities();
                principal = user;
            }

            return new UsernamePasswordAuthenticationToken(principal, "N/A", authorities);
        } else {
            return null;
        }
    }

    private Collection<? extends GrantedAuthority> getAuthorities(Map<String, ?> map) {
        if (!map.containsKey("authorities")) {
            return this.defaultAuthorities;
        } else {
            Object authorities = map.get("authorities");
            if (authorities instanceof String) {
                return AuthorityUtils.commaSeparatedStringToAuthorityList((String)authorities);
            } else if (authorities instanceof Collection) {
                return AuthorityUtils.commaSeparatedStringToAuthorityList(StringUtils.collectionToCommaDelimitedString((Collection)authorities));
            } else {
                throw new IllegalArgumentException("Authorities must be either a String or a Collection");
            }
        }
    }
}
