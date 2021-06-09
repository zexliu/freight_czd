package wiki.zex.cloud.example.controller;


import com.baomidou.mybatisplus.core.metadata.IPage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import wiki.zex.cloud.example.entity.FoEvaluation;
import wiki.zex.cloud.example.req.FoEvaluationReq;
import wiki.zex.cloud.example.req.Pageable;
import wiki.zex.cloud.example.resp.EvaluationStatisticalResp;
import wiki.zex.cloud.example.resp.OrderEvaluationResp;
import wiki.zex.cloud.example.security.MyUserDetails;
import wiki.zex.cloud.example.service.IFoEvaluationService;

/**
 * <p>
 *  前端控制器
 * </p>
 *
 * @author Zex
 * @since 2020-08-18
 */
@RestController
@RequestMapping("/api/v1/evaluations")
public class FoEvaluationController {


    @Autowired
    private IFoEvaluationService iFoEvaluationService;
    @GetMapping
    public IPage<FoEvaluation> evaluationPage(Pageable pageable){
        return iFoEvaluationService.page(pageable.convert());
    }

    @GetMapping("/order")
    public IPage<OrderEvaluationResp> orderEvaluationPage(Pageable pageable,Authentication authentication,Integer level){
        return iFoEvaluationService.orderEvaluationPage(pageable.convert(),authentication,level);
    }


    @GetMapping("/statistical")
    public EvaluationStatisticalResp statistical(Authentication authentication){
        return iFoEvaluationService.statistical(authentication);
    }
}
