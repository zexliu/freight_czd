import { getMenus } from '@/api/user'
import { BasicLayout, BlankLayout, PageView, RouteView } from '@/layouts'
import { CustomRouteConfig } from '@/interfaces/router-interface'
import { bxAnaalyse } from '@/core/icons'

const constantMenuIcons: any = {
  bxAnaalyse: bxAnaalyse
}
// 前端路由表
const constantRouterComponents: any = {
  // 基础页面 layout 必须引入
  BasicLayout: BasicLayout,
  BlankLayout: BlankLayout,
  PageView: PageView,
  RouteView: RouteView,
  '403': () =>
    import(/* webpackChunkName: "error" */ '@/views/exception/403.vue'),
  '404': () =>
    import(/* webpackChunkName: "error" */ '@/views/exception/404.vue'),
  '500': () =>
    import(/* webpackChunkName: "error" */ '@/views/exception/500.vue'),

  // dashboard
  workSpace: () =>
    import(
      /* webpackChunkName: "dashboard" */ '@/views/dashboard/WorkSpace.vue'
    ),
  systemUser: () =>
    import(/* webpackChunkName: "system" */ '@/views/system/user/Index.vue'),
  systemRole: () =>
    import(/* webpackChunkName: "system" */ '@/views/system/role/Index.vue'),
  systemDept: () =>
    import(/* webpackChunkName: "system" */ '@/views/system/dept/Index.vue'),
  systemPermission: () =>
    import(
      /* webpackChunkName: "system" */ '@/views/system/permission/Index.vue'
    ),
  systemMenu: () =>
    import(/* webpackChunkName: "system" */ '@/views/system/menu/Index.vue'),
  systemDict: () =>
    import(/* webpackChunkName: "system" */ '@/views/system/dict/Index.vue'),

  category: () =>
    import(
      /* webpackChunkName: "config" */ '@/views/config/category/Index.vue'
    ),
  announcementTemplate: () =>
    import(
      /* webpackChunkName: "config" */ '@/views/announcement/template/Index.vue'
    ),
  announcement: () =>
    import(
      /* webpackChunkName: "config" */ '@/views/announcement/records/Index.vue'
    ),
  //audit
  masterAuthentication: () =>
    import(/* webpackChunkName: "config" */ '@/views/audit/MasterIndex.vue'),
  driverAuthentication: () =>
    import(/* webpackChunkName: "config" */ '@/views/audit/DriverIndex.vue'),

  //order

  deliveryOrder: () =>
    import(/* webpackChunkName: "order" */ '@/views/order/Delivery.vue'),
  payOrder: () =>
    import(/* webpackChunkName: "order" */ '@/views/order/Pay.vue'),
  // exception
  exception403: () =>
    import(/* webpackChunkName: "fail" */ '@/views/exception/403.vue'),
  exception404: () =>
    import(/* webpackChunkName: "fail" */ '@/views/exception/404.vue'),
  exception500: () =>
    import(/* webpackChunkName: "fail" */ '@/views/exception/500.vue')
}

// 前端未找到页面路由（固定不用改）
const notFoundRouter: CustomRouteConfig = {
  path: '*',
  redirect: '/404',
  hidden: true
}

// 根级菜单
const rootRouter: CustomRouteConfig = {
  key: 'Index',
  name: 'Index',
  path: '/',
  component: BasicLayout,
  redirect: '/dashboard',
  meta: {
    title: '首页'
  },
  children: []
}

/**
 * 动态生成菜单
 * @param token
 * @returns {Promise<Router>}
 */
export const generatorDynamicRouter = () => {
  return new Promise((resolve, reject) => {
    getMenus()
      .then((res: any) => {
        const routers = generator(res)
        rootRouter.children = routers
        const menuNav = []
        menuNav.push(rootRouter)
        menuNav.push(notFoundRouter)
        resolve(menuNav)
      })
      .catch(e => {
        reject(e)
      })

    // loginService
    //   .getCurrentUserNav(token)
    //   .then((res: any) => {
    //     const { result } = res
    //     const menuNav: any[] = []
    //     const childrenNav: any[] = []
    //     //      后端数据, 根级树数组,  根级 PID
    //     listToTree(result, childrenNav, 0)
    //     rootRouter.children = childrenNav
    //     menuNav.push(rootRouter)
    //     console.log('menuNav', menuNav)
    //     const routers = generator(menuNav)
    //     routers.push(notFoundRouter)
    //     console.log('routers', routers)
    //     resolve(routers)
    //   })
    //   .catch((err: any) => {
    //     reject(err)
    //   })
  })
}

