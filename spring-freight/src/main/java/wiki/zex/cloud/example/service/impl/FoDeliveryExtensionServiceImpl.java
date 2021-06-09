package wiki.zex.cloud.example.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import wiki.zex.cloud.example.async.DeliveryGoodsAsyncTask;
import wiki.zex.cloud.example.constants.SysConstants;
import wiki.zex.cloud.example.entity.AmAuditHistory;
import wiki.zex.cloud.example.entity.FoDeliveryExtension;
import wiki.zex.cloud.example.entity.SyUser;
import wiki.zex.cloud.example.entity.SyUserRoleRel;
import wiki.zex.cloud.example.enums.AuditStatus;
import wiki.zex.cloud.example.enums.AuditTargetType;
import wiki.zex.cloud.example.exception.ForbiddenException;
import wiki.zex.cloud.example.exception.ServerException;
import wiki.zex.cloud.example.mapper.FoDeliveryExtensionMapper;
import wiki.zex.cloud.example.req.FoDeliveryExtensionReq;
import wiki.zex.cloud.example.resp.AuditAuthenticationPush;
import wiki.zex.cloud.example.resp.FoDeliveryExtensionResp;
import wiki.zex.cloud.example.resp.SyRoleResp;
import wiki.zex.cloud.example.security.MyUserDetails;
import wiki.zex.cloud.example.service.*;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

/**
 * <p>
 * 用户发货 拓展信息 服务实现类
 * </p>
 *
 * @author Zex
 * @since 2020-07-02
 */
@Service("iFoDeliveryExtensionService")
public class FoDeliveryExtensionServiceImpl extends ServiceImpl<FoDeliveryExtensionMapper, FoDeliveryExtension> implements IFoDeliveryExtensionService, AuditProcessor {

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private ISyRoleService iSyRoleService;

    @Autowired
    private ISyUserService iSyUserService;

    @Autowired
    private ISyUserRoleRelService iSyUserRoleRelService;

    @Autowired
    private IAmAuditHistoryService iAmAuditHistoryService;


    @Override
    public AuditAuthenticationPush auditProcess(Long id, AuditStatus auditStatus) {
        FoDeliveryExtension extension = getById(id);
        if (extension.getAuditStatus() != AuditStatus.PENDING) {
            throw new ForbiddenException("该条记录不在待审核状态");
        }
        if (auditStatus == AuditStatus.PASSED) {
            List<SyRoleResp> roles = iSyRoleService.findRolesByUserId(extension.getUserId());
            Optional<SyRoleResp> shipper = roles.stream().filter(syRoleResp -> syRoleResp.getRoleCode().equals("SHIPPER")).findFirst();
            if (!shipper.isPresent()) {
                SyUserRoleRel userRoleRel = new SyUserRoleRel();
                userRoleRel.setRoleId(SysConstants.SHIPPER_ROLE_ID);
                userRoleRel.setUserId(extension.getUserId());
                iSyUserRoleRelService.save(userRoleRel);
            }
            SyUser syUser = new SyUser();
            syUser.setId(extension.getUserId());
            syUser.setAvatar(extension.getAvatar());
            syUser.setNickname(extension.getRealName());
            syUser.setRealName(extension.getRealName());
            iSyUserService.updateById(syUser);


        }

        extension.setAuditStatus(auditStatus);
        updateById(extension);


        try {
            String body = objectMapper.writeValueAsString(extension);
            AuditAuthenticationPush push = new AuditAuthenticationPush();
            push.setUser(true);
            push.setUserId(extension.getUserId());
            push.setBody(body);
            return push;
        } catch (JsonProcessingException e) {
            throw new ServerException();
        }
    }

    @Override
    public FoDeliveryExtension create(FoDeliveryExtensionReq req, Authentication authentication) {
        MyUserDetails myUserDetails = (MyUserDetails) authentication.getPrincipal();
        FoDeliveryExtension extension = getOne(new LambdaQueryWrapper<FoDeliveryExtension>().eq(FoDeliveryExtension::getUserId, myUserDetails.getId()));
        if (extension != null) {
            throw new ForbiddenException("已经有过申请记录了");
        }
        extension = new FoDeliveryExtension();
        extension.setAuditStatus(AuditStatus.PENDING);
        extension.setUserId(myUserDetails.getId());
        BeanUtils.copyProperties(req, extension);
        save(extension);
        return extension;
    }

    @Override
    public FoDeliveryExtension update(Long id, FoDeliveryExtensionReq req, Authentication authentication) {
        MyUserDetails myUserDetails = (MyUserDetails) authentication.getPrincipal();
        FoDeliveryExtension extension = getOne(new LambdaQueryWrapper<FoDeliveryExtension>().eq(FoDeliveryExtension::getUserId, myUserDetails.getId()));
        if (extension == null || extension.getAuditStatus() == AuditStatus.PENDING) {
            throw new ForbiddenException("正在审核中...,请等待");
        }
//        if (extension.getAuditStatus() == AuditStatus.PASSED) {
//            throw new ForbiddenException("该申请已通过...");
//        }

        SyUser syUser = new SyUser();
        syUser.setId(extension.getUserId());
        syUser.setAvatar(extension.getAvatar());
        syUser.setNickname(extension.getRealName());
        syUser.setRealName(extension.getRealName());
        iSyUserService.updateById(syUser);


        extension.setAuditStatus(AuditStatus.PENDING);
        BeanUtils.copyProperties(req, extension);
        updateById(extension);

        return extension;
    }

    @Override
    public FoDeliveryExtensionResp get(Authentication authentication) {
        MyUserDetails myUserDetails = (MyUserDetails) authentication.getPrincipal();
        FoDeliveryExtension extension = getOne(new LambdaQueryWrapper<FoDeliveryExtension>().eq(FoDeliveryExtension::getUserId, myUserDetails.getId()));
        if (extension == null) {
            return null;
        }
        List<AmAuditHistory> histories = iAmAuditHistoryService.list(new LambdaQueryWrapper<AmAuditHistory>().eq(AmAuditHistory::getTargetType, AuditTargetType.USER_AUTHENTICATION).eq(AmAuditHistory::getTargetId, extension.getId()).orderByDesc(AmAuditHistory::getCreateAt));
        FoDeliveryExtensionResp resp = new FoDeliveryExtensionResp();
        BeanUtils.copyProperties(extension, resp);
        resp.setHistories(histories);
        return resp;
    }

    @Override
    public IPage<FoDeliveryExtensionResp> findPage(Page<Object> page, AuditStatus auditStatus) {
        return baseMapper.findPage(page, auditStatus);
    }
}
