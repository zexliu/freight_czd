package wiki.zex.cloud.example.utils;

import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Nullable;
import java.io.*;

public class Base64MultipartFile implements MultipartFile {



    private final String header;
    private final byte[] bytes;
    private final String fileName;
    public Base64MultipartFile(byte[] bytes, String header, String fileName) {
        this.bytes = bytes;
        this.header = header.split(";")[0];
        this.fileName = fileName;
    }
    @Override
    public String getName() {
        return System.currentTimeMillis() + Math.random() + "." + header.split("/")[1];
    }

    @Override
    public String getOriginalFilename() {
        return fileName;
    }

    @Override
    public String getContentType() {
        return header.split(":")[1];
    }

    @Override
    public boolean isEmpty() {
        return bytes == null || bytes.length == 0;
    }

    @Override
    public long getSize() {
        return bytes.length;
    }

    @Override
    public byte[] getBytes() throws IOException {
        return bytes;
    }

    @Override
    public InputStream getInputStream() throws IOException {
        return new ByteArrayInputStream(bytes);
    }

    @Override
    public void transferTo(File dest) throws IOException, IllegalStateException {
        new FileOutputStream(dest).write(bytes);
    }
}