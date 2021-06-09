export interface RootState {}

export interface IAppState {
  sidebar: boolean
  device: string
  theme: string
  layout: string
  contentWidth: string
  fixedHeader: boolean
  fixSiderbar: boolean
  autoHideHeader: boolean
  color?: string | null
  weak: boolean
  multiTab: boolean
}

export interface IUserState {
  accessToken: string
  refreshToken: string
  nickname: string
  welcome: string
  avatar: string
  roles: any[]
  permissions: any[]
  info: any
  id: string
}

export interface IPermission {
  routers: any[]
  addRouters: any[]
}
