import { axios } from '@/utils/request'

export function token(parameter: any) {
  return axios({
    url: '/oauth/token',
    method: 'post',
    params: parameter
  })
}
