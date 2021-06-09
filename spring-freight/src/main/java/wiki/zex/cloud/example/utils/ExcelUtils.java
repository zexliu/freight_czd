package wiki.zex.cloud.example.utils;

import com.alibaba.excel.EasyExcel;
import com.alibaba.excel.event.AnalysisEventListener;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.multipart.MultipartFile;
import wiki.zex.cloud.example.exception.ServerException;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.List;

public class ExcelUtils {

    private static final Logger LOGGER = LoggerFactory.getLogger(ExcelUtils.class);
    public static final int BATCH_COUNT = 1000;

    public static <T> void write(HttpServletResponse response, List<T> data, Class<T> clazz, String fileName) {

        // 这里URLEncoder.encode可以防止中文乱码 当然和easy excel没有关系
        try {
            response.setContentType("application/vnd.ms-excel");
            response.setCharacterEncoding("utf-8");
            fileName = URLEncoder.encode(fileName, "UTF-8");
            response.setHeader("Content-disposition", "attachment;filename=" + fileName + ".xlsx");
            // 这里需要设置不关闭流
            EasyExcel.write(response.getOutputStream(), clazz).autoCloseStream(Boolean.FALSE).sheet("模板")
                    .doWrite(data);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServerException("导出Excel失败: " + e.getMessage());
        }

    }


    public static <T> void read(Class<T> tClass, MultipartFile file, AnalysisEventListener<T> listener) {
        try {
            EasyExcel.read(file.getInputStream(), tClass, listener).sheet().doRead();
        } catch (IOException e) {
            e.printStackTrace();
            throw new ServerException("导入Excel失败: " + e.getMessage());
        }

    }
}
