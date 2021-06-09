package wiki.zex.cloud.example.utils;

import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Component;

public class MessageUtil  {

    public static String getMessage(String code){
       return SpringUtil.getBean(MessageSource.class)
               .getMessage(code,null, LocaleContextHolder.getLocale());
    }

}
