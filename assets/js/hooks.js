let Hooks = {}

Hooks.AutoHideFlash = {
  mounted() {
    setTimeout(() => {
      this.el.click()
    }, 1500)
  }
}

export default Hooks
