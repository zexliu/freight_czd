package wiki.zex.cloud.example.exception;

public class ForbiddenException extends RuntimeException{

    public ForbiddenException(String message) {
        super(message);
    }

    public ForbiddenException() {
        super("服务器拒绝该请求");
    }
}
