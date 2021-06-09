import { axios } from '@/utils/request'

export function downloadExcel(params: any) {
  return axios({
    url: 'api/v1/excel/download',
    method: 'get',
    responseType: 'blob',
    params: params
  })
}

export function uploadExcel(params: any, data: any) {
  return axios({
    url: 'api/v1/excel/upload',
    method: 'post',
    responseType: 'blob',
    data: data,
    params: params
  })
}
