<template>
  <a-upload
    :multiple="false"
    :showUploadList="false"
    :before-upload="beforeUpload"
    :customRequest="customRequest"
  >
    <a-button type="primary" :loading="loading" icon="import">
      导入
    </a-button>
  </a-upload>
</template>

<script lang="ts">
import { Component, Vue, Prop, Emit } from 'vue-property-decorator'
import { uploadExcel } from '@/api/excel'
@Component({
  name: 'ExcelUpload'
})
export default class extends Vue {
  @Prop({
    type: String,
    default: ''
  })
  private name!: string

  private loading = false

  private beforeUpload(file: any) {
    const isLt2M = file.size / 1024 / 1024 < 2

    const isExce = file.name.endsWith('.xlsx')

    if (!isExce) {
      this.$message.error('导入excel文件只能是xlsx格式!')
    }
    if (!isLt2M) {
      this.$message.error('上传文件大小不能超过 2MB!')
    }
    return isExce && isLt2M
  }

  private customRequest(data: any) {
    const formData = new FormData()
    formData.append('file', data.file)
    this.loading = true
    uploadExcel({ name: this.name }, formData)
      .then(res => {
        this.onSuccess()
      })
      .finally(() => {
        this.loading = false
      })
  }

  @Emit()
  private onSuccess() {}
}
</script>
