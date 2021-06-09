package wiki.zex.cloud.example.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.springframework.security.core.Authentication;
import wiki.zex.cloud.example.entity.FoDeliveryExtension;
import com.baomidou.mybatisplus.extension.service.IService;
import wiki.zex.cloud.example.enums.AuditStatus;
import wiki.zex.cloud.example.req.FoDeliveryExtensionReq;
import wiki.zex.cloud.example.resp.FoDeliveryExtensionResp;

/**
 * <p>
 * 用户发货 拓展信息 服务类
 * </p>
 *
 * @author Zex
 * @since 2020-07-02
 */
public interface IFoDeliveryExtensionService extends IService<FoDeliveryExtension> {

    FoDeliveryExtension create(FoDeliveryExtensionReq req, Authentication authentication);

    FoDeliveryExtension update(Long id, FoDeliveryExtensionReq req, Authentication authentication);

    FoDeliveryExtensionResp get(Authentication authentication);


    IPage<FoDeliveryExtensionResp> findPage(Page<Object> page, AuditStatus auditStatus);

}
