package wiki.zex.cloud.example.utils;

import com.google.common.collect.ArrayListMultimap;
import com.google.common.collect.Lists;
import com.google.common.collect.Multimap;
import org.apache.commons.collections.CollectionUtils;
import wiki.zex.cloud.example.resp.ITree;

import java.util.List;

public class TreeUtils {

    public static <T extends ITree<T>> List<T> listToTree(List<T> list){
        if (CollectionUtils.isEmpty(list)){
            return Lists.newArrayList();
        }else {
            Multimap<Long, T> multimap = ArrayListMultimap.create();
            List<T> rootList = Lists.newArrayList();
            for (T module : list) {
                if (module.getParentId() == null){ //根目录
                    rootList.add(module);
                }else {
                    multimap.put(module.getParentId(),module);
                }
            }
            transformTree(rootList,multimap);
            return rootList;
        }
    }


    private static <T extends ITree<T>> void transformTree(List<T> rootList, Multimap<Long, T> multimap) {
        //便利当前层级
        for (T t : rootList) {
            //获取子列表
            List<T> children = (List<T>) multimap.get(t.getId());
            if (CollectionUtils.isNotEmpty(children)){
                //设置子列表
                t.setChildren(children);
                //进入下一层级处理
                transformTree(children,multimap);
            }
        }
    }
}

