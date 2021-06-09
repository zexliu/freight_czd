package wiki.zex.cloud.example.service;

import wiki.zex.cloud.example.enums.OrderType;
import wiki.zex.cloud.example.entity.FoOrder;
import wiki.zex.cloud.example.entity.FoOrderProcess;
import com.baomidou.mybatisplus.extension.service.IService;
import wiki.zex.cloud.example.enums.UserType;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author Zex
 * @since 2020-07-29
 */
public interface IFoOrderProcessService extends IService<FoOrderProcess> {


    void createProcess(Long id, FoOrder snapshot, Long userId, UserType userType, OrderType systemCancelOrder, String description);
}
