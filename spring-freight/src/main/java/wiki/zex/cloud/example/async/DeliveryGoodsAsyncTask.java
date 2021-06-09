package wiki.zex.cloud.example.async;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.common.collect.Sets;
import lombok.extern.slf4j.Slf4j;
import mob.push.api.client.push.PushV3Client;
import mob.push.api.config.MobPushConfig;
import mob.push.api.model.*;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;
import wiki.zex.cloud.example.entity.FoDeliverGoods;
import wiki.zex.cloud.example.entity.FoOftenLine;
import wiki.zex.cloud.example.entity.FoOrder;
import wiki.zex.cloud.example.enums.AuditStatus;
import wiki.zex.cloud.example.resp.DeliveryGoodsMessage;
import wiki.zex.cloud.example.resp.PushOrderMsg;
import wiki.zex.cloud.example.security.MyUserDetails;
import wiki.zex.cloud.example.service.IFoOftenLineService;
import wiki.zex.cloud.example.socket.WebSocketServer;

import java.io.IOException;
import java.time.ZoneOffset;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Component
@Slf4j
public class DeliveryGoodsAsyncTask {
    int iosProduction  = 1;
    @Autowired
    private IFoOftenLineService iFoOftenLineService;

    @Autowired
    private ObjectMapper objectMapper;

//    @Autowired
//    private ISyUserService iSyUserService;
    @Async
    public void pushGoodsToClient(FoDeliverGoods goods) {

        List<FoOftenLine> online = iFoOftenLineService.findByStatus(true);
        for (FoOftenLine oftenLine : online) {
            //检查装货地
            boolean isOk = checkLocation(oftenLine.getLoadAreas(), goods.getLoadProvinceCode(), goods.getLoadCityCode(), goods.getLoadDistrictCode());
            if (!isOk) {
                return;
            }
            isOk = checkLocation(oftenLine.getUnloadAreas(), goods.getUnloadProvinceCode(), goods.getUnloadCityCode(), goods.getUnloadDistrictCode());
            if (!isOk) {
                return;
            }
            if (StringUtils.isNotBlank(oftenLine.getCarLongs())) {
                isOk = checkList(oftenLine.getCarLongs(), goods.getCarLongs());
            }
            if (!isOk) {
                return;
            }
            if (StringUtils.isNotBlank(oftenLine.getCarModels())) {
                isOk = checkList(oftenLine.getCarModels(), goods.getCarModels());
            }
            if (!isOk) {
                return;
            }
            DeliveryGoodsMessage message = new DeliveryGoodsMessage();
            message.setDeliveryId(goods.getId());
            message.setOnlineId(oftenLine.getId());
            message.setType(1);
            try {
                String msg = objectMapper.writeValueAsString(message);
                WebSocketServer.sendMessage(msg, oftenLine.getUserId());
            } catch (IOException e) {
                e.printStackTrace();
            }

        }
    }

    private boolean checkList(String from, String to) {
        List<String> split = Arrays.asList(from.split(","));
        return CollectionUtils.containsAny(split, to.split(","));
    }

    private boolean checkLocation(String areas, String loadProvinceCode, String cityCode, String loadDistrictCode) {
        String[] split = areas.split(",");
        for (String s : split) {

            if (StringUtils.equals(s, loadProvinceCode)) {
                return true;
            }
            if (StringUtils.equals(s, cityCode)) {
                return true;
            }
            if (StringUtils.equals(s, loadDistrictCode)) {
                return true;
            }
        }

        return false;
    }

