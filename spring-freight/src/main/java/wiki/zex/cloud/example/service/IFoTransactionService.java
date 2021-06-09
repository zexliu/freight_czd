package wiki.zex.cloud.example.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import wiki.zex.cloud.example.entity.FoTransaction;
import com.baomidou.mybatisplus.extension.service.IService;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author Zex
 * @since 2020-08-17
 */
public interface IFoTransactionService extends IService<FoTransaction> {
    IPage<FoTransaction> page(Page<FoTransaction> convert, LocalDateTime startAt, LocalDateTime endAt, Boolean incrStatus, Integer type, Long userId);

    BigDecimal balance(LocalDateTime startAt, LocalDateTime endAt, Boolean incrStatus, Integer type, Long userId);


}
