package wiki.zex.cloud.example.mapper;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.apache.ibatis.annotations.Param;
import wiki.zex.cloud.example.entity.SyUser;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import wiki.zex.cloud.example.resp.SimpleDriverResp;

/**
 * <p>
 *  Mapper 接口
 * </p>
 *
 * @author Zex
 * @since 2020-05-12
 */
public interface SyUserMapper extends BaseMapper<SyUser> {

    IPage<SyUser> list(Page<SyUser> page,
                       @Param("keywords")String keywords,
                       @Param("username") String username,
                       @Param("mobile") String mobile,
                       @Param("realName") String realName,
                       @Param("workNo") String workNo,
                       @Param("deptId") Long deptId,
                       @Param("roleId") Long roleId,
                       @Param("enable") Boolean enable,
                       @Param("locked") Boolean locked);

    Long count(@Param("roleCode") String roleCode);

    SimpleDriverResp drivers(Page<Object> convert, @Param("mobile") String mobile);

}
