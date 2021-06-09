package wiki.zex.cloud.example.controller;


import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import org.apache.commons.lang3.StringUtils;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import wiki.zex.cloud.example.entity.FoAnnouncement;
import wiki.zex.cloud.example.req.FoAnnouncementReq;
import wiki.zex.cloud.example.req.Pageable;
import wiki.zex.cloud.example.resp.SimpleResp;
import wiki.zex.cloud.example.service.IFoAnnouncementService;

import javax.validation.Valid;
import java.time.LocalDateTime;

/**
 * <p>
 *  前端控制器
 * </p>
 *
 * @author Zex
 * @since 2020-08-21
 */
@RestController
@RequestMapping("/api/v1/announcements")
public class FoAnnouncementController {

    @Autowired
    private IFoAnnouncementService iFoAnnouncementService;
    @GetMapping
    public IPage<FoAnnouncement> list(Pageable pageable, Integer announcementType , String keywords, Boolean validStatus, Boolean validTime) {
        return iFoAnnouncementService.page(pageable.convert(),new LambdaQueryWrapper<FoAnnouncement>()
                .eq(announcementType != null, FoAnnouncement::getAnnouncementType,announcementType)
                .eq(validStatus != null,FoAnnouncement::getValidStatus,validStatus)
                .and(validTime != null, i -> i.ge(FoAnnouncement::getValidStartAt, LocalDateTime.now()).or().isNull(FoAnnouncement::getValidStartAt))
                .and(validTime != null, i -> i.le(FoAnnouncement::getValidEndAt, LocalDateTime.now()).or().isNull(FoAnnouncement::getValidEndAt))
                .like(StringUtils.isNotBlank(keywords),FoAnnouncement::getTitle,keywords));
    }

    @GetMapping("/{id}")
    public FoAnnouncement getById( @PathVariable Long id ) {
        return iFoAnnouncementService.getById(id);
    }




    @PostMapping
    public FoAnnouncement create(@RequestBody @Valid FoAnnouncementReq req) {
        return iFoAnnouncementService.create(req);
    }

    @PutMapping("/{id}")
    public FoAnnouncement update( @PathVariable Long id ,@RequestBody @Valid FoAnnouncementReq req) {
        return iFoAnnouncementService.update(id,req);
    }

    @DeleteMapping("/{id}")
    public SimpleResp delete(@PathVariable Long id) {
        iFoAnnouncementService.delete(id);
        return SimpleResp.SUCCESS;
    }



}
