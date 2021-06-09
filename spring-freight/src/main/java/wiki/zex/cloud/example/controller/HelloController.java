package wiki.zex.cloud.example.controller;

import org.springframework.security.access.annotation.Secured;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import wiki.zex.cloud.example.utils.MessageUtil;


@RestController
public class HelloController {
//
//    @Autowired
//    private MessageSource messageSource;
    @GetMapping("/admin/hello")
    @Secured("ROLE_ADMIN")
    public String hello(){
        return "Hello,it's safe";
    }

//    @GetMapping("admin/hello")
//    public String adminHello(){
//        return "Hello,admin is safe";
//    }
//
    @GetMapping("/user/hello")
    @PreAuthorize("hasRole('USER')")
    public String userHello(){
        return "Hello,user is safe";
    }


    @GetMapping("/hello")
    public String hello(Authentication authentication) {
//        return messageSource.getMessage("hello",null, LocaleContextHolder.getLocale());

        return MessageUtil.getMessage("hello");
    }

}