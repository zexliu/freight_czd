package wiki.zex.cloud.example.service;

import wiki.zex.cloud.example.entity.AmAuditHistory;
import com.baomidou.mybatisplus.extension.service.IService;
import wiki.zex.cloud.example.req.AmAuditReq;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author Zex
 * @since 2020-09-21
 */
public interface IAmAuditHistoryService extends IService<AmAuditHistory> {

    void audit(AmAuditReq req, String ip, Long id);

}
