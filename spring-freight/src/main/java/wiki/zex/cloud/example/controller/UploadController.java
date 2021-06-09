package wiki.zex.cloud.example.controller;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import wiki.zex.cloud.example.exception.ServerException;
import wiki.zex.cloud.example.service.IUploadService;
import wiki.zex.cloud.example.utils.Base64MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.io.*;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;

@RestController
@RequestMapping("/api/v1/upload")
@Api(tags = "文件上传相关接口")
@Slf4j
public class UploadController {


    @Autowired
    private IUploadService iUploadService;


    @PostMapping
    @ApiOperation("上传文件")
    public String upload(@RequestParam(value = "file") MultipartFile file, HttpServletRequest request) {

        if (file.isEmpty()) {
            throw new ServerException();
        }
        String fileName = file.getOriginalFilename();  // 文件名
        try {
            return iUploadService.saveFile(fileName,new ByteArrayInputStream(file.getBytes()));
        } catch (IOException e) {
            throw new ServerException();
        }
    }

    @PostMapping("/multi")
    @ApiOperation("上传文件")
    public List<String> uploadMulti(@RequestParam(value = "files") MultipartFile[] files, HttpServletRequest request) {
        List<String> urls = new ArrayList<>();
        for (MultipartFile file : files) {
            String fileName = file.getOriginalFilename();  // 文件名
            try {
                String url = iUploadService.saveFile(fileName, new ByteArrayInputStream(file.getBytes()));
                urls.add(url);
            } catch (IOException e) {
                throw new ServerException();
            }
        }

        return urls;
    }


    @PostMapping("/base64")
    @ApiOperation("上传文件")
    public String upload(@RequestParam String base64,@RequestParam String fileName, HttpServletRequest request) {
        try {
            String[] base64Strings = base64.split(",");
            Base64.Decoder decoder = Base64.getMimeDecoder();
            byte[] bytes = decoder.decode(base64Strings[1]);
            for(int i = 0; i < bytes.length; ++i) {
                if (bytes[i] < 0) {
                    bytes[i] += 256;
                }
            }

            MultipartFile file = new Base64MultipartFile(bytes, base64Strings[0] , fileName);
            return iUploadService.saveFile(fileName,new ByteArrayInputStream(file.getBytes()));
        } catch (IOException e) {
            throw new ServerException();
        }
    }

}
