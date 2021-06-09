package wiki.zex.cloud.example.mapper;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.apache.ibatis.annotations.Param;
import wiki.zex.cloud.example.entity.FoDeliverGoods;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import wiki.zex.cloud.example.entity.FoProtocol;
import wiki.zex.cloud.example.resp.FoDeliverDetails;
import wiki.zex.cloud.example.resp.FoDeliverGoodsResp;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

/**
 * <p>
 * 发货信息 Mapper 接口
 * </p>
 *
 * @author Zex
 * @since 2020-07-08
 */
public interface FoDeliverGoodsMapper extends BaseMapper<FoDeliverGoods> {

    IPage<FoDeliverGoodsResp> queryList(Page<FoDeliverGoods> page,
                                        @Param("userId") Long userId,
                                        @Param("status") Integer status,
                                        @Param("deleteStatus") Integer deleteStatus,
                                        @Param("markStatus") Integer markStatus,
                                        @Param("startAt") LocalDateTime startAt,
                                        @Param("endAt") LocalDateTime endAt,
                                        @Param("loadStartAt") LocalDateTime loadStartAt,
                                        @Param("loadEndAt")LocalDateTime loadEndAt, @Param("loadProvinceCode") String loadProvinceCode,
                                        @Param("loadCityCode") String loadCityCode,
                                        @Param("loadDistrictCode") String loadDistrictCode,
                                        @Param("unloadProvinceCode") String unloadProvinceCode,
                                        @Param("unloadCityCode") String unloadCityCode,
                                        @Param("unloadDistrictCode") String unloadDistrictCode,
                                        @Param("carType") String carType,
                                        @Param("weights") List<Map<String, Integer>> weights,
                                        @Param("carLongs") List<Double> carLongs,
                                        @Param("carModels") List<String> carModels,
                                        @Param("categoryName") List<String> categoryName,
                                        @Param("loadAreas") List<String> loadAreas,
                                        @Param("unloadAreas") List<String> unloadAreas,
                                        @Param("order") String order);

    FoDeliverDetails details(@Param("id") Long id);

    FoProtocol getByOrderId(@Param("orderId") Long orderId);

}