export const generator = (routerMap: any[], parent?: any) => {
  return routerMap.map((item: any) => {
    const currentRouter: CustomRouteConfig = {
      path: item.menuPath,
      name: item.menuCode,
      component:
        constantRouterComponents[item.component] ||
        (() => import(`@/views/${item.component}`)),
      hidden: item.hidden ? item.hidden : false,
      meta: {
        title: item.menuName,
        icon: constantMenuIcons[item.menuIcon] || item.menuIcon || null
      }
    }
    if (item.children && item.children.length > 0) {
      currentRouter.children = generator(item.children, currentRouter)
    }
    return currentRouter
  })
}

// /**
//  * 格式化树形结构数据 生成 vue-router 层级路由表
//  *
//  * @param routerMap
//  * @param parent
//  * @returns {*}
//  */
// export const generator = (routerMap: any[], parent?: any) => {
//   return routerMap.map((item: any) => {
//     const {
//       title = '',
//       show = true,
//       hideChildren = false,
//       hiddenHeaderContent = false,
//       target = '',
//       icon = ''
//     } = item.meta || {}
//     const currentRouter: CustomRouteConfig = {
//       // 如果路由设置了 path，则作为默认 path，否则 路由地址 动态拼接生成如 /dashboard/workplace
//       path: item.path || `${(parent && parent.path) || ''}/${item.key}`,
//       // 路由名称，建议唯一
//       name: item.name || item.key || '',
//       // 该路由对应页面的 组件 :方案1
//       // component: constantRouterComponents[item.component || item.key],
//       // 该路由对应页面的 组件 :方案2 (动态加载)
//       component:
//         constantRouterComponents[item.component || item.key] ||
//         (() => import(`@/views/${item.component}`)),

//       // meta: 页面标题, 菜单图标, 页面权限(供指令权限用，可去掉)
//       meta: {
//         title: title,
//         icon: icon || undefined,
//         hiddenHeaderContent: hiddenHeaderContent,
//         target: target,
//         permission: item.name
//       }
//     }
//     // 是否设置了隐藏菜单
//     if (show === false) {
//       currentRouter.hidden = true
//     }
//     // 是否设置了隐藏子菜单
//     if (hideChildren) {
//       currentRouter.hideChildrenInMenu = true
//     }
//     // 为了防止出现后端返回结果不规范，处理有可能出现拼接出两个 反斜杠
//     if (!currentRouter.path.startsWith('http')) {
//       currentRouter.path = currentRouter.path.replace('//', '/')
//     }
//     // 重定向
//     item.redirect && (currentRouter.redirect = item.redirect)
//     // 是否有子菜单，并递归处理
//     if (item.children && item.children.length > 0) {
//       // Recursion
//       currentRouter.children = generator(item.children, currentRouter)
//     }
//     return currentRouter
//   })
// }

// /**
//  * 数组转树形结构
//  * @param list 源数组
//  * @param tree 树
//  * @param parentId 父ID
//  */
// const listToTree = (list: any, tree: any[], parentId: any) => {
//   list.forEach((item: any) => {
//     // 判断是否为父级菜单
//     if (item.parentId === parentId) {
//       const child = {
//         ...item,
//         key: item.key || item.name,
//         children: []
//       }
//       // 迭代 list， 找到当前菜单相符合的所有子菜单
//       listToTree(list, child.children, item.id)
//       // 删掉不存在 children 值的属性
//       if (child.children.length <= 0) {
//         delete child.children
//       }
//       // 加入到树中
//       tree.push(child)
//     }
//   })
// }
