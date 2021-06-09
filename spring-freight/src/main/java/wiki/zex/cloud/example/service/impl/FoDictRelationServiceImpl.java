package wiki.zex.cloud.example.service.impl;

import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import org.apache.commons.collections4.CollectionUtils;
import org.springframework.transaction.annotation.Transactional;
import wiki.zex.cloud.example.entity.FoDictRelation;
import wiki.zex.cloud.example.entity.SyDictEntry;
import wiki.zex.cloud.example.mapper.FoDictRelationMapper;
import wiki.zex.cloud.example.service.IFoDictRelationService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

/**
 * <p>
 * 服务实现类
 * </p>
 *
 * @author Zex
 * @since 2020-07-04
 */
@Service
public class FoDictRelationServiceImpl extends ServiceImpl<FoDictRelationMapper, FoDictRelation> implements IFoDictRelationService {

    @Override
    public List<SyDictEntry> dictEntries(Long id, String dictCode) {
        return baseMapper.dictEntries(id, dictCode);
    }

    @Override
    @Transactional
    public void updateRelation(Long id, String dictCode, List<String> dictEntryValues) {
        removeByRelationId(id, dictCode);
        if (CollectionUtils.isNotEmpty(dictEntryValues)){
            List<FoDictRelation> collect = dictEntryValues.stream().map(s -> {
                FoDictRelation relation = new FoDictRelation();
                relation.setRelationId(id);
                relation.setDictCode(dictCode);
                relation.setDictEntryValue(s);
                return relation;
            }).collect(Collectors.toList());

            saveBatch(collect);
        }
    }

    @Override
    public void removeByRelationId(Long id, String entryCode) {
        remove(new LambdaUpdateWrapper<FoDictRelation>().eq(FoDictRelation::getRelationId, id)
                .eq(FoDictRelation::getDictCode, entryCode));
    }
}
