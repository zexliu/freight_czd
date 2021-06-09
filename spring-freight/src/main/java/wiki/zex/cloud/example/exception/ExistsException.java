package wiki.zex.cloud.example.exception;

public class ExistsException extends RuntimeException{

    public ExistsException(String message) {
        super(message);
    }
}
