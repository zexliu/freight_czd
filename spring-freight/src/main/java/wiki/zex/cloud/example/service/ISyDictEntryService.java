package wiki.zex.cloud.example.service;

import wiki.zex.cloud.example.entity.SyDict;
import wiki.zex.cloud.example.entity.SyDictEntry;
import com.baomidou.mybatisplus.extension.service.IService;
import wiki.zex.cloud.example.req.SyDictEntryReq;

/**
 * <p>
 * 字典项 服务类
 * </p>
 *
 * @author Zex
 * @since 2020-06-02
 */
public interface ISyDictEntryService extends IService<SyDictEntry> {

    void removeByDectId(String dictCode);

    SyDictEntry create(SyDictEntryReq req);

    SyDictEntry update(Long id, SyDictEntryReq req);

    void delete(Long id);

}
