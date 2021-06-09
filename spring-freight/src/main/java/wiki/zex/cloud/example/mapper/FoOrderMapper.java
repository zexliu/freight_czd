package wiki.zex.cloud.example.mapper;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.apache.ibatis.annotations.Param;
import wiki.zex.cloud.example.entity.FoOrder;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import wiki.zex.cloud.example.resp.OrderDetails;
import wiki.zex.cloud.example.resp.OrderResp;
import wiki.zex.cloud.example.resp.SimpleDriverResp;

import java.time.LocalDateTime;

/**
 * <p>
 *  Mapper 接口
 * </p>
 *
 * @author Zex
 * @since 2020-07-17
 */
public interface FoOrderMapper extends BaseMapper<FoOrder> {

    IPage<SimpleDriverResp> orderedDrivers(Page<Object> paga, @Param("userId") Long userId);

    IPage<OrderResp> list(Page<OrderResp> page, @Param("deliveryId") Long deliveryId,
                          @Param("userId") Long userId,
                          @Param("driverId") Long driverId,
                          @Param("confirmStatus") Boolean confirmStatus,
                          @Param("transportStatus") Boolean transportStatus,
                          @Param("payStatus") Boolean payStatus,
                          @Param("evaluateStatus") Boolean evaluateStatus,
                          @Param("driverEvaluateStatus") Boolean driverEvaluateStatus,
                          @Param("cancelStatus") Boolean cancelStatus,
                          @Param("refundStatus") Boolean refundStatus,
                          @Param("driverPayStatus") Boolean driverPayStatus,
                          @Param("protocolStatus") Boolean protocolStatus,
                          @Param("startAt") LocalDateTime startAt,
                          @Param("endAt") LocalDateTime endAt);

    OrderDetails details(@Param("id") Long id);

}
