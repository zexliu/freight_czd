package wiki.zex.cloud.example.mapper;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.apache.ibatis.annotations.Param;
import wiki.zex.cloud.example.entity.FoDriverExtension;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import wiki.zex.cloud.example.enums.AuditStatus;
import wiki.zex.cloud.example.resp.FoDriverExtensionResp;

/**
 * <p>
 *  Mapper 接口
 * </p>
 *
 * @author Zex
 * @since 2020-07-17
 */
public interface FoDriverExtensionMapper extends BaseMapper<FoDriverExtension> {

    IPage<FoDriverExtensionResp> findPage(Page<FoDriverExtensionResp> page,@Param("auditStatus") AuditStatus auditStatus);

}
