package wiki.zex.cloud.example.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import wiki.zex.cloud.example.entity.FoTransaction;
import wiki.zex.cloud.example.mapper.FoTransactionMapper;
import wiki.zex.cloud.example.service.IFoTransactionService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author Zex
 * @since 2020-08-17
 */
@Service
public class FoTransactionServiceImpl extends ServiceImpl<FoTransactionMapper, FoTransaction> implements IFoTransactionService {

    @Override
    public IPage<FoTransaction> page(Page<FoTransaction> convert, LocalDateTime startAt, LocalDateTime endAt, Boolean incrStatus, Integer type, Long userId) {
        return page(convert, new LambdaQueryWrapper<FoTransaction>()
                .ge(startAt != null, FoTransaction::getCreateAt, startAt)
                .ge(userId != null, FoTransaction::getUserId, userId)
                .le(endAt != null, FoTransaction::getCreateAt, endAt)
                .eq(incrStatus != null, FoTransaction::getIncrStatus, incrStatus)
                .eq(type != null, FoTransaction::getType, type));
    }

    @Override
    public BigDecimal balance(LocalDateTime startAt, LocalDateTime endAt, Boolean incrStatus, Integer type, Long userId) {
        return baseMapper.balance(startAt,endAt,incrStatus,type,userId);
    }
}
