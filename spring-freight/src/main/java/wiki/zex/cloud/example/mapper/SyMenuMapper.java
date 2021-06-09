package wiki.zex.cloud.example.mapper;

import org.apache.ibatis.annotations.Param;
import wiki.zex.cloud.example.entity.SyMenu;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;

import java.util.List;

/**
 * <p>
 * 菜单管理 Mapper 接口
 * </p>
 *
 * @author Zex
 * @since 2020-05-31
 */
public interface SyMenuMapper extends BaseMapper<SyMenu> {

    List<SyMenu> getListByUserId(@Param("userId") Long userId);

    List<SyMenu> getByRoleId(@Param("roleId") Long roleId);
}
