package wiki.zex.cloud.example.service;

import wiki.zex.cloud.example.entity.SyRole;
import com.baomidou.mybatisplus.extension.service.IService;
import wiki.zex.cloud.example.req.SyRoleReq;
import wiki.zex.cloud.example.resp.SyRoleResp;

import java.util.List;

/**
 * <p>
 * 角色表 服务类
 * </p>
 *
 * @author Zex
 * @since 2020-05-28
 */
public interface ISyRoleService extends IService<SyRole> {

    SyRole create(SyRoleReq req);

    SyRole update(Long id, SyRoleReq req);

    void delete(Long id);

    SyRoleResp detailsById(Long id);

    List<SyRoleResp> findRolesByUserId(Long id);

    List<String> findRoleCodesByPermissionId(Long id);

}
