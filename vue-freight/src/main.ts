import Vue from 'vue'

import App from './App.vue'
import router from './router'
import store from './store'
import { VueAxios } from './utils/request'

import bootstrap from './core/bootstrap'
import './core/lazy_use'
import './components/global.less'
import './permission' // permission control
import './filters/index'
Vue.config.productionTip = false
import { Image } from 'element-ui'
Vue.component(Image.name, Image)
// mount axios Vue.$http and this.$http
Vue.use(VueAxios)
new Vue({
  router,
  store,
  created: bootstrap,
  render: h => h(App)
}).$mount('#app')
