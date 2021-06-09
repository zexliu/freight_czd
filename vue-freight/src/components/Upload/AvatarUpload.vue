<template>
  <a-upload
    class="avatar-uploader"
    :show-upload-list="false"
    :before-upload="beforeUpload"
    :customRequest="customRequest"
    list-type="picture-card"
    :disabled="disabled"
  >
    <img class="avatar" v-if="imageUrl" :src="imageUrl" alt="avatar" />
    <div v-else>
      <a-icon
        class="avatar-uploader-icon"
        :type="loading ? 'loading' : 'plus'"
      />
    </div>
  </a-upload>
</template>

<script lang="ts">
import { Component, Vue, Prop, Emit } from 'vue-property-decorator'
import { upload } from '@/api/upload'
@Component({
  name: 'AvatarUpload'
})
export default class extends Vue {
  @Prop({
    type: String,
    default: ''
  })
  private value!: string

  @Prop({
    type: Boolean,
    default: false
  })
  private disabled!: boolean

  private loading = false

  get imageUrl() {
    return this.value
  }

  private beforeUpload(file: any) {
    const isImage =
      file.type === 'image/jpeg' ||
      file.type === 'image/png' ||
      file.type === 'image/gif'
    const isLt2M = file.size / 1024 / 1024 < 2

    if (!isImage) {
      this.$message.error('上传头像图片只能是 JPG  png 或 gif格式!')
    }
    if (!isLt2M) {
      this.$message.error('上传头像图片大小不能超过 2MB!')
    }
    return isImage && isLt2M
  }

  private customRequest(data: any) {
    const formData = new FormData()
    formData.append('file', data.file)
    this.loading = true
    upload(formData)
      .then(res => {
        this.onChanged(String(res))
      })
      .finally(() => {
        this.loading = false
      })
  }

  @Emit('input')
  private onChanged(val: string) {}
}
</script>

<style scoped>
.avatar-uploader .ant-upload {
  border: 1px dashed #d9d9d9;
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
}
.avatar-uploader .ant-upload:hover {
  border-color: #409eff;
}
.avatar-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 128px;
  height: 128px;
  line-height: 128px;
  text-align: center;
}
.avatar {
  width: 128px;
  height: 128px;
  display: block;
}
</style>
