import { axios } from '@/utils/request'

export function upload(data: any) {
  return axios({
    url: '/api/v1/upload',
    method: 'post',
    data: data
  })
}
