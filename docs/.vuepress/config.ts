import { defineUserConfig } from 'vuepress'
import type { DefaultThemeOptions } from 'vuepress'

export default defineUserConfig<DefaultThemeOptions>({
  // site config
  lang: 'ja-JP',
  title: 'SQUARE ENIX MUSIC Channel on Youtube リンク集',
  description: '',

  // theme
  theme: '@vuepress/theme-default',
  themeConfig: {
    contributors: false,
  }
})