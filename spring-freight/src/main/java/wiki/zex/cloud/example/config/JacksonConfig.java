package wiki.zex.cloud.example.config;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.*;
import com.fasterxml.jackson.databind.module.SimpleModule;
import com.fasterxml.jackson.datatype.jdk8.Jdk8Module;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.fasterxml.jackson.datatype.jsr310.deser.LocalDateDeserializer;
import com.fasterxml.jackson.datatype.jsr310.deser.LocalTimeDeserializer;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateSerializer;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalTimeSerializer;
import com.fasterxml.jackson.module.paramnames.ParameterNamesModule;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import wiki.zex.cloud.example.config.serializers.JsonLocalDateTimeDeserializer;
import wiki.zex.cloud.example.config.serializers.JsonLocalDateTimeSerializer;

import java.time.*;
import java.time.format.DateTimeFormatter;

@Configuration
public class JacksonConfig {

    @Bean
    ObjectMapper objectMapper(){
        ObjectMapper objectMapper = new ObjectMapper();
        SimpleModule simpleModule = new SimpleModule();
        objectMapper
                .configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES,false) //反序列化的时候如果多了其他属性,不抛出异常
                .setSerializationInclusion(JsonInclude.Include.NON_NULL)
                .configure(SerializationFeature.FAIL_ON_EMPTY_BEANS, false) //如果是空对象的时候,不抛异常
                .registerModule(simpleModule)
                .registerModule(new JavaTimeModule()
                        .addSerializer(LocalDateTime.class, new JsonLocalDateTimeSerializer())
                        .addSerializer(LocalDate.class, new LocalDateSerializer(DateTimeFormatter.ofPattern("yyyy-MM-dd")))
                        .addSerializer(LocalTime.class,new LocalTimeSerializer(DateTimeFormatter.ofPattern("HH:mm:ss")))
                        .addDeserializer(LocalDateTime.class, new JsonLocalDateTimeDeserializer())
                        .addDeserializer(LocalDate.class,new LocalDateDeserializer(DateTimeFormatter.ofPattern("yyyy-MM-dd")))
                        .addDeserializer(LocalTime.class,new LocalTimeDeserializer(DateTimeFormatter.ofPattern("HH:mm:ss")))
                )
                .registerModule(new ParameterNamesModule())
                .registerModule(new Jdk8Module());
        return objectMapper;
    }



}
