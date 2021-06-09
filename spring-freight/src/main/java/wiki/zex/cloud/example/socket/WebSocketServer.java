package wiki.zex.cloud.example.socket;

import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.stereotype.Component;
import wiki.zex.cloud.example.security.MyUserDetails;
import wiki.zex.cloud.example.service.IFoOftenLineService;
import wiki.zex.cloud.example.utils.SpringUtil;

import javax.websocket.*;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@ServerEndpoint("/ws/v1/lines/{clientId}")
@Component
@Slf4j
public class WebSocketServer {

    private static IFoOftenLineService iFoOftenLineService;

    @Autowired
    public void setiFoOftenLineService(IFoOftenLineService iFoOftenLineService) {
        WebSocketServer.iFoOftenLineService = iFoOftenLineService;
    }

    /**
     * 静态变量，用来记录当前在线连接数。应该把它设计成线程安全的。
     */
    private static int onlineCount = 0;
    /**
     * concurrent包的线程安全Set，用来存放每个设备对应的MyWebSocket对象。
     */
    private static final Map<Long, Session> onlineSessions = new ConcurrentHashMap<>();

    public static boolean isConnect(Long id) {

        return onlineSessions.get(id) != null;
    }


    @OnOpen
    public void onOpen(Session session, @PathParam("clientId") Long clientId) {
        if (onlineSessions.containsKey(clientId)) {
            onlineSessions.remove(clientId);
            onlineSessions.put(clientId, session);
        } else {
            onlineSessions.put(clientId, session);
            addOnlineCount();
        }
//        iFoOftenLineService = SpringUtil.getBean(IFoOftenLineService.class);
        iFoOftenLineService.updateStatus(clientId, true);
        log.info("设备连接:" + clientId + ",当前在线设备数为:" + getOnlineCount());
        try {
            sendMessage("connected", clientId);
        } catch (IOException e) {
            log.error("设备:" + clientId + ",网络异常!!!!!!");
        }
    }

    /**
     * 连接关闭调用的方法
     */
    @OnClose
    public void onClose(@PathParam("clientId") Long clientId) {
        if (onlineSessions.containsKey(clientId)) {
            onlineSessions.remove(clientId);
            //从set中删除
            subOnlineCount();
        }
        iFoOftenLineService.updateStatus(clientId, false);
        log.info("设备退出:" + clientId + ",当前在线设备数为:" + getOnlineCount());
    }

    /**
     * 发送自定义消息
     */
    public static void sendMessage(String message, Long clientId) throws IOException {
        log.info("发送消息到:" + clientId + "，报文:" + message);
        if (clientId != null && onlineSessions.containsKey(clientId)) {
            onlineSessions.get(clientId).getBasicRemote().sendText(message);
        } else {
            log.error("设备" + clientId + ",不在线！");
        }
    }


    /**
     * 收到客户端消息后调用的方法
     *
     * @param message 客户端发送过来的消息
     */
    @OnMessage
    public void onMessage(String message, Session session, @PathParam("clientId") String clientId) {
        log.info("设备消息:" + clientId + ",报文:" + message);
        //消息保存到数据库、redis
        if (StringUtils.isNotBlank(message)) {

        }
    }

    /**
     * @param session
     * @param error
     */
    @OnError
    public void onError(Session session, @PathParam("clientId") String clientId, Throwable error) {
        log.error("未知错误:" + clientId + ",原因:" + error.getMessage());
        error.printStackTrace();
    }

    public static synchronized int getOnlineCount() {
        return onlineCount;
    }

    public static synchronized void addOnlineCount() {
        WebSocketServer.onlineCount++;
    }

    public static synchronized void subOnlineCount() {
        WebSocketServer.onlineCount--;
    }

}
