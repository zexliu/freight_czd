package wiki.zex.cloud.example.security;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.context.MessageSource;
import org.springframework.context.MessageSourceAware;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.security.authentication.*;
import org.springframework.security.authentication.dao.AbstractUserDetailsAuthenticationProvider;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.SpringSecurityMessageSource;
import org.springframework.security.core.authority.mapping.GrantedAuthoritiesMapper;
import org.springframework.security.core.authority.mapping.NullAuthoritiesMapper;
import org.springframework.security.core.userdetails.*;
import wiki.zex.cloud.example.entity.SyUser;
import wiki.zex.cloud.example.enums.CaptchaType;
import wiki.zex.cloud.example.req.SyUserReq;
import wiki.zex.cloud.example.service.ISyCaptchaService;
import wiki.zex.cloud.example.service.ISyUserService;

import java.util.regex.Pattern;

@Slf4j
public class CaptchaAuthenticationProvider implements AuthenticationProvider, MessageSourceAware {
    protected MessageSourceAccessor messages = SpringSecurityMessageSource.getAccessor();


    private UserDetailsService userDetailsService;

    private ISyCaptchaService iSyCaptchaService;
    private ISyUserService iSyUserService;

    private final UserDetailsChecker preAuthenticationChecks = new DefaultPreAuthenticationChecks();
    private final GrantedAuthoritiesMapper authoritiesMapper = new NullAuthoritiesMapper();

    public void setSyUserService(ISyUserService iSyUserService) {
        this.iSyUserService = iSyUserService;
    }

    public UserDetailsService getUserDetailsService() {
        return userDetailsService;
    }


    public void setSyCaptchaService(ISyCaptchaService iSyCaptchaService) {
        this.iSyCaptchaService = iSyCaptchaService;
    }

    public void setUserDetailsService(UserDetailsService userDetailsService) {
        this.userDetailsService = userDetailsService;
    }

    @Override
    public Authentication authenticate(Authentication authentication) throws AuthenticationException {
        CaptchaAuthenticationToken token = (CaptchaAuthenticationToken) authentication;
        String mobile = token.getName();
        String pattern = "^((\\+|00)86)?((134\\d{4})|((13[0-3|5-9]|14[1|5-9]|15[0-9]|16[2|5|6|7]|17[0-8]|18[0-9]|19[0-2|5-9])\\d{8}))$";
        boolean isMatch = Pattern.matches(pattern, mobile);
        if (!isMatch) {
            throw new UsernameNotFoundException("请输入正确的手机号码");
        }
        String captcha = (String) authentication.getCredentials();
        if (iSyCaptchaService.isPass(mobile, CaptchaType.LOGIN, captcha)) {
            UserDetails userDetails;
            try {
                userDetails = getUserDetailsService().loadUserByUsername(mobile);
            } catch (UsernameNotFoundException usernameNotFoundException) {
                SyUserReq syUserReq = new SyUserReq();
                syUserReq.setMobile(mobile);
                syUserReq.setUsername(mobile);
                try {
                    SyUser syUser  = iSyUserService.create(syUserReq);
                    userDetails = new MyUserDetails();
                    BeanUtils.copyProperties(syUser,userDetails);
                }catch (Exception exception){
                    log.error("创建用户失败",exception);
                    throw new UsernameNotFoundException(exception.getMessage());
                }

            }
            preAuthenticationChecks.check(userDetails);
            return createSuccessAuthentication(userDetails, authentication, userDetails);
        } else {
            throw new BadCredentialsException("验证码不正确");
        }
    }


    @Override
    public boolean supports(Class<?> authentication) {
        return (CaptchaAuthenticationToken.class.isAssignableFrom(authentication));
    }


    protected Authentication createSuccessAuthentication(Object principal,
                                                         Authentication authentication, UserDetails user) {

        CaptchaAuthenticationToken result = new CaptchaAuthenticationToken(
                principal, authentication.getCredentials(),
                authoritiesMapper.mapAuthorities(user.getAuthorities()));
        result.setDetails(authentication.getDetails());

        return result;
    }


    @Override
    public void setMessageSource(MessageSource messageSource) {
        this.messages = new MessageSourceAccessor(messageSource);
    }


    private class DefaultPreAuthenticationChecks implements UserDetailsChecker {
        public void check(UserDetails user) {
            if (!user.isAccountNonLocked()) {
                log.debug("User account is locked");

                throw new LockedException(messages.getMessage(
                        "AbstractUserDetailsAuthenticationProvider.locked",
                        "User account is locked"));
            }

            if (!user.isEnabled()) {
                log.debug("User account is disabled");

                throw new DisabledException(messages.getMessage(
                        "AbstractUserDetailsAuthenticationProvider.disabled",
                        "User is disabled"));
            }

            if (!user.isAccountNonExpired()) {
                log.debug("User account is expired");

                throw new AccountExpiredException(messages.getMessage(
                        "AbstractUserDetailsAuthenticationProvider.expired",
                        "User account has expired"));
            }
        }
    }
}
