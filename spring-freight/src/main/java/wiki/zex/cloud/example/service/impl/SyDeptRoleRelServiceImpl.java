package wiki.zex.cloud.example.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import wiki.zex.cloud.example.entity.SyDeptRoleRel;
import wiki.zex.cloud.example.mapper.SyDeptRoleRelMapper;
import wiki.zex.cloud.example.service.ISyDeptRoleRelService;
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
public class SyDeptRoleRelServiceImpl extends ServiceImpl<SyDeptRoleRelMapper, SyDeptRoleRel> implements ISyDeptRoleRelService {

    @Override
    public void updateByDeptId(Long id, List<Long> roleIds) {
        removeByDeptId(id);
        if (roleIds != null){
            List<SyDeptRoleRel> collect = roleIds.stream().flatMap((Function<Long, Stream<SyDeptRoleRel>>) aLong -> {
                SyDeptRoleRel rel = new SyDeptRoleRel();
                rel.setRoleId(aLong);
                rel.setDeptId(id);
                return Stream.of(rel);
            }).collect(Collectors.toList());
            saveBatch(collect);
        }
    }

    @Override
    public List<Long> getIdsByDeptId(Long id) {
        return baseMapper.getIdsByDeptId(id);
    }

    @Override
    public void removeByDeptId(Long id) {
        remove(new LambdaQueryWrapper<SyDeptRoleRel>()
                .eq(SyDeptRoleRel::getDeptId,id));
    }
}
