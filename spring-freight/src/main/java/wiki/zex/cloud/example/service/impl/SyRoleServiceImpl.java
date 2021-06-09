package wiki.zex.cloud.example.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import wiki.zex.cloud.example.entity.SyMenu;
import wiki.zex.cloud.example.entity.SyPermission;
import wiki.zex.cloud.example.entity.SyRole;
import wiki.zex.cloud.example.exception.ParameterException;
import wiki.zex.cloud.example.mapper.SyRoleMapper;
import wiki.zex.cloud.example.req.SyRoleReq;
import wiki.zex.cloud.example.resp.SyRoleResp;
import wiki.zex.cloud.example.service.*;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * <p>
 * 角色表 服务实现类
 * </p>
 *
 * @author Zex
 * @since 2020-05-28
 */
@Service
public class SyRoleServiceImpl extends ServiceImpl<SyRoleMapper, SyRole> implements ISyRoleService {

    @Autowired
    private ISyRolePermissionRelService iSyRolePermissionRelService;

    @Autowired
    private ISyUserRoleRelService iSyUserRoleRelService;
    @Autowired
    private ISyPermissionService iSyPermissionService;

    @Autowired
    private ISyMenuService iSyMenuService;

    @Autowired
    private ISyRoleMenuRelService iSyRoleMenuRelService;
    @Override
    public SyRole create(SyRoleReq req) {
        SyRole syRole = new SyRole();
        BeanUtils.copyProperties(req, syRole);
        save(syRole);
        iSyRolePermissionRelService.updateByRoleId(syRole.getId(),req.getPermissionIds());
        iSyRoleMenuRelService.updateByRoleId(syRole.getId(),req.getMenuIds());
        return syRole;
    }

    @Override
    public SyRole update(Long id, SyRoleReq req) {
        SyRole syRole = new SyRole();
        syRole.setId(id);
        BeanUtils.copyProperties(req, syRole);
        updateById(syRole);
        iSyRolePermissionRelService.updateByRoleId(syRole.getId(),req.getPermissionIds());
        iSyRoleMenuRelService.updateByRoleId(syRole.getId(),req.getMenuIds());

        return syRole;
    }

    @Override
    @Transactional
    public void delete(Long id) {
        iSyRolePermissionRelService.removeByRoleId(id);
        iSyUserRoleRelService.removeByRleId(id);
        iSyRoleMenuRelService.removeByRleId(id);
        removeById(id);
    }

    @Override
    public SyRoleResp detailsById(Long id) {
        SyRoleResp resp = new SyRoleResp();
        SyRole syRole = getById(id);
        BeanUtils.copyProperties(syRole,resp);
        List<SyPermission> permissions = iSyPermissionService.getByRoleId(id);
        resp.setPermissions(permissions);
        List<SyMenu>menus = iSyMenuService.getByRoleId(id);
        resp.setMenus(menus);
        return resp;
    }

    @Override
    public List<SyRoleResp> findRolesByUserId(Long id) {
        return baseMapper.findRolesByUserId(id);
    }

    @Override
    public List<String> findRoleCodesByPermissionId(Long id) {
        return baseMapper.findRoleCodesByPermissionId(id);
    }

}
