package wiki.zex.cloud.example.service;

import wiki.zex.cloud.example.entity.AppVersion;
import com.baomidou.mybatisplus.extension.service.IService;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author Zex
 * @since 2020-09-11
 */
public interface IAppVersionService extends IService<AppVersion> {

    AppVersion getByVersionCode(Integer versionCode, Integer type,Integer deviceType);
}
