package wiki.zex.cloud.example.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import org.apache.commons.collections.CollectionUtils;
import wiki.zex.cloud.example.entity.SyRolePermissionRel;
import wiki.zex.cloud.example.mapper.SyRolePermissionRelMapper;
import wiki.zex.cloud.example.service.ISyRolePermissionRelService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 * <p>
 * 角色权限关系表 服务实现类
 * </p>
 *
 * @author Zex
 * @since 2020-05-31
 */
@Service
public class SyRolePermissionRelServiceImpl extends ServiceImpl<SyRolePermissionRelMapper, SyRolePermissionRel> implements ISyRolePermissionRelService {

    @Override
    public void updateByRoleId(Long id, List<Long> permissionIds) {
        removeByRoleId(id);
        if (CollectionUtils.isEmpty(permissionIds)){
            return;
        }
        List<SyRolePermissionRel> collect = permissionIds.stream().flatMap((Function<Long, Stream<SyRolePermissionRel>>) aLong -> {
            SyRolePermissionRel rel = new SyRolePermissionRel();
            rel.setPermissionId(aLong);
            rel.setRoleId(id);
            return Stream.of(rel);
        }).collect(Collectors.toList());
        saveBatch(collect);
    }

    @Override
    public void removeByRoleId(Long id) {
        remove(new LambdaQueryWrapper<SyRolePermissionRel>().eq(SyRolePermissionRel::getRoleId,id));
    }

    @Override
    public void removeByPermissionId(Long id) {
        remove(new LambdaQueryWrapper<SyRolePermissionRel>().eq(SyRolePermissionRel::getPermissionId,id));

    }
}
