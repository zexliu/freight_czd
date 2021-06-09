package wiki.zex.cloud.example.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import org.springframework.beans.BeanUtils;
import wiki.zex.cloud.example.entity.SyDict;
import wiki.zex.cloud.example.entity.SyDictEntry;
import wiki.zex.cloud.example.mapper.SyDictEntryMapper;
import wiki.zex.cloud.example.req.SyDictEntryReq;
import wiki.zex.cloud.example.service.ISyDictEntryService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

/**
 * <p>
 * 字典项 服务实现类
 * </p>
 *
 * @author Zex
 * @since 2020-06-02
 */
@Service
public class SyDictEntryServiceImpl extends ServiceImpl<SyDictEntryMapper, SyDictEntry> implements ISyDictEntryService {

    @Override
    public void removeByDectId(String dictCode) {
        remove(new LambdaQueryWrapper<SyDictEntry>().eq(SyDictEntry::getDictCode,dictCode));
    }

    @Override
    public SyDictEntry create(SyDictEntryReq req) {
        SyDictEntry syDictEntry = new SyDictEntry();
        BeanUtils.copyProperties(req,syDictEntry);
        save(syDictEntry);
        return syDictEntry;
    }

    @Override
    public SyDictEntry update(Long id, SyDictEntryReq req) {
        SyDictEntry syDictEntry = new SyDictEntry();
        BeanUtils.copyProperties(req,syDictEntry);
        syDictEntry.setId(id);
        updateById(syDictEntry);
        return syDictEntry;
    }

    @Override
    public void delete(Long id) {
        removeById(id);
    }
}
