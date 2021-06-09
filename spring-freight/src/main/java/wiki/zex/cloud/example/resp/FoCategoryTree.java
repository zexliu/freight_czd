package wiki.zex.cloud.example.resp;

import lombok.Data;
import lombok.EqualsAndHashCode;
import wiki.zex.cloud.example.entity.FoCategory;

import java.util.List;

@EqualsAndHashCode(callSuper = true)
@Data
public class FoCategoryTree  extends FoCategory implements ITree<FoCategoryTree>{
    List<FoCategoryTree> children;
}
