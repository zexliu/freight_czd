package wiki.zex.cloud.example.service;

import wiki.zex.cloud.example.entity.SyDict;
import com.baomidou.mybatisplus.extension.service.IService;
import wiki.zex.cloud.example.req.SyDictReq;
import wiki.zex.cloud.example.resp.SimpleResp;

/**
 * <p>
 * 数据字典 服务类
 * </p>
 *
 * @author Zex
 * @since 2020-06-02
 */
public interface ISyDictService extends IService<SyDict> {

    SyDict create(SyDictReq req);

    SyDict update(Long id, SyDictReq req);

    void delete(Long id);
}
