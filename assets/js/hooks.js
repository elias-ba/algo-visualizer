let Hooks = {};

Hooks.Draggable = {
  mounted() {
    this.el.addEventListener("dragstart", (e) => {
      e.dataTransfer.setData("text/plain", e.target.id);
    });

    this.el.closest(".grid").addEventListener("dragover", (e) => {
      e.preventDefault();
    });

    this.el.closest(".grid").addEventListener("drop", (e) => {
      e.preventDefault();
      const id = e.dataTransfer.getData("text");
      const element = document.getElementById(id);
      if (element) {
        const rect = e.target.getBoundingClientRect();
        const x = Math.floor((e.clientX - rect.left) / 20);
        const y = Math.floor((e.clientY - rect.top) / 20);
        this.pushEvent("drag", { id: id, x: x, y: y });
      }
    });
  },
};

export default Hooks;
