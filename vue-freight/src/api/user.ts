import { axios } from '@/utils/request'

export function getInfo() {
  return axios({
    url: '/api/v1/users/self',
    method: 'get'
  })
}

export function password(id: string, params: any) {
  return axios({
    url: 'api/v1/users/' + id + '/password',
    method: 'post',
    params: params
  })
}

export function getMenus() {
  return axios({
    url: '/api/v1/menus/tree/self',
    method: 'get'
  })
}
