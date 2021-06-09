package wiki.zex.cloud.example.controller;


import com.alibaba.excel.EasyExcel;
import io.swagger.annotations.ApiOperation;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import wiki.zex.cloud.example.resp.SimpleResp;
import wiki.zex.cloud.example.service.IExcelService;
import wiki.zex.cloud.example.utils.ExcelUtils;
import wiki.zex.cloud.example.utils.SpringUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/excel")
@ApiOperation("excel相关接口")
public class ExcelController {

    @GetMapping("download")
    public void download(@RequestParam String name, HttpServletResponse response){
        ((IExcelService)SpringUtil.getBean(name+"ServiceImpl")).download(response);
    }

    @PostMapping("upload")
    public SimpleResp upload(@RequestParam String name, @RequestPart MultipartFile file, HttpServletRequest request) throws IOException {
        ((IExcelService)SpringUtil.getBean(name+"ServiceImpl")).upload(file,request);
        return SimpleResp.SUCCESS;
    }


}
