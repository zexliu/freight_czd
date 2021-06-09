package wiki.zex.cloud.example.config.serializers;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZoneOffset;

public class JsonLocalDateTimeSerializer extends JsonSerializer<LocalDateTime> {

    @Override
    public void serialize(LocalDateTime value, JsonGenerator gen, SerializerProvider serializers) throws IOException {
        if (value != null){
            ZoneOffset zoneOffset = ZoneId.systemDefault().getRules().getOffset(value);
            gen.writeNumber(value.toInstant(zoneOffset).toEpochMilli());
        }

    }
}
