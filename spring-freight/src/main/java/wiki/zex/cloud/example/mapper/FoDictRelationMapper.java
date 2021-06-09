package wiki.zex.cloud.example.mapper;

import org.apache.ibatis.annotations.Param;
import wiki.zex.cloud.example.entity.FoDictRelation;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import wiki.zex.cloud.example.entity.SyDictEntry;

import java.util.List;

/**
 * <p>
 *  Mapper 接口
 * </p>
 *
 * @author Zex
 * @since 2020-07-04
 */
public interface FoDictRelationMapper extends BaseMapper<FoDictRelation> {

    List<SyDictEntry> dictEntries(@Param("relationId") Long id,@Param("entryCode") String entryCode);


}
