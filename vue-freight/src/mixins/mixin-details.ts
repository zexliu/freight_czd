import { Vue, Component, Emit, Prop, Watch } from 'vue-property-decorator'
import { create, update, details } from '@/api/common'

@Component({
  components: {}
})
export default class MixinDetails extends Vue {
  protected url = ''
  protected subjectTitle = ''
  protected formData: any = null

  @Prop({
    type: Boolean,
    default: false
  })
  protected visible!: boolean

  @Prop({
    type: String,
    default: 'ADD'
  })
  protected type!: string

  @Prop({
    type: String
  })
  protected selectedKey?: string

  protected loading = false

  protected showSkeleton = false

  protected onClose() {
    if (!this.loading) {
      this.close(false)
    }
  }
  @Emit()
  protected close(val: boolean) {}

  @Emit()
  protected onAddSuccess(val: any) {}

  @Emit()
  protected onEditSuccess(val: any) {}

  @Watch('selectedKey')
  protected onChangeValue(newVal: string) {
    if (this.type !== 'ADD') {
      this.showSkeleton = true
      details(this.url, newVal).then((res: any) => {
        this.formData = res
        this.onLoadDataSuccess()
        this.showSkeleton = false
      })
    } else {
      this.resetFormData()
    }
  }

  protected submitForm(formName: string) {
    let el: any = this.$refs[formName]
    el.validate((valid: boolean) => {
      if (valid) {
        this.loading = true
        if (this.type === 'ADD') {
          this.beforeAddData()
          create(this.url, this.formData)
            .then((res: any) => {
              this.resetFormData()
              this.$notification.success({
                message: '成功',
                description: '新增' + this.subjectTitle + '成功'
              })
              this.onAddSuccess(res)
            })
            .finally(() => {
              this.loading = false
              this.afterAddData()
            })
        } else if (this.type === 'EDIT') {
          this.beforeEditData()

          update(this.url, this.selectedKey!, this.formData)
            .then(() => {
              this.$notification.success({
                message: '成功',
                description: '更新' + this.subjectTitle + '成功'
              })
              this.loading = false
              this.onClose()
              this.onEditSuccess(this.formData)
            })
            .finally(() => {
              this.loading = false
            })
        }
      } else {
        console.log('error submit!!')
        return false
      }
    })
  }

  protected onLoadDataSuccess() {}

  protected resetFormData() {}

  protected beforeAddData() {}

  protected afterAddData() {}

  protected beforeEditData() {}
}
