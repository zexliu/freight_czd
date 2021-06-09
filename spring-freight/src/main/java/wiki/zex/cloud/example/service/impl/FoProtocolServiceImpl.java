package wiki.zex.cloud.example.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.transaction.annotation.Transactional;
import wiki.zex.cloud.example.async.DeliveryGoodsAsyncTask;
import wiki.zex.cloud.example.entity.FoOrder;
import wiki.zex.cloud.example.entity.FoProtocol;
import wiki.zex.cloud.example.enums.UserType;
import wiki.zex.cloud.example.exception.ForbiddenException;
import wiki.zex.cloud.example.exception.NotFoundException;
import wiki.zex.cloud.example.exception.ParameterException;
import wiki.zex.cloud.example.mapper.FoProtocolMapper;
import wiki.zex.cloud.example.req.FoProtocolReq;
import wiki.zex.cloud.example.security.MyUserDetails;
import wiki.zex.cloud.example.service.IFoOrderProcessService;
import wiki.zex.cloud.example.service.IFoOrderService;
import wiki.zex.cloud.example.service.IFoProtocolService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

import static wiki.zex.cloud.example.enums.OrderType.PROTOCOL_AGREE;
import static wiki.zex.cloud.example.enums.OrderType.PROTOCOL_CREATE;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author Zex
 * @since 2020-07-30
 */
@Service
public class FoProtocolServiceImpl extends ServiceImpl<FoProtocolMapper, FoProtocol> implements IFoProtocolService {

    @Autowired
    private DeliveryGoodsAsyncTask deliveryGoodsAsyncTask;

    @Autowired
    private IFoOrderService iFoOrderService;

    @Autowired
    private IFoOrderProcessService iFoOrderProcessService;
    @Override
    @Transactional
    public FoProtocol create(FoProtocolReq req, Authentication authentication) {
        MyUserDetails myUserDetails = (MyUserDetails) authentication.getPrincipal();

        FoOrder foOrder = iFoOrderService.getById(req.getOrderId());
        if (foOrder == null){
            throw new NotFoundException();
        }
        if (myUserDetails.getClientId().equals("master_client") && !foOrder.getUserId().equals(myUserDetails.getId())){
            throw new ForbiddenException();
        }
        if (myUserDetails.getClientId().equals("driver_client") && !foOrder.getDriverId().equals(myUserDetails.getId())){
            throw  new ForbiddenException();
        }

        FoProtocol foProtocol = getByOrderId(req.getOrderId());
        if (foProtocol != null){
            throw new ParameterException("协议已存在");
        }
        foProtocol = new FoProtocol();
        BeanUtils.copyProperties(req,foProtocol);
        if (myUserDetails.getClientId().equals("master_client") ){
            foProtocol.setUserAgree(true);
        }
        if (myUserDetails.getClientId().equals("driver_client")){
            foProtocol.setDriverAgree(true);
        }

        save(foProtocol);
        foOrder.setProtocolStatus(myUserDetails.getClientId().equals("master_client")  ? 2 : 3);
        iFoOrderService.updateById(foOrder);
        deliveryGoodsAsyncTask.pushProtocolToClient(foOrder,myUserDetails);
        iFoOrderProcessService.createProcess(foProtocol.getOrderId(),foOrder,myUserDetails.getId(),myUserDetails.getClientId().equals("master_client") ? UserType.USER : UserType.DRIVER,PROTOCOL_CREATE, null);
        return foProtocol;
    }

    @Override
    @Transactional
    public void agree(Long id, Authentication authentication) {
        FoProtocol protocol = getById(id);
        if (protocol == null){
            throw new NotFoundException("protocol not found");
        }
        FoOrder order = iFoOrderService.getById(protocol.getOrderId());
        if (order == null){
            throw new NotFoundException("order not found");
        }
        MyUserDetails myUserDetails = (MyUserDetails) authentication.getPrincipal();
        if (myUserDetails.getClientId().equals("master_client")){
            if (!order.getUserId().equals(myUserDetails.getId())){
                throw new ForbiddenException();
            }
            protocol.setUserAgree(true);
        }else {
            if (!order.getDriverId().equals(myUserDetails.getId())){
                throw new ForbiddenException();
            }
            protocol.setDriverAgree(true);
        }
        order.setProtocolStatus(1);
        updateById(protocol);
        iFoOrderService.updateById(order);
        iFoOrderProcessService.createProcess(protocol.getOrderId(),order,myUserDetails.getId(),myUserDetails.getClientId().equals("master_client") ? UserType.USER : UserType.DRIVER,PROTOCOL_AGREE, null);
        deliveryGoodsAsyncTask.pushProtocolAgreeToClient(order,myUserDetails);
    }



    private FoProtocol getByOrderId(Long orderId) {
        return  getOne(new LambdaQueryWrapper<FoProtocol>().eq(FoProtocol::getOrderId,orderId));
    }
}
