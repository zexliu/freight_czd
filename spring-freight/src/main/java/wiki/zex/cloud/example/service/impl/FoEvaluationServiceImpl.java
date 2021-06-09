package wiki.zex.cloud.example.service.impl;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.springframework.security.core.Authentication;
import wiki.zex.cloud.example.entity.FoEvaluation;
import wiki.zex.cloud.example.mapper.FoEvaluationMapper;
import wiki.zex.cloud.example.resp.EvaluationStatisticalResp;
import wiki.zex.cloud.example.resp.OrderEvaluationResp;
import wiki.zex.cloud.example.security.MyUserDetails;
import wiki.zex.cloud.example.service.IFoEvaluationService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author Zex
 * @since 2020-08-18
 */
@Service
public class FoEvaluationServiceImpl extends ServiceImpl<FoEvaluationMapper, FoEvaluation> implements IFoEvaluationService {


    @Override
    public EvaluationStatisticalResp statistical(Authentication authentication) {

        MyUserDetails  myUserDetails  = (MyUserDetails) authentication.getPrincipal();
        int type;
        if (myUserDetails.getClientId().equals("master_client")){
            type = 2;
        }else {
            type = 1;
        }
        return baseMapper.statistical(myUserDetails.getId(),type);
    }

    @Override
    public IPage<OrderEvaluationResp> orderEvaluationPage(Page<OrderEvaluationResp> convert, Authentication authentication, Integer level) {
        MyUserDetails myUserDetails = (MyUserDetails) authentication.getPrincipal();
        int type;
        if (myUserDetails.getClientId().equals("master_client")){
            type = 2;
        }else {
            type = 1;
        }
        return baseMapper.orderEvaluationPage(convert,myUserDetails.getId(),type,level);
    }
}
