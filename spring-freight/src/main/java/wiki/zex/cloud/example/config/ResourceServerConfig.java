package wiki.zex.cloud.example.config;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.ObjectPostProcessor;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.oauth2.config.annotation.web.configuration.EnableResourceServer;
import org.springframework.security.oauth2.config.annotation.web.configuration.ResourceServerConfigurerAdapter;
import org.springframework.security.oauth2.config.annotation.web.configurers.ResourceServerSecurityConfigurer;
import org.springframework.security.web.access.intercept.FilterSecurityInterceptor;
import org.springframework.security.web.authentication.www.BasicAuthenticationFilter;
import wiki.zex.cloud.example.security.CaptchaAuthenticationProvider;
import wiki.zex.cloud.example.security.MyAccessDecisionManager;
import wiki.zex.cloud.example.security.MyAccessDeniedHandler;
import wiki.zex.cloud.example.security.MyFilterInvocationSecurityMetadataSource;

@EnableResourceServer
@Configuration
@Slf4j
public class ResourceServerConfig extends ResourceServerConfigurerAdapter {


    @Autowired
    private MyAccessDecisionManager myAccessDecisionManager;

    @Autowired
    private MyFilterInvocationSecurityMetadataSource myFilterInvocationSecurityMetadataSource;

    @Autowired
    private MyAccessDeniedHandler myAccessDeniedHandler;
    @Override
    public void configure(ResourceServerSecurityConfigurer resources) throws Exception {
        super.configure(resources);
    }

    @Override
    public void configure(HttpSecurity http) throws Exception {

        http
                .sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                .and()
                .authorizeRequests()
                .withObjectPostProcessor(new ObjectPostProcessor<FilterSecurityInterceptor>() {
                    @Override
                    public <O extends FilterSecurityInterceptor> O postProcess(O object) {
                        object.setSecurityMetadataSource(myFilterInvocationSecurityMetadataSource);
                        object.setAccessDecisionManager(myAccessDecisionManager);
                        return object;
                    }
                })

                .antMatchers("/api/v1/captcha/**").permitAll()
                .antMatchers("/files/**").permitAll()
                .antMatchers("/actuator/**").permitAll()
                .anyRequest()//任何请求
                .authenticated()
                .and().exceptionHandling().accessDeniedHandler(myAccessDeniedHandler);//都需要身份认证
    }



}
