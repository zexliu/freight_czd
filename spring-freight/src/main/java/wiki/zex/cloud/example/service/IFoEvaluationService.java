package wiki.zex.cloud.example.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.springframework.security.core.Authentication;
import wiki.zex.cloud.example.entity.FoEvaluation;
import com.baomidou.mybatisplus.extension.service.IService;
import wiki.zex.cloud.example.resp.EvaluationStatisticalResp;
import wiki.zex.cloud.example.resp.OrderEvaluationResp;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author Zex
 * @since 2020-08-18
 */
public interface IFoEvaluationService extends IService<FoEvaluation> {


    EvaluationStatisticalResp statistical(Authentication authentication);

    IPage<OrderEvaluationResp> orderEvaluationPage(Page<OrderEvaluationResp> convert, Authentication authentication, Integer level);
}
