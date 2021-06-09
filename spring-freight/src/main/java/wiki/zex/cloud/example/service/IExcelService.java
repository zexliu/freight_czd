package wiki.zex.cloud.example.service;

import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;

public interface IExcelService {

    void download(HttpServletResponse httpServletResponse);


    void upload(MultipartFile file, HttpServletRequest request) throws IOException;

}
