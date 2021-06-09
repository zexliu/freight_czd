package wiki.zex.cloud.example.mapper;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.apache.ibatis.annotations.Param;
import wiki.zex.cloud.example.entity.FoCall;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import wiki.zex.cloud.example.resp.FoCallResp;

import java.util.List;

/**
 * <p>
 *  Mapper 接口
 * </p>
 *
 * @author Zex
 * @since 2020-07-14
 */
public interface FoCallMapper extends BaseMapper<FoCall> {

    IPage<FoCallResp> list(Page<FoCallResp> page,@Param("userId") Long userId);

    List<FoCallResp> calls (@Param("deliverId")Long deliverId);

}
