package wiki.zex.cloud.example.exception;

public class NotFoundException extends RuntimeException {
    public NotFoundException(String message) {
        super(message);
    }

    public NotFoundException() {
        super("资源不存在");
    }
}
