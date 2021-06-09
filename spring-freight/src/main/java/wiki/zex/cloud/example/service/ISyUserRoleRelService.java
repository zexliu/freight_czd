package wiki.zex.cloud.example.service;

import wiki.zex.cloud.example.entity.SyUserRoleRel;
import com.baomidou.mybatisplus.extension.service.IService;

import java.util.List;

/**
 * <p>
 * 用户角色关系表 服务类
 * </p>
 *
 * @author Zex
 * @since 2020-05-28
 */
public interface ISyUserRoleRelService extends IService<SyUserRoleRel> {

    void updateByUserId(Long id, List<Long> roleIds);

    void removeByUserId(Long id);

    List<Long> getRoleIdsByUserId(Long id);

    void removeByRleId(Long id);
}
