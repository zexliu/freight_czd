package wiki.zex.cloud.example.resp;

import lombok.Data;
import lombok.EqualsAndHashCode;
import wiki.zex.cloud.example.entity.SyMenu;

import java.util.List;

@Data
@EqualsAndHashCode(callSuper = true)
public class SyMenuTree extends SyMenu implements ITree<SyMenuTree>{
    private List<SyMenuTree> children;

}
