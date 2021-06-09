package wiki.zex.cloud.example.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import org.apache.commons.collections.CollectionUtils;
import org.springframework.transaction.annotation.Transactional;
import wiki.zex.cloud.example.entity.SyUserDeptRel;
import wiki.zex.cloud.example.entity.SyUserRoleRel;
import wiki.zex.cloud.example.mapper.SyUserDeptRelMapper;
import wiki.zex.cloud.example.service.ISyUserDeptRelService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author Zex
 * @since 2020-05-29
 */
@Service
public class SyUserDeptRelServiceImpl extends ServiceImpl<SyUserDeptRelMapper, SyUserDeptRel> implements ISyUserDeptRelService {

    @Override
    public void removeByUserId(Long id) {
        remove(new LambdaQueryWrapper<SyUserDeptRel>().eq(SyUserDeptRel::getUserId,id));
    }

    @Override
    @Transactional
    public void updateByUserId(Long id, List<Long> deptIds) {
        removeByUserId(id);
        if (CollectionUtils.isEmpty(deptIds)) {
            return;
        }
        List<SyUserDeptRel> collect = deptIds.stream().flatMap((Function<Long, Stream<SyUserDeptRel>>) aLong -> {
            SyUserDeptRel rel = new SyUserDeptRel();
            rel.setDeptId(aLong);
            rel.setUserId(id);
            return Stream.of(rel);
        }).collect(Collectors.toList());
        saveBatch(collect);
    }

    @Override
    public List<Long> getDeptIdsByUserId(Long id) {
        return baseMapper.getDeptIdsByUserId(id);
    }

    @Override
    public void removeByDeptId(Long id) {
        remove(new LambdaQueryWrapper<SyUserDeptRel>().eq(SyUserDeptRel::getDeptId,id));

    }
}
