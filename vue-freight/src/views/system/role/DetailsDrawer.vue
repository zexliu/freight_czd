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
          <a-form-model-item label="角色名称" prop="roleName">
            <a-input
              :disabled="type === 'INFO'"
              v-model="formData.roleName"
              placeholder="请输入角色名称"
            ></a-input>
          </a-form-model-item>

          <a-form-model-item label="角色编码" prop="roleCode">
            <a-input
              :disabled="type === 'INFO'"
              v-model="formData.roleCode"
              placeholder="请输入角色编码"
            ></a-input>
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
              v-model="formData.description"
              :disabled="type === 'INFO'"
              placeholder="请输入描述"
              :maxLength="200"
              :auto-size="{ minRows: 1, maxRows: 8 }"
            ></a-textarea>
          </a-form-model-item>
          <a-form-model-item label=" " :colon="false">
            <a-tabs default-active-key="1">
              <a-tab-pane key="1" tab="关联权限">
                <a-form-model-item>
                  <a-tree
                    :checkable="true"
                    :checkStrictly="true"
                    :disabled="type === 'INFO'"
                    :default-expand-all="true"
                    v-model="formData.permissionIds"
                    :auto-expand-parent="true"
                    :tree-data="permissionTree"
                    :replaceFields="{
                      children: 'children',
                      title: 'permissionName',
                      key: 'id'
                    }"
                  />
                </a-form-model-item>
              </a-tab-pane>
              <a-tab-pane key="2" tab="关联菜单">
                <a-form-model-item>
                  <a-tree
                    ref="menuTree"
                    :disabled="type === 'INFO'"
                    :checkable="true"
                    :default-expand-all="true"
                    v-model="formData.menuIds"
                    :auto-expand-parent="true"
                    @check="onMenuTreeCheck"
                    :tree-data="menuTree"
                    :replaceFields="{
                      children: 'children',
                      title: 'menuName',
                      key: 'id'
                    }"
                  />
                </a-form-model-item>
              </a-tab-pane>
            </a-tabs>
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
import { Mixins, Component } from 'vue-property-decorator'
import MixinDetails from '@/mixins/mixin-details'
import { fetchList } from '@/api/common'
interface RoleReq {
  roleName: string
  roleCode: string
  seq: number
  description: string
  permissionIds: string[] | any
  menuIds: string[] | any
  permissions: any[]
  menus: any[]
}

const defaultForm: RoleReq = {
  roleName: '',
  roleCode: '',
  seq: 0,
  description: '',
  permissionIds: [],
  menuIds: [],
  permissions: [],
  menus: []
}

@Component({
  name: 'DetailsDrawer'
})
export default class DetailsDrawer extends Mixins(MixinDetails) {
  protected url = 'api/v1/roles'
  protected subjectTitle = '角色'
  protected formData = Object.assign({}, defaultForm)

  private permissionTree: any[] = []
  private menuTree: any[] = []
  private halfCheckedMenu: string[] = []
  private rules = {
    roleName: [
      { required: true, message: '请输入角色名称', trigger: 'blur' },
      { min: 2, max: 30, message: '长度在2-10之间', trigger: 'blur' }
    ],
    roleCode: [
      { required: true, message: '请输入角色编码', trigger: 'blur' },
      { min: 2, max: 10, message: '长度在2-10之间', trigger: 'blur' }
    ]
  }

  created() {
    fetchList('/api/v1/permissions/tree', {}).then((res: any) => {
      this.permissionTree = res
    })
    fetchList('/api/v1/menus/tree', {}).then((res: any) => {
      this.menuTree = res
    })
  }

  protected resetFormData() {
    this.formData = Object.assign({}, defaultForm)
  }

  protected beforeAddData() {
    this.formData.menuIds = this.formData.menuIds.concat(this.halfCheckedMenu)
  }
  protected beforeEditData() {
    this.formData.menuIds = this.formData.menuIds.concat(this.halfCheckedMenu)
  }

  private onMenuTreeCheck(selectedKeys: any, e: any) {
    this.halfCheckedMenu = e.halfCheckedKeys
  }

  protected onLoadDataSuccess() {
    this.$set(
      this.formData,
      'permissionIds',
      this.formData.permissions.flatMap(i => {
        return i.id
      })
    )
    this.$set(
      this.formData,
      'menuIds',
      this.formData.menus.flatMap(i => {
        return i.id
      })
    )
    this.recursiveDeleteHalfCheckedMenu(this.menuTree)
    console.log('select', this.formData.menuIds)
    console.log('half', this.halfCheckedMenu)
  }

  //便利获取 板悬状态的列表
  recursiveDeleteHalfCheckedMenu(tree: any[]): any {
    let count = 0
    for (let i = 0; i < tree.length; i++) {
      const item = tree[i]
      //判断后端返回数据中是否包含当前项
      let check = this.formData.menuIds.find((el: string) => {
        return item.id === el
      })
      //如果包含
      if (check) {
        //如果有子级
        if (item.children) {
          //递归便利子级
          let isAllChildrenSelected = this.recursiveDeleteHalfCheckedMenu(
            item.children
          )
          //判断是否所有子级都被选中
          if (isAllChildrenSelected) {
            count++
          } else {
            this.halfCheckedMenu.push(check as string)
            console.log(this.formData.menuIds)
            this.formData.menuIds.splice(
              this.formData.menuIds.indexOf(check),
              1
            )
            console.log(this.formData.menuIds)
          }
        } else {
          count++
        }
      }
    }
    return count === tree.length
  }
}
</script>
