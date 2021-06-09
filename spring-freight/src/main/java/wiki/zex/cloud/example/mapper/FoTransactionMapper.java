package wiki.zex.cloud.example.mapper;

import org.apache.ibatis.annotations.Param;
import wiki.zex.cloud.example.entity.FoTransaction;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * <p>
 *  Mapper 接口
 * </p>
 *
 * @author Zex
 * @since 2020-08-17
 */
public interface FoTransactionMapper extends BaseMapper<FoTransaction> {

    BigDecimal balance(@Param("startAt") LocalDateTime startAt,
                       @Param("endAt") LocalDateTime endAt,
                       @Param("incrStatus") Boolean incrStatus,
                       @Param("type") Integer type,
                       @Param("userId")  Long userId);

}
