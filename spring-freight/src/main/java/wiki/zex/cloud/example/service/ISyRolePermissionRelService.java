package wiki.zex.cloud.example.service;

import wiki.zex.cloud.example.entity.SyRolePermissionRel;
import com.baomidou.mybatisplus.extension.service.IService;

import java.util.List;

/**
 * <p>
 * 角色权限关系表 服务类
 * </p>
 *
 * @author Zex
 * @since 2020-05-31
 */
public interface ISyRolePermissionRelService extends IService<SyRolePermissionRel> {

    void updateByRoleId(Long id, List<Long> permissionIds);

    void removeByRoleId(Long id);

    void removeByPermissionId(Long id);
}
