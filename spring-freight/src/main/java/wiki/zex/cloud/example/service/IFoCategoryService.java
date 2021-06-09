package wiki.zex.cloud.example.service;

import wiki.zex.cloud.example.entity.FoCategory;
import com.baomidou.mybatisplus.extension.service.IService;
import wiki.zex.cloud.example.req.FoCategoryReq;
import wiki.zex.cloud.example.resp.FoCategoryDetails;
import wiki.zex.cloud.example.resp.FoCategoryTree;

import java.util.List;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author Zex
 * @since 2020-07-04
 */
public interface IFoCategoryService extends IService<FoCategory> {

    void delete(Long id);

    FoCategory update(Long id, FoCategoryReq req);

    FoCategory create(FoCategoryReq req);

    List<FoCategoryTree> tree(String categoryCode);


    FoCategoryDetails getDetailsById(Long id);

    FoCategoryDetails getByName(String categoryName);
}
