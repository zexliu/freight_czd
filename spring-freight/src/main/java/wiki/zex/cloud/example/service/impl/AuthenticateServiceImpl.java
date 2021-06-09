package wiki.zex.cloud.example.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;
import wiki.zex.cloud.example.constants.SysConstants;
import wiki.zex.cloud.example.entity.FoDeliveryExtension;
import wiki.zex.cloud.example.entity.FoDriverExtension;
import wiki.zex.cloud.example.entity.SyUser;
import wiki.zex.cloud.example.entity.SyUserRoleRel;
import wiki.zex.cloud.example.exception.ParameterException;
import wiki.zex.cloud.example.req.AuthenticateDriverReq;
import wiki.zex.cloud.example.req.AuthenticateOwnerReq;
import wiki.zex.cloud.example.resp.SyRoleResp;
import wiki.zex.cloud.example.security.MyUserDetails;
import wiki.zex.cloud.example.service.*;

import java.util.Optional;
import java.util.function.Consumer;
import java.util.function.Predicate;

@Service
public class AuthenticateServiceImpl implements IAuthenticateService {
    @Autowired
    private ISyUserService iSyUserService;

    @Autowired
    private IFoDeliveryExtensionService iFoDeliveryExtensionService;
    @Autowired
    private IFoDriverExtensionService iFoDriverExtensionService;
    @Autowired
    private ISyUserRoleRelService iSyUserRoleRelService;

    @Override
    public void authOwner(Authentication authentication, AuthenticateOwnerReq req) {
        MyUserDetails userDetails = ((MyUserDetails)authentication.getPrincipal());
        Optional<SyRoleResp> shipper = userDetails.getRoles().stream().filter(syRoleResp -> syRoleResp.getRoleCode().equals("SHIPPER")).findFirst();
        if (shipper.isPresent()){
            throw new ParameterException("货主已认证");
        }
        SyUser syUser = new SyUser();
        syUser.setId(userDetails.getId());
        syUser.setAuthenticationAvatar(req.getAuthenticationAvatar());
        syUser.setNational(req.getNational());
        syUser.setRealName(req.getRealName());
        syUser.setBirthDay(req.getBirthDay());
        syUser.setGender(req.getGenderType());
        syUser.setIdentityCardNo(req.getIdentityCardNo());
        syUser.setIdentityCard(req.getIdentityCard());
        iSyUserService.updateById(syUser);

        SyUserRoleRel userRoleRel = new SyUserRoleRel();
        userRoleRel.setRoleId(SysConstants.SHIPPER_ROLE_ID);
        userRoleRel.setUserId(syUser.getId());
        iSyUserRoleRelService.save(userRoleRel);

        FoDeliveryExtension foDeliveryExtension = new FoDeliveryExtension();
        foDeliveryExtension.setNature(req.getNature());
        foDeliveryExtension.setUserId(syUser.getId());
        iFoDeliveryExtensionService.save(foDeliveryExtension);

    }

    @Override
    public void authDriver(Authentication authentication, AuthenticateDriverReq req) {
        MyUserDetails userDetails = ((MyUserDetails)authentication.getPrincipal());
        Optional<SyRoleResp> driver = userDetails.getRoles().stream().filter(syRoleResp -> syRoleResp.getRoleCode().equals("DRIVER")).findFirst();
        if (driver.isPresent()){
            throw new ParameterException("司机已认证");
        }
        SyUser syUser = new SyUser();
        syUser.setId(userDetails.getId());
        syUser.setAuthenticationAvatar(req.getAuthenticationAvatar());
        syUser.setNational(req.getNational());
        syUser.setRealName(req.getRealName());
        syUser.setBirthDay(req.getBirthDay());
        syUser.setGender(req.getGenderType());
        syUser.setIdentityCardNo(req.getIdentityCardNo());
        syUser.setIdentityCard(req.getIdentityCard());
        iSyUserService.updateById(syUser);

        SyUserRoleRel userRoleRel = new SyUserRoleRel();
        userRoleRel.setRoleId(SysConstants.DRIVER_ROLE_ID);
        userRoleRel.setUserId(syUser.getId());
        iSyUserRoleRelService.save(userRoleRel);

        FoDriverExtension driverExtension = new FoDriverExtension();
        driverExtension.setNature(req.getNature());
        driverExtension.setUserId(syUser.getId());
        driverExtension.setCarLong(req.getCarLong());
        driverExtension.setCarModel(req.getCarModel());
        iFoDriverExtensionService.save(driverExtension);
    }
}
