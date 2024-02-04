
let Hooks = {};   


Hooks.OpenTab = {
    mounted() {
      this.handleEvent("open_tab", ({url}) => {
        window.open(url, '_blank').focus();
      });
    }
  }

export default Hooks;