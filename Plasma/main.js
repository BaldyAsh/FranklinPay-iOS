import Vue from 'vue'
import BootstrapVue from "bootstrap-vue"
import "bootstrap/dist/css/bootstrap.min.css"
import "bootstrap-vue/dist/bootstrap-vue.css"

import store from './store'
import Eth from 'ethjs'
import {ethers} from 'ethers'

window.ethers = ethers;
window.Eth = Eth

import Router from 'vue-router'
import App from './App.vue'
import Login from './Login.vue'
import Wallet from './Wallet.vue'

Vue.use(Router)
Vue.use(BootstrapVue)

const routes = [
    { path: '/login', component: Login },
    { path: '/wallet', component: Wallet },
    { path: '*', redirect: '/login' },
]

const router = new Router({
    routes // short for `routes: routes`
})

window.app = new Vue({
    el: '#app',
    router,
    data: () => ({
        store
    }),
    async created() {
        // read store.account from local storage?
        if (typeof window.web3 !== 'undefined') {
            window.eth = new Eth(web3.currentProvider)
            window.ethersProvider = new ethers.providers.Web3Provider(web3.currentProvider)
        }
        if (!store.account.address) {
            this.$router.push('/login')
        }
    },
    render: h => h(App)
})

// debug utils

window.BN = require('bn.js')
window.Buffer = require('buffer/').Buffer
window.store = store
window.p = {
    // promise printer for debugging in console
    set p(promise) {
        promise.then(r => console.log(r) )
    },
}