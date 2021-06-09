package wiki.zex.cloud.example.mapper;

import org.apache.ibatis.annotations.Param;
import wiki.zex.cloud.example.entity.SyRole;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import wiki.zex.cloud.example.resp.SyRoleResp;

import java.util.List;

/**
 * <p>
 * 角色表 Mapper 接口
 * </p>
 *
 * @author Zex
 * @since 2020-05-28
 */
public interface SyRoleMapper extends BaseMapper<SyRole> {

    List<SyRoleResp> findRolesByUserId(@Param("userId") Long userId);

    List<String> findRoleCodesByPermissionId(@Param("permissionId") Long permissionId);
}
