package wiki.zex.cloud.example.exception;


import lombok.Data;
import org.springframework.security.oauth2.common.exceptions.OAuth2Exception;

import java.time.LocalDateTime;


public class ExceptionResp {


    /**
     * timestamp : 2019-04-06T15:12:13.214+0000
     * path : /authApi/v1/oauth/token
     * status : 500
     * error : Internal Server Error
     * message : 当前应用已过期
     */

    private LocalDateTime timestamp = LocalDateTime.now();
    private String path;
    private int status;
    private Object error;
    private String message;


    public LocalDateTime getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(LocalDateTime timestamp) {
        this.timestamp = timestamp;
    }

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Object getError() {
        return error;
    }

    public void setError(Object error) {
        this.error = error;
    }
}
