package wiki.zex.cloud.example.service.impl;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import wiki.zex.cloud.example.enums.OrderType;
import wiki.zex.cloud.example.entity.FoOrder;
import wiki.zex.cloud.example.entity.FoOrderProcess;
import wiki.zex.cloud.example.enums.UserType;
import wiki.zex.cloud.example.mapper.FoOrderProcessMapper;
import wiki.zex.cloud.example.service.IFoOrderProcessService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

/**
 * <p>
 * 服务实现类
 * </p>
 *
 * @author Zex
 * @since 2020-07-29
 */
@Service
public class FoOrderProcessServiceImpl extends ServiceImpl<FoOrderProcessMapper, FoOrderProcess> implements IFoOrderProcessService {

    @Autowired
    private ObjectMapper objectMapper;


    @Override
    public void createProcess(Long id, FoOrder snapshot, Long userId, UserType userType, OrderType orderType, String description) {
        FoOrderProcess process = new FoOrderProcess();
        process.setOrderId(id);
        process.setType(orderType);
        String snapStr = "";
        try {
            snapStr = objectMapper.writeValueAsString(snapshot);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }
        process.setUserType(userType);
        process.setSnapshot(snapStr);
        process.setUserId(userId);
        process.setCreateAt(LocalDateTime.now());

        process.setDescription(StringUtils.isBlank(description) ? orderType.getDescription() : description);
        save(process);
    }
}
