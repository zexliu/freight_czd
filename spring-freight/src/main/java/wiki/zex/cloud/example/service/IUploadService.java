package wiki.zex.cloud.example.service;

import java.io.InputStream;

public interface IUploadService {
    String saveFile(String fileName, InputStream byteArrayInputStream);
}
