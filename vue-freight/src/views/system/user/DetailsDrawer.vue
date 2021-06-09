<template>
  <div>
    <a-drawer
      :title="
        type === 'ADD'
          ? '新增' + subjectTitle
          : type === 'EDIT'
          ? '编辑' + subjectTitle
          : subjectTitle + '详情'
      "
      :width="720"
      :visible="visible"
      :body-style="{ paddingBottom: '80px' }"
      @close="onClose"
    >
      <a-skeleton :loading="showSkeleton">
        <a-form-model
          ref="form"
          :model="formData"
          :labelCol="{ span: 10 }"
          :wrapperCol="{ span: 14 }"
          :rules="rules"
        >
          <a-row>
            <a-col :span="11">
              <a-form-model-item label="用户名" prop="username">
                <a-input
                  :disabled="type === 'INFO'"
                  v-model="formData.username"
                  placeholder="请输入用户名"
                ></a-input>
              </a-form-model-item>
              <a-form-model-item
                v-if="type === 'ADD'"
                label="密码"
                prop="password"
              >
                <a-input-password
                  v-model="formData.password"
                  placeholder="请输入密码"
                  autocomplete="off"
                />
              </a-form-model-item>
              <a-form-model-item
                v-if="type === 'ADD'"
                label="确认密码"
                prop="rPassword"
              >
                <a-input-password
                  v-model="formData.rPassword"
                  placeholder="请再次输入密码"
                  autocomplete="off"
                />
              </a-form-model-item>
              <a-form-model-item label="邮箱" prop="email">
                <a-input
                  :disabled="type === 'INFO'"
                  v-model="formData.email"
                  placeholder="请输入邮箱"
                ></a-input>
              </a-form-model-item>
              <a-form-model-item label="手机号码" prop="mobile">
                <a-input
                  :disabled="type === 'INFO'"
                  v-model="formData.mobile"
                  placeholder="请输入手机号码"
                ></a-input>
              </a-form-model-item>

              <a-form-model-item label="关联角色" prop="roleIds">
                <a-select
                  :disabled="type === 'INFO'"
                  v-model="formData.roleIds"
                  mode="multiple"
                  placeholder="请选择关联角色"
                  style="width: 100%"
                >
                  <a-select-option v-for="role in roles" :key="role.id">
                    {{ role.roleName }}
                  </a-select-option>
                </a-select>
              </a-form-model-item>
              <a-form-model-item label="关联部门" prop="deptIds">
                <a-tree-select
                  :disabled="type === 'INFO'"
                  show-search
                  style="width: 100%"
                  v-model="formData.deptIds"
                  placeholder="请选择关联部门"
                  allow-clear
                  multiple
                  tree-default-expand-all
                  :tree-data="depts"
                >
                </a-tree-select>
              </a-form-model-item>
              <a-form-model-item label="可用状态">
                <a-switch
                  :disabled="type === 'INFO'"
                  v-model="formData.enable"
                />
              </a-form-model-item>
              <a-form-model-item label="头像">
                <avatar-upload
                  :disabled="type === 'INFO'"
                  v-model="formData.avatar"
                ></avatar-upload>
              </a-form-model-item>
            </a-col>
            <a-col :span="11">
              <a-form-model-item label="真实姓名" prop="realName">
                <a-input
                  :disabled="type === 'INFO'"
                  v-model="formData.realName"
                  placeholder="请输入真实姓名"
                ></a-input>
              </a-form-model-item>

              <a-form-model-item label="昵称" prop="nickname">
                <a-input
                  :disabled="type === 'INFO'"
                  v-model="formData.nickname"
                  placeholder="请输入昵称"
                ></a-input>
              </a-form-model-item>

              <a-form-model-item label="工号" prop="workNo">
                <a-input
                  :disabled="type === 'INFO'"
                  v-model="formData.workNo"
                  placeholder="请输入工号"
                ></a-input>
              </a-form-model-item>

              <a-form-model-item label="生日" prop="birthDay">
                <a-date-picker
                  valueFormat="YYYY-MM-DD"
                  :disabled="type === 'INFO'"
                  v-model="formData.birthDay"
                />
              </a-form-model-item>
              <a-form-model-item label="过期时间">
                <!-- v-model="formData.expireAt" -->
                <a-date-picker
                  :showTime="true"
                  :disabled="type === 'INFO'"
                  v-model="formData.expireAtMoment"
                />
              </a-form-model-item>
              <a-form-model-item label="锁定状态">
                <a-switch
                  :disabled="type === 'INFO'"
                  v-model="formData.locked"
                />
              </a-form-model-item>
              <a-form-model-item label="性别">
                <a-select
                  :disabled="type === 'INFO'"
                  v-model="formData.gender"
                  style="width: 100%"
                  placeholder="请选择性别"
                >
                  <a-select-option
                    v-for="item in genderOptions"
                    :key="item.value"
                  >
                    {{ item.name }}</a-select-option
                  >
                </a-select>
              </a-form-model-item>
            </a-col>
          </a-row>
        </a-form-model>
        <div
          v-if="type !== 'INFO'"
          :style="{
            position: 'absolute',
            right: 0,
            bottom: 0,
            width: '100%',
            borderTop: '1px solid #e9e9e9',
            padding: '10px 16px',
            background: '#fff',
            textAlign: 'right',
            zIndex: 1
          }"
        >
          <a-button :style="{ marginRight: '8px' }" @click="onClose">
            取消
          </a-button>
          <a-button
            type="primary"
            :loading="loading"
            @click="submitForm('form')"
          >
            确认
          </a-button>
        </div>
      </a-skeleton>
    </a-drawer>
  </div>
