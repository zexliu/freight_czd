package wiki.zex.cloud.example.service;

import wiki.zex.cloud.example.entity.SyDeptRoleRel;
import com.baomidou.mybatisplus.extension.service.IService;

import java.util.List;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author Zex
 * @since 2020-05-29
 */
public interface ISyDeptRoleRelService extends IService<SyDeptRoleRel> {

    void updateByDeptId(Long id, List<Long> roleIds);

    List<Long> getIdsByDeptId(Long id);

    void removeByDeptId(Long id);
}
