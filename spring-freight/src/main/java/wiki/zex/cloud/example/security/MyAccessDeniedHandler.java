package wiki.zex.cloud.example.security;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.stereotype.Component;
import wiki.zex.cloud.example.exception.ExceptionResp;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;

@Component
public class MyAccessDeniedHandler implements AccessDeniedHandler {

    @Autowired
    private ObjectMapper objectMapper;
    @Override
    public void handle(HttpServletRequest request, HttpServletResponse response, AccessDeniedException e) throws IOException, ServletException {
        response.setStatus(HttpStatus.FORBIDDEN.value());
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        ExceptionResp resp = new ExceptionResp();
        resp.setMessage("权限不足,需要权限 "+e.getMessage());
        resp.setPath(request.getRequestURI());
        resp.setError(e);
        response.setStatus(HttpStatus.FORBIDDEN.value());
        resp.setTimestamp(LocalDateTime.now());
        out.write(objectMapper.writeValueAsString(resp));
        out.flush();
        out.close();
    }
}