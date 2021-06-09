package wiki.zex.cloud.example.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import org.apache.commons.collections.CollectionUtils;
import org.springframework.transaction.annotation.Transactional;
import wiki.zex.cloud.example.entity.SyUserRoleRel;
import wiki.zex.cloud.example.mapper.SyUserRoleRelMapper;
import wiki.zex.cloud.example.service.ISyUserRoleRelService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 * <p>
 * 用户角色关系表 服务实现类
 * </p>
 *
 * @author Zex
 * @since 2020-05-28
 */
@Service
public class SyUserRoleRelServiceImpl extends ServiceImpl<SyUserRoleRelMapper, SyUserRoleRel> implements ISyUserRoleRelService {

    @Override
    @Transactional
    public void updateByUserId(Long id, List<Long> roleIds) {
        removeByUserId(id);
        if (CollectionUtils.isEmpty(roleIds)) {
            return;
        }
        List<SyUserRoleRel> collect = roleIds.stream().flatMap((Function<Long, Stream<SyUserRoleRel>>) aLong -> {
            SyUserRoleRel rel = new SyUserRoleRel();
            rel.setRoleId(aLong);
            rel.setUserId(id);
            return Stream.of(rel);
        }).collect(Collectors.toList());
        saveBatch(collect);
    }

    @Override
    public void removeByUserId(Long id) {
        remove(new LambdaQueryWrapper<SyUserRoleRel>().eq(SyUserRoleRel::getUserId, id));
    }

    @Override
    public List<Long> getRoleIdsByUserId(Long id) {

        return baseMapper.getRoleIdsByUserId(id);
    }

    @Override
    public void removeByRleId(Long id) {
        remove(new LambdaQueryWrapper<SyUserRoleRel>().eq(SyUserRoleRel::getRoleId, id));
    }
}
