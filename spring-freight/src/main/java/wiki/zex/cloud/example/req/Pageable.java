package wiki.zex.cloud.example.req;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

@ApiModel("分页相关")
@Data
public class Pageable {
    @ApiModelProperty("分页数量")
    Integer size = 10;
    @ApiModelProperty("第几页")
    Integer current = 1;
    @ApiModelProperty("是否查询数量")
    Boolean isSearchCount = true;

    public Pageable(Integer size, Integer current, Boolean isSearchCount) {
        if (current != null && current > 1) {
            this.current = current;
        }
        if (size != null && size > 1) {
            this.size = size;
        }
        if (isSearchCount != null){
            this.isSearchCount = isSearchCount;
        }
    }

    public <T> Page<T> convert() {
        return new Page<>(this.current, this.size, this.isSearchCount);
    }

}
