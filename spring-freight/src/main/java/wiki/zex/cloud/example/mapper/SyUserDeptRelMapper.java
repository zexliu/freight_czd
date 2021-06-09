package wiki.zex.cloud.example.mapper;

import org.apache.ibatis.annotations.Param;
import wiki.zex.cloud.example.entity.SyUserDeptRel;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;

import java.util.List;

/**
 * <p>
 *  Mapper 接口
 * </p>
 *
 * @author Zex
 * @since 2020-05-29
 */
public interface SyUserDeptRelMapper extends BaseMapper<SyUserDeptRel> {

    List<Long> getDeptIdsByUserId(@Param("userId") Long userId);
}
