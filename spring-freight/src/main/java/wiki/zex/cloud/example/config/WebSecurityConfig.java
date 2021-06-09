package wiki.zex.cloud.example.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import wiki.zex.cloud.example.security.CaptchaAuthenticationProvider;
import wiki.zex.cloud.example.service.ISyCaptchaService;
import wiki.zex.cloud.example.service.ISyUserService;

@Configuration
@EnableGlobalMethodSecurity(prePostEnabled = true, securedEnabled = true, jsr250Enabled = true)
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {

    @Autowired
    @Qualifier("usernamePasswordUserDetailsService")
    private UserDetailsService usernamePasswordUserDetailsService;

    @Autowired
    @Qualifier("captchaUserDetailsService")
    private UserDetailsService captchaUserDetailsService;

    @Autowired
    private ISyCaptchaService iSyCaptchaService;

    @Autowired
    private ISyUserService iSyUserService;
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    @Override
    public AuthenticationManager authenticationManagerBean() throws Exception {
//        return new ProviderManager(Arrays.asList(daoAuthenticationProvider(),captchaAuthenticationProvider()));
        return super.authenticationManagerBean();
    }

    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        // 加入自定义的安全认证

        auth.userDetailsService(usernamePasswordUserDetailsService)
                .passwordEncoder(passwordEncoder())
                .and()
                //添加自定义的认证管理类
                .authenticationProvider(captchaAuthenticationProvider())
                .authenticationProvider(daoAuthenticationProvider());
    }


    @Bean
    public CaptchaAuthenticationProvider captchaAuthenticationProvider() {
        CaptchaAuthenticationProvider provider = new CaptchaAuthenticationProvider();
        provider.setUserDetailsService(captchaUserDetailsService);
        provider.setSyCaptchaService(iSyCaptchaService);
        provider.setSyUserService(iSyUserService);
        return provider;
    }

    @Bean
    public DaoAuthenticationProvider daoAuthenticationProvider() {
        DaoAuthenticationProvider daoAuthenticationProvider  = new DaoAuthenticationProvider();
        daoAuthenticationProvider.setUserDetailsService(usernamePasswordUserDetailsService);
        daoAuthenticationProvider.setPasswordEncoder(passwordEncoder());
        return daoAuthenticationProvider;
    }


    @Override
    protected void configure(HttpSecurity http) throws Exception {
        super.configure(http);
    }

}