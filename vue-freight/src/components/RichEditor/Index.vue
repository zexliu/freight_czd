<template>
  <div
    :class="{ fullscreen: fullscreen }"
    class="tinymce-container"
    :style="{ width: containerWidth }"
  >
    <editor :id="id" v-model="content" :init="initOptions" :disabled="disabled">
    </editor>
  </div>
</template>

<script lang="ts">
import 'tinymce/tinymce'

import 'tinymce/themes/silver' // Import themes
import 'tinymce/themes/mobile'
import 'tinymce/plugins/advlist' // Any plugins you want to use has to be imported
import 'tinymce/plugins/anchor'
import 'tinymce/plugins/autolink'
import 'tinymce/plugins/autosave'
import 'tinymce/plugins/code'
import 'tinymce/plugins/codesample'
import 'tinymce/plugins/directionality'
import 'tinymce/plugins/emoticons'
import 'tinymce/plugins/fullscreen'
import 'tinymce/plugins/hr'
import 'tinymce/plugins/image'
import 'tinymce/plugins/imagetools'
import 'tinymce/plugins/insertdatetime'
import 'tinymce/plugins/link'
import 'tinymce/plugins/lists'
import 'tinymce/plugins/media'
import 'tinymce/plugins/nonbreaking'
import 'tinymce/plugins/noneditable'
import 'tinymce/plugins/pagebreak'
import 'tinymce/plugins/paste'
import 'tinymce/plugins/preview'
import 'tinymce/plugins/print'
import 'tinymce/plugins/save'
import 'tinymce/plugins/searchreplace'
import 'tinymce/plugins/spellchecker'
import 'tinymce/plugins/tabfocus'
import 'tinymce/plugins/table'
import 'tinymce/plugins/template'
import 'tinymce/plugins/textpattern'
import 'tinymce/plugins/visualblocks'
import 'tinymce/plugins/visualchars'
import 'tinymce/plugins/wordcount'
import 'tinymce/icons/default/icons'

import Editor from '@tinymce/tinymce-vue'
import { upload } from '@/api/upload'
const plugins = [
  'advlist anchor autolink autosave code codesample directionality emoticons fullscreen hr image imagetools insertdatetime link lists media nonbreaking noneditable pagebreak paste preview print save searchreplace spellchecker tabfocus table template textpattern visualblocks visualchars wordcount'
]
const toolbar = [
  'searchreplace bold italic underline strikethrough alignleft aligncenter alignright outdent indent blockquote undo redo removeformat subscript superscript code codesample',
  'hr bullist numlist link image charmap preview anchor pagebreak insertdatetime media table emoticons forecolor backcolor fullscreen'
]

import { Component, Prop, Vue, Watch } from 'vue-property-decorator'
const defaultId = () =>
  'vue-tinymce-' + +new Date() + ((Math.random() * 1000).toFixed(0) + '')

@Component({
  name: 'Tinymce',
  components: {
    Editor
  }
})
export default class extends Vue {
  @Prop({ required: true })
  private value!: string
  @Prop({ default: defaultId })
  private id!: string
  @Prop({ default: () => [] })
  private toolbar!: string[]
  @Prop({ default: 'file edit insert view format table' })
  private menubar!: string
  @Prop({ default: '360px' })
  private height!: string | number
  @Prop({ default: 'auto' })
  private width!: string | number
  @Prop({ default: false })
  private disabled!: boolean

  private hasChange = false
  private hasInit = false
  private fullscreen = false
  // https://www.tiny.cloud/docs/configure/localization/#language
  // and also see langs files under public/tinymce/langs folder
  private languageTypeList: { [key: string]: string } = {
    en: 'en',
    zh: 'zh_CN',
    es: 'es',
    ja: 'ja'
  }

  //todo language
  get language() {
    return this.languageTypeList['zh']
  }

  get uploadButtonColor() {
    return 'Blue'
  }

  get content() {
    return this.value
  }

  set content(value) {
    this.$emit('input', value)
  }

  get containerWidth() {
    const width = this.width
    // Test matches `100`, `'100'`
    if (/^[\d]+(\.[\d]+)?$/.test(width.toString())) {
      return `${width}px`
    }
    return width
  }

  get initOptions() {
    console.log('init options')
    return {
      selector: `#${this.id}`,
      height: this.height,
      body_class: 'panel-body ',
      object_resizing: false,
      toolbar: this.toolbar.length > 0 ? this.toolbar : toolbar,
      menubar: this.menubar,
      plugins: plugins,
      language: this.language,
      language_url:
        this.language === 'en'
          ? ''
          : `${process.env.BASE_URL}tinymce/langs/${this.language}.js`,
      skin_url: `${process.env.BASE_URL}tinymce/skins/ui/oxide`,
      emoticons_database_url: `${process.env.BASE_URL}tinymce/emojis.min.js`,
      end_container_on_empty_block: true,
      powerpaste_word_import: 'clean',
      code_dialog_height: 450,
      code_dialog_width: 1000,
      advlist_bullet_styles: 'square',
      advlist_number_styles: 'default',
      imagetools_cors_hosts: ['www.tinymce.com', 'codepen.io'],
      default_link_target: '_blank',
      link_title: false,
      nonbreaking_force_tab: true, // inserting nonbreaking space &nbsp; need Nonbreaking Space Plugin
      file_picker_types: 'image',
      init_instance_callback: (editor: any) => {
        if (this.value) {
          editor.setContent(this.value)
        }
        this.hasInit = true
        editor.on('NodeChange Change KeyUp SetContent', () => {
          this.hasChange = true
          this.$emit('input', editor.getContent())
        })
      },
      setup: (editor: any) => {
        editor.on('FullscreenStateChanged', (e: any) => {
          this.fullscreen = e.state
        })
      },
      images_upload_handler: (blobInfo: any, success: any, failure: any) => {
        const formData = new FormData()
        formData.append('file', blobInfo.blob(), blobInfo.filename())
        upload(formData)
          .then(res => {
            console.log('onSuccess', res)
            success(res)
          })
          .catch(e => {
            this.$notification.error({
              message: '失败',
              description: '上传图片失败'
            })
            failure(e)
          })
          .finally(() => {})
      }
    }
  }

  @Watch('language')
  private onLanguageChange() {
    const tinymceManager = (window as any).tinymce
    const tinymceInstance = tinymceManager.get(this.id)
    if (this.fullscreen) {
      tinymceInstance.execCommand('mceFullScreen')
    }
    if (tinymceInstance) {
      tinymceInstance.destroy()
    }
    this.$nextTick(() => tinymceManager.init(this.initOptions))
  }
}
</script>
<style lang="less" scoped>
.tinymce-container {
  position: relative;
  line-height: normal;

  .mce-fullscreen {
    z-index: 10000;
  }
}

textarea {
  visibility: hidden;
  z-index: -1;
}
</style>
