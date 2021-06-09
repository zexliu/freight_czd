package wiki.zex.cloud.example.mapper;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.apache.ibatis.annotations.Param;
import wiki.zex.cloud.example.entity.FoDeliveryExtension;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import wiki.zex.cloud.example.enums.AuditStatus;
import wiki.zex.cloud.example.resp.FoDeliveryExtensionResp;

/**
 * <p>
 * 用户发货 拓展信息 Mapper 接口
 * </p>
 *
 * @author Zex
 * @since 2020-07-02
 */
public interface FoDeliveryExtensionMapper extends BaseMapper<FoDeliveryExtension> {

    IPage<FoDeliveryExtensionResp> findPage(Page<Object> page, @Param("auditStatus") AuditStatus auditStatus);

}
