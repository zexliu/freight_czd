package wiki.zex.cloud.example.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import wiki.zex.cloud.example.async.DeliveryGoodsAsyncTask;
import wiki.zex.cloud.example.entity.AmAuditHistory;
import wiki.zex.cloud.example.mapper.AmAuditHistoryMapper;
import wiki.zex.cloud.example.req.AmAuditReq;
import wiki.zex.cloud.example.resp.AuditAuthenticationPush;
import wiki.zex.cloud.example.service.AuditProcessor;
import wiki.zex.cloud.example.service.IAmAuditHistoryService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;
import wiki.zex.cloud.example.service.IFoDeliveryExtensionService;
import wiki.zex.cloud.example.service.IFoDriverExtensionService;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author Zex
 * @since 2020-09-21
 */
@Service
public class AmAuditHistoryServiceImpl extends ServiceImpl<AmAuditHistoryMapper, AmAuditHistory> implements IAmAuditHistoryService {

    @Autowired
    private AuditProcessor iFoDeliveryExtensionService;

    @Autowired
    private AuditProcessor iFoDriverExtensionService;
    @Autowired
    private DeliveryGoodsAsyncTask deliveryGoodsAsyncTask;
    @Override
    public void audit(AmAuditReq req, String operatorIp, Long operatorId) {
        AuditAuthenticationPush push = null;
        switch (req.getTargetType()) {
            case USER_AUTHENTICATION:
                push = iFoDeliveryExtensionService.auditProcess(req.getTargetId(), req.getAuditStatus());
                break;
            case DRIVER_AUTHENTICATION:
                push = iFoDriverExtensionService.auditProcess(req.getTargetId(), req.getAuditStatus());
                break;
            default:
                push = new AuditAuthenticationPush();
                break;
        }
        deliveryGoodsAsyncTask.pushAuditAuthenticationToClient(push.getUserId(),push.isUser(),req.getAuditStatus(),req.getMessage());

        AmAuditHistory amAuditHistory = new AmAuditHistory();
        amAuditHistory.setMessage(req.getMessage());
        amAuditHistory.setOperatorId(operatorId);
        amAuditHistory.setOperatorIp(operatorIp);
        amAuditHistory.setSnapshot(push.getBody());
        amAuditHistory.setStatus(req.getAuditStatus());
        amAuditHistory.setTargetId(req.getTargetId());
        amAuditHistory.setTargetType(req.getTargetType());
        save(amAuditHistory);


    }
}
