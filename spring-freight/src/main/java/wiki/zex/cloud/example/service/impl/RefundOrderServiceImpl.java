package wiki.zex.cloud.example.service.impl;

import wiki.zex.cloud.example.entity.RefundOrder;
import wiki.zex.cloud.example.mapper.RefundOrderMapper;
import wiki.zex.cloud.example.service.IRefundOrderService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author Zex
 * @since 2020-07-30
 */
@Service
public class RefundOrderServiceImpl extends ServiceImpl<RefundOrderMapper, RefundOrder> implements IRefundOrderService {

}
