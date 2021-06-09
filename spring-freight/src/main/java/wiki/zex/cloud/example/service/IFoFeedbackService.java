package wiki.zex.cloud.example.service;

import wiki.zex.cloud.example.entity.FoFeedback;
import com.baomidou.mybatisplus.extension.service.IService;
import wiki.zex.cloud.example.enums.FeedbackStatus;
import wiki.zex.cloud.example.req.SmFeedbackParam;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author Zex
 * @since 2020-08-19
 */
public interface IFoFeedbackService extends IService<FoFeedback> {

    void updateStatus(Long id, FeedbackStatus status, Long userId);

    FoFeedback save(SmFeedbackParam param, Long id);
}
