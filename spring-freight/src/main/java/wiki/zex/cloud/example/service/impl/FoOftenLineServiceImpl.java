package wiki.zex.cloud.example.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.springframework.beans.BeanUtils;
import org.springframework.security.core.Authentication;
import wiki.zex.cloud.example.entity.FoOftenLine;
import wiki.zex.cloud.example.mapper.FoOftenLineMapper;
import wiki.zex.cloud.example.req.FoOftenLineReq;
import wiki.zex.cloud.example.security.MyUserDetails;
import wiki.zex.cloud.example.service.IFoOftenLineService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;
import wiki.zex.cloud.example.socket.WebSocketServer;

import java.util.List;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author Zex
 * @since 2020-07-12
 */
@Service
public class FoOftenLineServiceImpl extends ServiceImpl<FoOftenLineMapper, FoOftenLine> implements IFoOftenLineService {


    @Override
    public IPage<FoOftenLine> page(Page<FoOftenLine> page, Authentication authentication) {
        MyUserDetails myUserDetails = (MyUserDetails) authentication.getPrincipal();
        return page(page,new LambdaQueryWrapper<FoOftenLine>().eq(FoOftenLine::getUserId,myUserDetails.getId()));
    }

    @Override
    public FoOftenLine create(FoOftenLineReq req, Authentication authentication) {
        MyUserDetails myUserDetails = (MyUserDetails) authentication.getPrincipal();
        FoOftenLine oftenLine = new FoOftenLine();
        BeanUtils.copyProperties(req,oftenLine);
        oftenLine.setUserId(myUserDetails.getId());
        oftenLine.setStatus(WebSocketServer.isConnect(myUserDetails.getId()));
        save(oftenLine);
        return oftenLine;
    }

    @Override
    public FoOftenLine update(Long id, FoOftenLineReq req, Authentication authentication) {
        MyUserDetails myUserDetails = (MyUserDetails) authentication.getPrincipal();
        FoOftenLine oftenLine = new FoOftenLine();
        BeanUtils.copyProperties(req,oftenLine);
        oftenLine.setId(id);
        oftenLine.setUserId(myUserDetails.getId());
        updateById(oftenLine);
        return oftenLine;
    }

    @Override
    public void updateStatus(Long clientId, boolean b) {
        update(new LambdaUpdateWrapper<FoOftenLine>().set(FoOftenLine::getStatus,b).eq(FoOftenLine::getUserId,clientId));
    }

    @Override
    public List<FoOftenLine> findByStatus(boolean b) {
        return list(new LambdaQueryWrapper<FoOftenLine>().eq(FoOftenLine::getStatus,b));
    }
}
