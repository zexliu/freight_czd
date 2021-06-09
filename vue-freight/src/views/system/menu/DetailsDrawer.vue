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
          <a-form-model-item label="菜单名称" prop="menuName">
            <a-input
              :disabled="type === 'INFO'"
              v-model="formData.menuName"
              placeholder="请输入菜单名称"
            ></a-input>
          </a-form-model-item>

          <a-form-model-item label="菜单编码" prop="menuCode">
            <a-input
              :disabled="type === 'INFO'"
              v-model="formData.menuCode"
              placeholder="请输入菜单编码"
            ></a-input>
          </a-form-model-item>
          <a-form-model-item label="页面路径" prop="menuPath">
            <a-input
              :disabled="type === 'INFO'"
              v-model="formData.menuPath"
              placeholder="请输入页面路径"
            ></a-input>
          </a-form-model-item>
          <a-form-model-item label="组件" prop="component">
            <a-input
              :disabled="type === 'INFO'"
              v-model="formData.component"
              placeholder="请输入组件名"
            ></a-input>
          </a-form-model-item>
          <a-form-model-item label="所属菜单" prop="parentIds">
            <a-cascader
              :disabled="type === 'INFO'"
              :options="menuOptions"
              change-on-select
              v-model="formData.parentIds"
              placeholder="请选择所属模块"
              :field-names="{
                label: 'menuName',
                value: 'id',
                children: 'children'
              }"
            />
          </a-form-model-item>
          <a-form-model-item label="菜单图标" prop="menuIcon">
            <a-input
              :disabled="type === 'INFO'"
              v-model="formData.menuIcon"
              placeholder="请输入菜单图标"
            ></a-input>
          </a-form-model-item>

          <a-form-model-item label="重定向" prop="redirect">
            <a-input
              :disabled="type === 'INFO'"
              v-model="formData.redirect"
              placeholder="请输入重定向路径"
            ></a-input>
          </a-form-model-item>
          <a-form-model-item label="是否隐藏" prop="hidden">
            <a-switch
              :disabled="type === 'INFO'"
              v-model="formData.hidden"
            ></a-switch>
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
interface MenuReq {
  menuName: string
  menuCode: string
  menuIcon?: string | null
  menuPath?: string | null
  redirect?: string | null
  component?: string | null
  parentIds: any[]
  seq: number
  description: string
  parentId: string | null
  hidden: boolean
}

const defaultForm: MenuReq = {
  menuName: '',
  menuCode: '',
  menuIcon: '',
  parentId: null,
  menuPath: '',
  redirect: '',
  component: '',
  parentIds: [],
  seq: 0,
  description: '',
  hidden: false
}

@Component({
  name: 'DetailsDrawer'
})
export default class DetailsDrawer extends Mixins(MixinDetails) {
  protected url = 'api/v1/menus'
  protected subjectTitle = '菜单'
  protected formData = Object.assign({}, defaultForm)

  @Prop({
    type: Array,
    default: false
  })
  protected menuOptions!: []

  private rules = {
    menuName: [
      { required: true, message: '请输入菜单名称', trigger: 'blur' },
      { min: 2, max: 30, message: '长度在2-30之间', trigger: 'blur' }
    ],
    menuCode: [
      { required: true, message: '请输入菜单编码', trigger: 'blur' },
      { min: 2, max: 30, message: '长度在2-30之间', trigger: 'blur' }
    ],
    menuIcon: [{ max: 200, message: '长度在128之内', trigger: 'blur' }],
    menuPath: [
      { required: true, message: '请输入菜单名称', trigger: 'blur' },
      { max: 200, message: '长度在128之内', trigger: 'blur' }
    ],
    redirect: [{ max: 200, message: '长度在200之内', trigger: 'blur' }],
    component: [
      { required: true, message: '请输入组件名', trigger: 'blur' },
      { max: 200, message: '长度在200之内', trigger: 'blur' }
    ],
    parentIds: [{ required: true, message: '请选择所属模块', trigger: 'blur' }],
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
    this.recursiveParentIds(this.selectedKey!, this.menuOptions)
    if (this.formData.parentIds.length == 0) {
      this.formData.parentIds.push(null)
    }
    this.recursiveDisabled(this.menuOptions)
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
          return this.recursiveParentIds(item.parentId, this.menuOptions)
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
