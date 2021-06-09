package wiki.zex.cloud.example.service;

import wiki.zex.cloud.example.entity.SyRoleMenuRel;
import com.baomidou.mybatisplus.extension.service.IService;

import java.util.List;

/**
 * <p>
 * 角色菜单关系表 服务类
 * </p>
 *
 * @author Zex
 * @since 2020-05-31
 */
public interface ISyRoleMenuRelService extends IService<SyRoleMenuRel> {

    void removeByMenuId(Long id);


    void removeByRleId(Long id);

    void updateByRoleId(Long id, List<Long> menuIds);

}
