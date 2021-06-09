package wiki.zex.cloud.example.service;

import wiki.zex.cloud.example.entity.SyDept;
import com.baomidou.mybatisplus.extension.service.IService;
import wiki.zex.cloud.example.req.SyDeptReq;
import wiki.zex.cloud.example.resp.SyDeptDetails;
import wiki.zex.cloud.example.resp.SyDeptTree;

import java.util.List;

/**
 * <p>
 * 部门表 服务类
 * </p>
 *
 * @author Zex
 * @since 2020-05-29
 */
public interface ISyDeptService extends IService<SyDept> {

    SyDept create(SyDeptReq req);

    SyDept update(Long id, SyDeptReq req);

    List<SyDeptTree> tree();

    SyDeptDetails detailsById(Long id);

    void delete(Long id);
}
