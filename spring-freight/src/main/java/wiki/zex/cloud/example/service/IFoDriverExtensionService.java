package wiki.zex.cloud.example.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.springframework.security.core.Authentication;
import wiki.zex.cloud.example.entity.FoDeliveryExtension;
import wiki.zex.cloud.example.entity.FoDriverExtension;
import com.baomidou.mybatisplus.extension.service.IService;
import wiki.zex.cloud.example.enums.AuditStatus;
import wiki.zex.cloud.example.req.FoDriverExtensionReq;
import wiki.zex.cloud.example.resp.FoDriverExtensionResp;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author Zex
 * @since 2020-07-17
 */
public interface IFoDriverExtensionService extends IService<FoDriverExtension> {

    FoDriverExtension getByUserId(Long id);

    FoDriverExtension create(FoDriverExtensionReq req, Authentication authentication);

    FoDriverExtension update(Long id, FoDriverExtensionReq req, Authentication authentication);


    FoDriverExtensionResp get(Authentication authentication);


    IPage<FoDriverExtensionResp> findPage(Page<FoDriverExtensionResp> convert, AuditStatus auditStatus);

}
