package wiki.zex.cloud.example.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import org.apache.commons.collections.CollectionUtils;
import wiki.zex.cloud.example.entity.SyRoleMenuRel;
import wiki.zex.cloud.example.mapper.SyRoleMenuRelMapper;
import wiki.zex.cloud.example.service.ISyRoleMenuRelService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 * <p>
 * 角色菜单关系表 服务实现类
 * </p>
 *
 * @author Zex
 * @since 2020-05-31
 */
@Service
public class SyRoleMenuRelServiceImpl extends ServiceImpl<SyRoleMenuRelMapper, SyRoleMenuRel> implements ISyRoleMenuRelService {

    @Override
    public void removeByMenuId(Long id) {
        remove(new LambdaQueryWrapper<SyRoleMenuRel>().eq(SyRoleMenuRel::getMenuId,id));
    }

    @Override
    public void removeByRleId(Long id) {
        remove(new LambdaQueryWrapper<SyRoleMenuRel>().eq(SyRoleMenuRel::getRoleId,id));
    }

    @Override
    public void updateByRoleId(Long id, List<Long> menuIds) {
        removeByRleId(id);
        if (CollectionUtils.isNotEmpty(menuIds)){
            List<SyRoleMenuRel> collect = menuIds.stream().flatMap((Function<Long, Stream<SyRoleMenuRel>>) aLong -> {
                SyRoleMenuRel rel = new SyRoleMenuRel();
                rel.setMenuId(aLong);
                rel.setRoleId(id);
                return Stream.of(rel);
            }).collect(Collectors.toList());
            saveBatch(collect);
        }
    }
}
