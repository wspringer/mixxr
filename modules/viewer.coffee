createElementFromHTML = (htmlString) ->
  div = document.createElement('div')
  div.innerHTML = htmlString.trim()
  div

Vue.component('viewer', {
  template: '<div><slot/></div>'
  mounted: ->
    el = this.$el
    replica = createElementFromHTML(
      Prism.highlight(
        html_beautify(el.innerHTML, { extra_liners: 'button, a, input, div, label, /div, select, textarea'}).replace(/\n\s*\n/g, '\n'),
        Prism.languages.markup
      )
    )
    code = document.createElement('code')
    code.setAttribute('class', 'language-markup')
    code.appendChild(replica);
    pre = document.createElement('pre')
    pre.setAttribute('class', 'language-markup')
    pre.appendChild(code)
    el.appendChild(pre)
})

vm = new Vue(
  el: '#app'
)
