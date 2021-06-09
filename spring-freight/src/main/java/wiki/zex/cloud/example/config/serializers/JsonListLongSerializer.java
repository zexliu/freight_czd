package wiki.zex.cloud.example.config.serializers;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

import java.io.IOException;
import java.util.List;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class JsonListLongSerializer extends JsonSerializer<List<Long>> {

    @Override
    public void serialize(List<Long> value, JsonGenerator jsonGenerator, SerializerProvider serializers) throws IOException {
        List<String> list = value.stream().flatMap(new Function<Long, Stream<String>>() {
            @Override
            public Stream<String> apply(Long aLong) {
                return Stream.of(String.valueOf(aLong));
            }
        }).collect(Collectors.toList());

        jsonGenerator.writeObject(list);
    }
}
