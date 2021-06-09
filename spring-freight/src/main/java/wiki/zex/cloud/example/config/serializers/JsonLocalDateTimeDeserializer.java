package wiki.zex.cloud.example.config.serializers;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;
import org.springframework.util.StringUtils;

import java.io.IOException;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;

public class JsonLocalDateTimeDeserializer extends JsonDeserializer<LocalDateTime> {
    @Override
    public LocalDateTime deserialize(JsonParser p, DeserializationContext context) throws IOException, JsonProcessingException {
        if (p != null && !StringUtils.isEmpty(p.getText())) {
            Instant instant = Instant.ofEpochMilli(Long.parseLong(p.getText()));
            return LocalDateTime.ofInstant(instant, ZoneId.systemDefault());
        }
        return null;

    }
}
