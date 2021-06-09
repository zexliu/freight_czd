package wiki.zex.cloud.example.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.File;
import java.io.IOException;
import java.util.Scanner;

@RestController
@RequestMapping("/api/v1/areas")
public class AreaController {
    @Value("classpath:static/area.json")
    private Resource jsonData;

    @GetMapping
    public String areas() throws IOException {
        File file = jsonData.getFile();
        Scanner scanner = null;
        StringBuilder buffer = new StringBuilder();
        try {
            scanner = new Scanner(file, "utf-8");
            while (scanner.hasNextLine()) {
                buffer.append(scanner.nextLine());
            }
        }finally {
            if (scanner != null) {
                scanner.close();
            }
        }
        return buffer.toString();
    }
}
