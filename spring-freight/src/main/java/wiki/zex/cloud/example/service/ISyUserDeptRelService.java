package wiki.zex.cloud.example.service;

import wiki.zex.cloud.example.entity.SyUserDeptRel;
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
public interface ISyUserDeptRelService extends IService<SyUserDeptRel> {

    void removeByUserId(Long id);

    void updateByUserId(Long id, List<Long> deptIds);

    List<Long> getDeptIdsByUserId(Long id);

    void removeByDeptId(Long id);
}
