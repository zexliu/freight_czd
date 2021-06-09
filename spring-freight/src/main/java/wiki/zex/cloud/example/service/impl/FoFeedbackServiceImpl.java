package wiki.zex.cloud.example.service.impl;

import org.springframework.beans.BeanUtils;
import wiki.zex.cloud.example.entity.FoFeedback;
import wiki.zex.cloud.example.enums.FeedbackStatus;
import wiki.zex.cloud.example.mapper.FoFeedbackMapper;
import wiki.zex.cloud.example.req.SmFeedbackParam;
import wiki.zex.cloud.example.service.IFoFeedbackService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author Zex
 * @since 2020-08-19
 */
@Service
public class FoFeedbackServiceImpl extends ServiceImpl<FoFeedbackMapper, FoFeedback> implements IFoFeedbackService {

    @Override
    public void updateStatus(Long id, FeedbackStatus status, Long userId) {
        FoFeedback feedback = new FoFeedback();
        feedback.setId(id);
        feedback.setStatus(status);
        updateById(feedback);
    }

    @Override
    public FoFeedback save(SmFeedbackParam param, Long id) {
        FoFeedback feedback = new FoFeedback();
        BeanUtils.copyProperties(param,feedback);
        feedback.setUserId(id);
        feedback.setStatus(FeedbackStatus.PENDING);
        save(feedback);
        return feedback;
    }
}
