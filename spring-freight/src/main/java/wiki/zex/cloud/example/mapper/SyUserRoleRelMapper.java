package wiki.zex.cloud.example.mapper;

import org.apache.ibatis.annotations.Param;
import wiki.zex.cloud.example.entity.SyUserRoleRel;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;

import java.util.List;

/**
 * <p>
 * 用户角色关系表 Mapper 接口
 * </p>
 *
 * @author Zex
 * @since 2020-05-28
 */
public interface SyUserRoleRelMapper extends BaseMapper<SyUserRoleRel> {


    List<Long> getRoleIdsByUserId(@Param("userId") Long userId);
}
