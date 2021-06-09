package wiki.zex.cloud.example.service;

import wiki.zex.cloud.example.entity.FoDictRelation;
import com.baomidou.mybatisplus.extension.service.IService;
import wiki.zex.cloud.example.entity.SyDictEntry;

import java.util.List;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author Zex
 * @since 2020-07-04
 */
public interface IFoDictRelationService extends IService<FoDictRelation> {

    List<SyDictEntry> dictEntries(Long id, String dictCode);

    void updateRelation(Long id, String dictCode, List<String> dictEntryValues);

    void removeByRelationId(Long id, String entryCode);
}
