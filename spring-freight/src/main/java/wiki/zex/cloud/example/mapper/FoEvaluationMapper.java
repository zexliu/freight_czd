package wiki.zex.cloud.example.mapper;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.apache.ibatis.annotations.Param;
import wiki.zex.cloud.example.entity.FoEvaluation;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import wiki.zex.cloud.example.resp.EvaluationStatisticalResp;
import wiki.zex.cloud.example.resp.OrderEvaluationResp;

/**
 * <p>
 *  Mapper 接口
 * </p>
 *
 * @author Zex
 * @since 2020-08-18
 */
public interface FoEvaluationMapper extends BaseMapper<FoEvaluation> {

    EvaluationStatisticalResp statistical(@Param("userId") Long id, @Param("type") int type);

    IPage<OrderEvaluationResp> orderEvaluationPage(Page<OrderEvaluationResp> convert, @Param("userId") Long userId, @Param("type") int type,@Param("level")  Integer level);

}