</template>
<script lang="ts">
import { Mixins, Component, Emit, Prop, Watch } from 'vue-property-decorator'
import AvatarUpload from '@/components/Upload/AvatarUpload.vue'
import md5 from 'md5'
import moment from 'moment'
import MixinDetails from '@/mixins/mixin-details'
import { fetchList } from '@/api/common'

interface UserReq {
  username: string
  realName: string
  nickname: string
  avatar: string
  password: string | null
  rPassword: string | null
  mobile: string
  workNo: string
  email: string
  gender: string
  birthDay: string | null
  enable: boolean
  expireAt: string | null
  expireAtMoment: any
  locked: boolean
  deptIds: string[]
  roleIds: string[]
}

const defaultForm: UserReq = {
  username: '',
  realName: '',
  nickname: '',
  avatar: '',
  password: null,
  rPassword: null,
  mobile: '',
  workNo: '',
  email: '',
  gender: 'UNKNOWN',
  birthDay: null,
  enable: true,
  expireAt: null,
  expireAtMoment: null,
  locked: false,
  deptIds: [],
  roleIds: []
}

@Component({
  name: 'DetailsDrawer',
  components: {
    AvatarUpload
  }
})
export default class DetailsDrawer extends Mixins(MixinDetails) {
  protected url = 'api/v1/users'
  protected subjectTitle = '用户'
  protected formData = Object.assign({}, defaultForm)

  private roles: any[] = []
  private depts: any[] = []

  private genderOptions = [
    { name: '未知', value: 'UNKNOWN' },
    { name: '男', value: 'MALE' },
    { name: '女', value: 'FEMALE' }
  ]
  private rules = {
    username: [
      { required: true, message: '请输入用户名', trigger: 'blur' },
      { min: 5, max: 30, message: '长度在5-30之间', trigger: 'blur' }
    ],
    realName: [
      { required: true, message: '请输入实际姓名', trigger: 'blur' },
      { min: 2, max: 10, message: '长度在2-10之间', trigger: 'blur' }
    ],
    nickname: [
      { required: true, message: '请输入昵称', trigger: 'blur' },
      { min: 2, max: 20, message: '长度在2-20之间', trigger: 'blur' }
    ],
    password: [
      { required: true, message: '请输入密码', trigger: 'blur' },
      { min: 6, max: 20, message: '长度在6-20之间', trigger: 'blur' }
    ],
    rPassword: [
      { required: true, message: '请再次输入密码', trigger: 'blur' },
      {
        validator: this.validPass,
        trigger: 'blur'
      }
    ],
    mobile: [
      { required: true, message: '请输入手机号', trigger: 'blur' },
      { min: 11, max: 11, message: '请输入正确的手机号', trigger: 'blur' }
    ],
    email: [
      { required: true, message: '请输入邮箱', trigger: 'blur' },
      { min: 8, max: 30, message: '长度在8-30之间', trigger: 'blur' }
    ],
    workNo: [{ max: 30, message: '长度在30之内', trigger: 'blur' }]
  }

  private validPass(rule: any, value: any, callback: any) {
    if (value !== this.formData.password) {
      callback(new Error('两次输入的密码不一致'))
    } else {
      callback()
    }
  }

  protected onLoadDataSuccess() {
    this.$set(
      this.formData,
      'expireAtMoment',
      this.formData.expireAt ? moment(this.formData.expireAt, 'x') : null
    )
    console.log(this.formData)
  }

  protected resetFormData() {
    this.formData = Object.assign({}, defaultForm)
  }

  protected beforeAddData() {
    this.formData.password = md5(this.formData.password!)
    this.formData.rPassword = this.formData.password
    this.beforeEditData()
  }

  protected afterAddData() {
    this.formData.password = null
    this.formData.rPassword = null
  }
  protected beforeEditData() {
    if (this.formData.expireAtMoment != null) {
      this.formData.expireAt = this.formData.expireAtMoment.format('x')
    } else {
      this.formData.expireAt = null
    }
  }
  private created() {
    fetchList('/api/v1/roles', {
      current: 1,
      size: 10000
    }).then((res: any) => {
      this.roles = res.records
    })

    fetchList('/api/v1/depts/tree', {}).then((res: any) => {
      this.depts = []
      this.recursiveTreeData(res, this.depts)
    })
  }

  recursiveTreeData(tree: any[], depts: any[]) {
    for (let i = 0; i < tree.length; i++) {
      const item = tree[i]
      depts.push({ title: item.deptName, value: item.id, key: item.id })
      if (item.children) {
        depts[i].children = []
        this.recursiveTreeData(item.children, depts[i].children)
      }
    }
  }
}
</script>
