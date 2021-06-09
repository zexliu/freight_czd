package wiki.zex.cloud.example.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;


@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Value("${files-location}")
    public String filesLocation;

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("static/**")
                .addResourceLocations("classpath:/static/");
        registry.addResourceHandler("files/**")
                .addResourceLocations("file:" + filesLocation + "/");
    }

}