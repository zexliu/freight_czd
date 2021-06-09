package wiki.zex.cloud.example.entity;

import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

@Data
public class SyCaptcha implements Serializable {


    public SyCaptcha() {
    }

    public SyCaptcha(String code, LocalDateTime retryTime){
        this.code = code;
        this.retryTime = retryTime;
    }

    private String code;

    private LocalDateTime retryTime;




}