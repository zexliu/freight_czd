package wiki.zex.cloud.example.mapper;

import org.apache.ibatis.annotations.Param;
import wiki.zex.cloud.example.entity.SyPermission;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;

import java.util.List;

/**
 * <p>
 * 权限管理 Mapper 接口
 * </p>
 *
 * @author Zex
 * @since 2020-05-31
 */
public interface SyPermissionMapper extends BaseMapper<SyPermission> {

    List<SyPermission> getByRoleId(@Param("roleId") Long roleId);
}
