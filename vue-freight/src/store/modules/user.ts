import Vue from 'vue'
// import { getInfo, token, logout } from '@/api/oauth'
import { token } from '@/api/oauth'
import { getInfo } from '@/api/user'
import { ACCESS_TOKEN, REFRESH_TOKEN } from '@/store/mutation-types'
import { welcome } from '@/utils/util'
import ls from 'vue-ls'
import {
  MutationTree,
  ActionTree,
  GetterTree,
  ActionContext,
  Module
} from 'vuex'
import { RootState, IUserState } from '@/interfaces/store-interface'

const mutations: MutationTree<IUserState> = {
  SET_ACCESS_TOKEN: (state: IUserState, accessToken) => {
    state.accessToken = accessToken
  },
  SET_REFRESH_TOKEN: (state: IUserState, refreshToken) => {
    state.refreshToken = refreshToken
  },
  SET_NICKNAME: (state: IUserState, { nickname, welcome }) => {
    state.nickname = nickname
    state.welcome = welcome
  },
  SET_AVATAR: (state: IUserState, avatar) => {
    state.avatar = avatar
  },
  SET_ROLES: (state: IUserState, roles) => {
    state.roles = roles
  },
  SET_PERMISSIONS: (state: IUserState, permissions) => {
    state.permissions = permissions
  },
  SET_ID: (state: IUserState, id) => {
    state.id = id
  },
  SET_INFO: (state: IUserState, info) => {
    state.info = info
  }
}

const actions: ActionTree<IUserState, RootState> = {
  Login(context: ActionContext<IUserState, RootState>, loginReq) {
    return new Promise((resolve, reject) => {
      token(loginReq)
        .then((res: any) => {
          Vue.ls.set(ACCESS_TOKEN, res.access_token, res.expires_in * 1000)
          context.commit('SET_ACCESS_TOKEN', res.access_token)
          Vue.ls.set(REFRESH_TOKEN, res.refresh_token, 3600 * 30 * 1000)
          context.commit('SET_REFRESH_TOKEN', res.refresh_token)
          resolve()
        })
        .catch(error => {
          reject(error)
        })
    })
  },

  RefreshToken(
    context: ActionContext<IUserState, RootState>,
    refreshToken: string
  ) {
    return new Promise((resolve, reject) => {
      token({
        grant_type: 'refresh_token',
        refresh_token: refreshToken
      })
        .then((res: any) => {
          Vue.ls.set(ACCESS_TOKEN, res.access_token, res.expires_in * 1000)
          context.commit('SET_ACCESS_TOKEN', res.access_token)
          resolve(res)
        })
        .catch(error => {
          reject(error)
        })
    })
  },
  GetInfo(context) {
    return new Promise((resolve, reject) => {
      getInfo()
        .then((res: any) => {
          console.log(res)
          console.log(res.roles.length)
          if (res.roles.length > 0) {
            const roles = res.roles
            const permissions: any[] = []
            roles.map((role: any) => {
              if (role.permissions && role.permissions.length > 0) {
                permissions.push(role.permissions)
              }
            })
            context.commit('SET_PERMISSIONS', permissions)
            context.commit('SET_ROLES', res.roles)
            context.commit('SET_INFO', res)
          } else {
            reject(new Error('getInfo: roles must be a non-null array !'))
          }
          context.commit('SET_ID', res.id)
          context.commit('SET_NICKNAME', {
            name: res.nickname,
            welcome: welcome()
          })
          context.commit('SET_AVATAR', res.avatar)

          resolve(res)
        })
        .catch((error: any) => {
          reject(error)
        })
    })
  },
  Logout(context) {
    return new Promise(resolve => {
      context.commit('SET_REFRESH_TOKEN', '')
      context.commit('SET_ROLES', [])
      context.commit('SET_PERMISSIONS', [])
      context.commit('SET_INFO', null)
      context.commit('SET_ID', null)
      context.commit('SET_NICKNAME', {})
      context.commit('SET_AVATAR', null)
      context.commit('SET_ACCESS_TOKEN', null)
      context.commit('SET_REFRESH_TOKEN', null)
      Vue.ls.remove(ACCESS_TOKEN)
      Vue.ls.remove(REFRESH_TOKEN)
      resolve()
    })
  }
}

const getters: GetterTree<IUserState, RootState> = {
  accessToken: state => state.accessToken,
  refreshToken: state => state.refreshToken,
  avatar: state => state.avatar,
  nickname: state => state.nickname,
  welcome: state => state.welcome,
  roles: state => state.roles,
  userInfo: state => state.info
}

const userState: IUserState = {
  id: '',
  accessToken: '',
  refreshToken: '',
  nickname: '',
  welcome: '',
  avatar: '',
  roles: [],
  permissions: [],
  info: {}
}

const user: Module<IUserState, RootState> = {
  namespaced: true,
  state: userState,
  getters: getters,
  actions: actions,
  mutations: mutations
}

export default user
