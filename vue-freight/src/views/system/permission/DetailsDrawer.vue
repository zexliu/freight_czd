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
          :labelCol="{ span: 6 }"
          :wrapperCol="{ span: 14 }"
          :rules="rules"
        >
          <a-form-model-item label="权限名称" prop="permissionName">
            <a-input
              :disabled="type === 'INFO'"
              v-model="formData.permissionName"
              placeholder="请输入权限名称"
            ></a-input>
          </a-form-model-item>

          <a-form-model-item label="权限编码" prop="permissionCode">
            <a-input
              :disabled="type === 'INFO'"
              v-model="formData.permissionCode"
              placeholder="请输入权限编码"
            ></a-input>
          </a-form-model-item>
          <a-form-model-item label="权限路径" prop="permissionPath">
            <a-input
              :disabled="type === 'INFO'"
              v-model="formData.permissionPath"
              placeholder="请输入权限路径"
            ></a-input>
          </a-form-model-item>
          <a-form-model-item label="所属权限" prop="parentIds">
            <a-cascader
              :disabled="type === 'INFO'"
              :options="permissionOptions"
              change-on-select
              v-model="formData.parentIds"
              placeholder="请选择所属模块"
              :field-names="{
                label: 'permissionName',
                value: 'id',
                children: 'children'
              }"
            />
          </a-form-model-item>
          <a-form-model-item label="方法类型" prop="methodType">
            <a-select
              default-value="ALL"
              v-model="formData.methodType"
              style="width: 100%"
              placeholder="请选择可用状态"
            >
              <a-select-option
                v-for="item in methodTypeOptions"
                :key="item.value"
              >
                {{ item.name }}</a-select-option
              >
            </a-select>
          </a-form-model-item>
          <a-form-model-item label="排序">
            <a-input-number
              style="width: 100%"
              :disabled="type === 'INFO'"
              v-model="formData.seq"
              placeholder="请输入排序"
              :precision="0"
              :max="999999999"
              :min="0"
            ></a-input-number>
          </a-form-model-item>
          <a-form-model-item label="描述">
            <a-textarea
              :disabled="type === 'INFO'"
              v-model="formData.description"
              placeholder="请输入描述"
              :maxLength="200"
              :auto-size="{ minRows: 3, maxRows: 8 }"
            ></a-textarea>
          </a-form-model-item>
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
import { Mixins, Component, Prop } from 'vue-property-decorator'
import MixinDetails from '@/mixins/mixin-details'
interface PermissionReq {
  permissionName: string
  permissionCode: string
  permissionPath: string
  seq: number
  description: string
  parentId: string | null
  methodType: string
  parentIds: any[]
}

const defaultForm: PermissionReq = {
  permissionName: '',
  permissionCode: '',
  permissionPath: '',
  seq: 0,
  description: '',
  parentId: null,
  methodType: 'ALL',
  parentIds: []
}

@Component({
  name: 'DetailsDrawer'
})
export default class DetailsDrawer extends Mixins(MixinDetails) {
  protected url = 'api/v1/permissions'
  protected subjectTitle = '权限'
  protected formData = Object.assign({}, defaultForm)

  @Prop({
    type: Array,
    default: false
  })
  protected permissionOptions!: []

  private methodTypeOptions = [
    { name: 'ALL', value: 'ALL' },
    { name: 'GET', value: 'GET' },
    { name: 'POST', value: 'POST' },
    { name: 'PUT', value: 'PUT' },
    { name: 'DELETE', value: 'DELETE' }
  ]
  private rules = {
    permissionName: [
      { required: true, message: '请输入权限名称', trigger: 'blur' },
      { min: 2, max: 30, message: '长度在2-30之间', trigger: 'blur' }
    ],
    permissionCode: [
      { required: true, message: '请输入权限编码', trigger: 'blur' },
      { min: 2, max: 30, message: '长度在2-30之间', trigger: 'blur' }
    ],
    permissionPath: [
      { required: true, message: '请输入权限路径', trigger: 'blur' },
      { min: 6, max: 200, message: '长度在6-200之间', trigger: 'blur' }
    ],
    parentIds: [{ required: true, message: '请选择所属模块', trigger: 'blur' }],
    methodType: [
      { required: true, message: '请选择方法类型', trigger: 'blur' }
    ],
    description: [{ max: 200, message: '长度在200之内', trigger: 'blur' }]
  }

  protected resetFormData() {
    this.formData = Object.assign({}, defaultForm)
  }

  protected beforeAddData() {
    this.formData.parentId = this.formData.parentIds[
      this.formData.parentIds.length - 1
    ]
  }
  protected onLoadDataSuccess() {
    this.$set(this.formData, 'parentIds', [])
    this.recursiveParentIds(this.selectedKey!, this.permissionOptions)
    if (this.formData.parentIds.length == 0) {
      this.formData.parentIds.push(null)
    }
    this.recursiveDisabled(this.permissionOptions)
  }

  protected beforeEditData() {
    this.formData.parentId = this.formData.parentIds[
      this.formData.parentIds.length - 1
    ]
  }

  recursiveParentIds(currentKey: string, list: any[]) {
    list.forEach((item: any) => {
      if (item.id === currentKey) {
        if (item.parentId) {
          this.formData.parentIds.unshift(item.parentId)
          return this.recursiveParentIds(item.parentId, this.permissionOptions)
        } else {
          return
        }
      }
      if (item.children) {
        this.recursiveParentIds(currentKey, item.children)
      }
    })
  }

  recursiveDisabled(list: any[]) {
    if (list) {
      list.forEach((item: any) => {
        if (this.selectedKey !== null && item.id === this.selectedKey) {
          item.disabled = true
        } else {
          item.disabled = false
        }
        if (item.children) {
          this.recursiveDisabled(item.children)
        }
      })
    }
  }
}
</script>
