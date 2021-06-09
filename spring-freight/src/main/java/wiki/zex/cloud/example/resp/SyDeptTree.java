package wiki.zex.cloud.example.resp;

import lombok.Data;
import lombok.EqualsAndHashCode;
import wiki.zex.cloud.example.entity.SyDept;

import java.util.List;

@Data
@EqualsAndHashCode(callSuper = true)
public class SyDeptTree extends SyDept implements ITree<SyDeptTree>{
    List<SyDeptTree> children;
}
