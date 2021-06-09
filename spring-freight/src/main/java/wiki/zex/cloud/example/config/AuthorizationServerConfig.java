package wiki.zex.cloud.example.config;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.common.DefaultOAuth2AccessToken;
import org.springframework.security.oauth2.config.annotation.configurers.ClientDetailsServiceConfigurer;
import org.springframework.security.oauth2.config.annotation.web.configuration.AuthorizationServerConfigurerAdapter;
import org.springframework.security.oauth2.config.annotation.web.configuration.EnableAuthorizationServer;
import org.springframework.security.oauth2.config.annotation.web.configurers.AuthorizationServerEndpointsConfigurer;
import org.springframework.security.oauth2.config.annotation.web.configurers.AuthorizationServerSecurityConfigurer;
import org.springframework.security.oauth2.provider.CompositeTokenGranter;
import org.springframework.security.oauth2.provider.TokenGranter;
import org.springframework.security.oauth2.provider.token.*;
import org.springframework.security.oauth2.provider.token.store.JwtAccessTokenConverter;
import org.springframework.security.oauth2.provider.token.store.JwtTokenStore;
import wiki.zex.cloud.example.entity.SyUser;
import wiki.zex.cloud.example.security.CaptchaTokenGranter;
import wiki.zex.cloud.example.security.MyUserAuthenticationConverter;

import java.util.*;

/**
 * 认证服务器配置
 */
@Configuration
@EnableAuthorizationServer
@Slf4j
public class AuthorizationServerConfig extends AuthorizationServerConfigurerAdapter {
    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private UserDetailsService userDetailsService;

    @Autowired
    private AuthenticationManager authenticationManager;

    private TokenGranter tokenGranter(final AuthorizationServerEndpointsConfigurer endpoints) {
        List<TokenGranter> granters = new ArrayList<TokenGranter>(Collections.singletonList(endpoints.getTokenGranter()));// 获取默认的granter集合
        granters.add(new CaptchaTokenGranter(authenticationManager, endpoints.getTokenServices(), endpoints.getClientDetailsService(), endpoints.getOAuth2RequestFactory()));
        return new CompositeTokenGranter(granters);
    }


    @Bean
    public TokenStore tokenStore() {
        return new JwtTokenStore(jwtAccessTokenConverter());
    }

    @Bean
    public TokenEnhancer tokenEnhancer() {
        return (accessToken, authentication) -> {
            Map<String, Object> additionalInformation = new HashMap<>();
            SyUser syUser = (SyUser) authentication.getPrincipal();
            additionalInformation.put("userId", syUser.getId());
            ((DefaultOAuth2AccessToken) accessToken).setAdditionalInformation(additionalInformation);
            return accessToken;
        };
    }

    @Bean
    public JwtAccessTokenConverter jwtAccessTokenConverter() {
        JwtAccessTokenConverter converter = new JwtAccessTokenConverter();
        converter.setSigningKey("spring-example");
        DefaultAccessTokenConverter accessTokenConverter = new DefaultAccessTokenConverter();
        MyUserAuthenticationConverter myUserAuthenticationConverter = new MyUserAuthenticationConverter();
        myUserAuthenticationConverter.setUserDetailsService(userDetailsService);
        accessTokenConverter.setUserTokenConverter(myUserAuthenticationConverter);
        converter.setAccessTokenConverter(accessTokenConverter);
        return converter;
    }


    /**
     * 配置令牌端点的约束
     *
     * @param security
     * @throws Exception
     */
    @Override
    public void configure(AuthorizationServerSecurityConfigurer security) throws Exception {
        security.allowFormAuthenticationForClients();
    }

    /**
     * 配置客户端信息
     *
     * @param clients
     * @throws Exception
     */
    @Override
    public void configure(ClientDetailsServiceConfigurer clients) throws Exception {
        clients.inMemory().withClient("example_client")
                .secret(passwordEncoder.encode("secret"))
                .refreshTokenValiditySeconds(3600 * 24 *365) //365天
                .accessTokenValiditySeconds(3600 * 30)//30天
                .authorizedGrantTypes("password", "refresh_token", "captcha")
                .scopes("all")
                .and().withClient("master_client")
                .secret(passwordEncoder.encode("secret"))
                .refreshTokenValiditySeconds(3600 * 24 *365) //365天
                .accessTokenValiditySeconds(3600 * 30)//30天
                .authorizedGrantTypes("password", "refresh_token", "captcha")
                .scopes("all")
                .and().withClient("driver_client")
                .secret(passwordEncoder.encode("secret"))
                .refreshTokenValiditySeconds(3600 * 24 *365) //365天
                .accessTokenValiditySeconds(3600 * 30)//30天
                .authorizedGrantTypes("password", "refresh_token", "captcha")
                .scopes("all");
        super.configure(clients);
    }

    /**
     * 配置授权 令牌等信息
     *
     * @param endpoints
     * @throws Exception
     */
    @Override
    public void configure(AuthorizationServerEndpointsConfigurer endpoints) throws Exception {
        TokenEnhancerChain tokenEnhancerChain = new TokenEnhancerChain();
        List<TokenEnhancer> tokenEnhancers = new ArrayList<>();
        tokenEnhancers.add(tokenEnhancer());
        tokenEnhancers.add(jwtAccessTokenConverter());
        tokenEnhancerChain.setTokenEnhancers(tokenEnhancers);
        endpoints.allowedTokenEndpointRequestMethods(HttpMethod.POST)
                .tokenStore(tokenStore())
                .tokenEnhancer(tokenEnhancerChain)
                .tokenGranter((tokenGranter(endpoints)))
                .authenticationManager(authenticationManager)
                .userDetailsService(userDetailsService);
        super.configure(endpoints);
    }
}