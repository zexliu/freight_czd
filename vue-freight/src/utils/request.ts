import Vue, { VueConstructor } from 'vue'
import axios from 'axios'
import store from '@/store'
import notification from 'ant-design-vue/es/notification'
import VueAxios from './axios'
import { ACCESS_TOKEN, REFRESH_TOKEN } from '@/store/mutation-types'
import { Base64 } from 'js-base64'

// 是否正在刷新的标记
let isRefreshing = false
// 重试队列，每一项将是一个待执行的函数形式
let requests: any[] = []

// 创建 axios 实例
const service = axios.create({
  baseURL: process.env.VUE_APP_API_BASE_URL, // api base_url
  timeout: 6000 // 请求超时时间
})

const err = (error: any) => {
  if (error.response) {
    const data = error.response.data
    const token = Vue.ls.get(REFRESH_TOKEN)
    if (error.response.status === 400) {
      notification.error({
        message: '参数错误',
        description: data.message
      })
    } else if (error.response.status === 403) {
      notification.error({
        message: 'Forbidden',
        description: data.message
      })
    } else if (error.response.status === 401) {
      notification.error({
        message: 'Unauthorized',
        description: 'Authorization verification failed'
      })
      if (token) {
        logout()
      }
    }
    return Promise.reject(data)
  }
  return Promise.reject(error)
}

function logout() {
  store.dispatch('user/Logout').then(() => {
    setTimeout(() => {
      window.location.reload()
    }, 1500)
  })
}

// request interceptor
service.interceptors.request.use((config: any) => {
  if (config.url === '/oauth/token') {
    const clientId = process.env.VUE_APP_API_CLIENT_ID
    const secret = process.env.VUE_APP_API_CLIENT_SECRET
    config.headers['Authorization'] =
      'Basic ' + Base64.encode(clientId + ':' + secret)
  } else {
    const accessToken = Vue.ls.get(ACCESS_TOKEN)
    if (accessToken) {
      config.headers['Authorization'] = 'Bearer ' + accessToken // 让每个请求携带自定义 token 请根据实际情况自行修改
    } else {
      //如果有刷新令牌 先刷新令牌
      const refreshToken = Vue.ls.get(REFRESH_TOKEN)
      if (refreshToken) {
        //判断刷新令牌状态
        if (!isRefreshing) {
          isRefreshing = true //如果不在刷新状态 设置刷新状态为 true
          //调用刷新函数
          return store
            .dispatch('user/RefreshToken', refreshToken)
            .then(res => {
              config.headers['Authorization'] = 'Bearer ' + res.access_token
              // 已经刷新了token，将所有队列中的请求进行重试
              requests.forEach(fc => fc(res.access_token))
              requests = []
              return config
            })
            .catch(e => {
              logout()
            })
            .finally(() => {
              isRefreshing = false
            })
        } else {
          return new Promise(resolve => {
            // 将resolve放进队列，用一个函数形式来保存，等token刷新后直接执行
            requests.push((accessToken: string) => {
              config.headers['Authorization'] = 'Bearer ' + accessToken
              resolve(config)
            })
          })
        }
      }
    }
  }
  return config
}, err)

// response interceptor
service.interceptors.response.use(response => {
  return response.data
}, err)

const installer = {
  vm: {},
  install(Vue: VueConstructor) {
    Vue.use(VueAxios, service)
  }
}

export { installer as VueAxios, service as axios }
