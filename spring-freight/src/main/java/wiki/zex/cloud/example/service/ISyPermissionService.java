package wiki.zex.cloud.example.service;

import wiki.zex.cloud.example.entity.SyPermission;
import com.baomidou.mybatisplus.extension.service.IService;
import wiki.zex.cloud.example.req.SyPermissionReq;
import wiki.zex.cloud.example.resp.SyPermissionTree;

import java.util.List;

/**
 * <p>
 * 权限管理 服务类
 * </p>
 *
 * @author Zex
 * @since 2020-05-31
 */
public interface ISyPermissionService extends IService<SyPermission> {

    List<SyPermissionTree> tree();


    SyPermission create(SyPermissionReq req);

    SyPermission update(Long id, SyPermissionReq req);

    void delete(Long id);

    List<SyPermission> getByRoleId(Long roleId);
}
