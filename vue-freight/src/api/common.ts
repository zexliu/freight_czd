import { axios } from '@/utils/request'

export function fetchList(url: string, params: any) {
  return axios({
    url: url,
    method: 'get',
    params: params
  })
}

export function create(url: string, data: any) {
  return axios({
    url: url,
    method: 'post',
    data
  })
}

export function update(url: string, id: string, data: any) {
  return axios({
    url: url + '/' + id,
    method: 'put',
    data
  })
}

export function details(url: string, id: string) {
  return axios({
    url: url + '/' + id,
    method: 'get'
  })
}
export function remove(url: string, id: string) {
  return axios({
    url: url + '/' + id,
    method: 'delete'
  })
}
