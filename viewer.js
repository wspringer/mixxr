(function() {
  var createElementFromHTML, vm;

  createElementFromHTML = function(htmlString) {
    var div;
    div = document.createElement('div');
    div.innerHTML = htmlString.trim();
    return div;
  };

  Vue.component('viewer', {
    template: '<div><slot/></div>',
    mounted: function() {
      var code, el, pre, replica;
      el = this.$el;
      replica = createElementFromHTML(Prism.highlight(html_beautify(el.innerHTML, {
        extra_liners: 'button, a, input, div, label, /div, select, textarea'
      }).replace(/\n\s*\n/g, '\n'), Prism.languages.markup));
      code = document.createElement('code');
      code.setAttribute('class', 'language-markup');
      code.appendChild(replica);
      pre = document.createElement('pre');
      pre.setAttribute('class', 'language-markup');
      pre.appendChild(code);
      return el.appendChild(pre);
    }
  });

  vm = new Vue({
    el: '#app'
  });

}).call(this);
