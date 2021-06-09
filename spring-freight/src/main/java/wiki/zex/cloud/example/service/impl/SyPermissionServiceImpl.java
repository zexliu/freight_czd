package wiki.zex.cloud.example.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import wiki.zex.cloud.example.entity.SyPermission;
import wiki.zex.cloud.example.mapper.SyPermissionMapper;
import wiki.zex.cloud.example.req.SyPermissionReq;
import wiki.zex.cloud.example.resp.SyPermissionTree;
import wiki.zex.cloud.example.service.ISyPermissionService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;
import wiki.zex.cloud.example.service.ISyRolePermissionRelService;
import wiki.zex.cloud.example.utils.TreeUtils;

import java.util.List;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 * <p>
 * 权限管理 服务实现类
 * </p>
 *
 * @author Zex
 * @since 2020-05-31
 */
@Service
public class SyPermissionServiceImpl extends ServiceImpl<SyPermissionMapper, SyPermission> implements ISyPermissionService {


    @Autowired
    private ISyRolePermissionRelService iSyRolePermissionRelService;
    @Override
    public List<SyPermissionTree> tree() {
        List<SyPermission> list = list(new LambdaQueryWrapper<SyPermission>().orderByDesc(SyPermission::getSeq));
        List<SyPermissionTree> collect = list.stream().flatMap((Function<SyPermission, Stream<SyPermissionTree>>) syPermission -> {
            SyPermissionTree tree = new SyPermissionTree();
            BeanUtils.copyProperties(syPermission, tree);
            return Stream.of(tree);
        }).collect(Collectors.toList());
        return TreeUtils.listToTree(collect);
    }

    @Override
    public SyPermission create(SyPermissionReq req) {
        SyPermission syPermission = new SyPermission();
        BeanUtils.copyProperties(req,syPermission);
        save(syPermission);
        return syPermission;
    }

    @Override
    public SyPermission update(Long id, SyPermissionReq req) {
        SyPermission syPermission = new SyPermission();
        BeanUtils.copyProperties(req,syPermission);
        syPermission.setId(id);
        updateById(syPermission);
        return syPermission;
    }

    @Override
    @Transactional
    public void delete(Long id) {
        iSyRolePermissionRelService.removeByPermissionId(id);
        removeById(id);
    }

    @Override
    public List<SyPermission> getByRoleId(Long roleId) {
        return baseMapper.getByRoleId(roleId);
    }
}
