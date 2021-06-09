import Vue from 'vue'
import moment from 'moment'
import 'moment/locale/zh-cn'
moment.locale('zh-cn')

Vue.filter('moment', function(dataStr: any, pattern = 'x') {
  return moment(dataStr).format(pattern)
})

export function timeFormatter(timestamp: string) {
  if (timestamp) {
    var date = new Date(timestamp)
    const year = date.getFullYear()
    const month = date.getMonth() + 1
    const day = date.getDate()
    const hour = date.getHours()
    const minute = date.getMinutes()
    const second = date.getSeconds()
    return (
      [year, month, day].map(formatNumber).join('-') +
      ' ' +
      [hour, minute, second].map(formatNumber).join(':')
    )
    // return [year, month, day].map(formatNumber).join('-')
  } else {
    return ''
  }
}

export function dateFormatter(timestamp: string) {
  if (timestamp) {
    var date = new Date(timestamp)
    const year = date.getFullYear()
    const month = date.getMonth() + 1
    const day = date.getDate()
    return [year, month, day].map(formatNumber).join('-')
    // return [year, month, day].map(formatNumber).join('-')
  } else {
    return ''
  }
}

const formatNumber = (n: any) => {
  n = n.toString()
  return n[1] ? n : '0' + n
}
Vue.filter('timeFormatter', timeFormatter)
Vue.filter('dateFormatter', dateFormatter)