    public void pushOrder(boolean isUser, Long toId, PushOrderMsg pushOrderMsg) {
        setUpNotification(isUser);
        List<PushMap> mapList = new ArrayList<>();
        mapList.add(PushMap.builder().key("type").value("1").build());
        mapList.add(PushMap.builder().key("orderId").value(String.valueOf(pushOrderMsg.getOrderId())).build());
        mapList.add(PushMap.builder().key("userId").value(toId.toString()).build());
        mapList.add(PushMap.builder().key("title").value(pushOrderMsg.getNickname() + "向你发来一条新订单").build());
        mapList.add(PushMap.builder().key("deliveryId").value(String.valueOf(pushOrderMsg.getDeliveryId())).build());
        mapList.add(PushMap.builder().key("loadProvinceCode").value(pushOrderMsg.getLoadProvinceCode()).build());
        mapList.add(PushMap.builder().key("loadCityCode").value(pushOrderMsg.getLoadCityCode()).build());
        mapList.add(PushMap.builder().key("loadDistrictCode").value(pushOrderMsg.getLoadDistrictCode()).build());
        mapList.add(PushMap.builder().key("unloadProvinceCode").value(pushOrderMsg.getUnloadProvinceCode()).build());
        mapList.add(PushMap.builder().key("unloadCityCode").value(pushOrderMsg.getUnloadCityCode()).build());
        mapList.add(PushMap.builder().key("unloadDistrictCode").value(pushOrderMsg.getUnloadDistrictCode()).build());
        mapList.add(PushMap.builder().key("carLongs").value(pushOrderMsg.getCarLongs()).build());
        mapList.add(PushMap.builder().key("carModels").value(pushOrderMsg.getCarModels()).build());
        mapList.add(PushMap.builder().key("weight").value(String.valueOf(pushOrderMsg.getWeight())).build());
        mapList.add(PushMap.builder().key("volume").value(String.valueOf(pushOrderMsg.getVolume())).build());
        mapList.add(PushMap.builder().key("mobile").value(String.valueOf(pushOrderMsg.getMobile())).build());
        mapList.add(PushMap.builder().key("nickname").value(String.valueOf(pushOrderMsg.getNickname())).build());
        mapList.add(PushMap.builder().key("amount").value(String.valueOf(pushOrderMsg.getAmount())).build());
        mapList.add(PushMap.builder().key("freightAmount").value(String.valueOf(pushOrderMsg.getFreightAmount())).build());
        mapList.add(PushMap.builder().key("loadStartAt").value(String.valueOf(pushOrderMsg.getLoadStartAt().toInstant(ZoneOffset.of("+8")).toEpochMilli())).build());
        mapList.add(PushMap.builder().key("loadEndAt").value(String.valueOf(pushOrderMsg.getLoadEndAt().toInstant(ZoneOffset.of("+8")).toEpochMilli())).build());
        mapList.add(PushMap.builder().key("freightAmount").value(String.valueOf(pushOrderMsg.getFreightAmount())).build());
        Push.PushBuilder build = Push.builder()
                .appkey(MobPushConfig.appkey)
                .pushTarget(PushTarget.builder().target(2).alias(Sets.newHashSet(String.valueOf(toId))).build())
                .pushNotify(PushNotify.builder()
                        .iosProduction(iosProduction)
                        .type(1)
                        .title("新订单")
                        .content(pushOrderMsg.getNickname() + "向你发来一条新订单")
                        .androidNotify(AndroidNotify.builder()
                                .style(0)
                                .warn("123")
                                .build())
                        .iosNotify(IosNotify.builder()
                                .badge(1)
                                .badgeType(2)
                                .build())
                        .extrasMapList(mapList)
                        .offlineSeconds(86400)
                        .build());

        try {
            PushV3Client.pushTaskV3(build.build());

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void pushProtocolToClient(FoOrder order, MyUserDetails myUserDetails) {
        boolean isUser = myUserDetails.getClientId().equals("master_client");
        setUpNotification(!isUser);
        List<PushMap> mapList = new ArrayList<>();
        mapList.add(PushMap.builder().key("type").value("2").build());
        mapList.add(PushMap.builder().key("orderId").value(String.valueOf(order.getId())).build());
        mapList.add(PushMap.builder().key("title").value(myUserDetails.getNickname() + "向你提交协议申请").build());
        Push.PushBuilder build = Push.builder()
                .appkey(MobPushConfig.appkey)
                .pushTarget(PushTarget.builder().target(2).alias(Sets.newHashSet(String.valueOf(isUser ? order.getDriverId() : order.getUserId()))).build())
                .pushNotify(PushNotify.builder()
                        .iosProduction(iosProduction)
                        .type(1)
                        .title("协议申请")
                        .content(myUserDetails.getNickname() + "向你提交协议申请")
                        .androidNotify(AndroidNotify.builder()
                                .style(0)
                                .warn("123")
                                .build())
                        .iosNotify(IosNotify.builder()
                                .badge(1)
                                .badgeType(2)
                                .build())
                        .extrasMapList(mapList)
                        .offlineSeconds(86400)
                        .build());

        try {
            PushV3Client.pushTaskV3(build.build());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void pushProtocolAgreeToClient(FoOrder order, MyUserDetails myUserDetails) {
        boolean isUser = myUserDetails.getClientId().equals("master_client");
        setUpNotification(!isUser);
        List<PushMap> mapList = new ArrayList<>();
        mapList.add(PushMap.builder().key("type").value("3").build());
        mapList.add(PushMap.builder().key("orderId").value(String.valueOf(order.getId())).build());
        mapList.add(PushMap.builder().key("title").value(myUserDetails.getNickname() + "同意了您的协议申请").build());
        Push.PushBuilder build = Push.builder()
                .appkey(MobPushConfig.appkey)
                .pushTarget(PushTarget.builder().target(2).alias(Sets.newHashSet(String.valueOf(isUser ? order.getDriverId() : order.getUserId()))).build())
                .pushNotify(PushNotify.builder()
                        .iosProduction(iosProduction)
                        .type(1)
                        .title("协议通过")
                        .content(myUserDetails.getNickname() + "同意了您的协议申请")
                        .androidNotify(AndroidNotify.builder()
                                .style(0)
                                .warn("123")
                                .build())
                        .iosNotify(IosNotify.builder()
                                .badge(1)
                                .badgeType(2)
                                .build())
                        .extrasMapList(mapList)
                        .offlineSeconds(86400)
                        .build());

        try {
            PushV3Client.pushTaskV3(build.build());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void pushCancelOrder(FoOrder order, MyUserDetails myUserDetails) {
        boolean isUser = myUserDetails.getClientId().equals("master_client");
        setUpNotification(!isUser);
        List<PushMap> mapList = new ArrayList<>();
        mapList.add(PushMap.builder().key("type").value("4").build());
        mapList.add(PushMap.builder().key("orderId").value(String.valueOf(order.getId())).build());
        mapList.add(PushMap.builder().key("title").value(myUserDetails.getNickname() + "取消了订单").build());
        Push.PushBuilder build = Push.builder()
                .appkey(MobPushConfig.appkey)
                .pushTarget(PushTarget.builder().target(2).alias(Sets.newHashSet(String.valueOf(isUser ? order.getDriverId() : order.getUserId()))).build())
                .pushNotify(PushNotify.builder()
                        .iosProduction(iosProduction)
                        .type(1)
                        .title("取消订单")
                        .content(myUserDetails.getNickname() + "取消了订单")
                        .androidNotify(AndroidNotify.builder()
                                .style(0)
                                .warn("123")
                                .build())
                        .iosNotify(IosNotify.builder()
                                .badge(1)
                                .badgeType(2)
                                .build())
                        .extrasMapList(mapList)
                        .offlineSeconds(86400)
                        .build());

        try {
            PushV3Client.pushTaskV3(build.build());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void pushAuditAuthenticationToClient(Long userId, boolean isUser, AuditStatus auditStatus,String message) {
        setUpNotification(isUser);
        List<PushMap> mapList = new ArrayList<>();
        String title = auditStatus == AuditStatus.PASSED ? "审核通过":"审核驳回";
        mapList.add(PushMap.builder().key("type").value("5").build());
        mapList.add(PushMap.builder().key("title").value(title).build());
        Push.PushBuilder build = Push.builder()
                .appkey(MobPushConfig.appkey)
                .pushTarget(PushTarget.builder().target(2).alias(Sets.newHashSet(String.valueOf(userId))).build())
                .pushNotify(PushNotify.builder()
                        .iosProduction(iosProduction)
                        .type(1)
                        .title(title)
                        .content(StringUtils.isNoneBlank(message)? message: "审核已通过")
                        .androidNotify(AndroidNotify.builder()
                                .style(0)
                                .warn("123")
                                .build())
                        .iosNotify(IosNotify.builder()
                                .badge(1)
                                .badgeType(2)
                                .build())
                        .extrasMapList(mapList)
                        .offlineSeconds(86400)
                        .build());
        try {
            PushV3Client.pushTaskV3(build.build());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void setUpNotification(boolean isUser) {
        if (isUser) { //用户发送给司机
            MobPushConfig.appkey = "306109a2a59b6";
            MobPushConfig.appSecret = "74324fa866907084fcea546d06aee854";
        } else {
            MobPushConfig.appkey = "3059b5b2e0eab";
            MobPushConfig.appSecret = "030267290b9f02dbb3f3a69835c395b8";
        }
    }


}
