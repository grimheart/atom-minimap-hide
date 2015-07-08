{CompositeDisposable} = require 'event-kit'

module.exports =
  active: false

  isActive: -> @active

  activate: (state) ->
    @subscriptions = new CompositeDisposable

  consumeMinimapServiceV1: (@minimap) ->
    @minimap.registerPlugin 'minimap-hide', this

  deactivate: ->
    @minimap.unregisterPlugin 'minimap-hide'
    @minimap = null

  activatePlugin: ->
    return if @active

    @active = true

    @minimapsSubscription = @minimap.observeMinimaps (minimap) =>
      minimapElement = atom.views.getView(minimap)
      editor= minimap.getTextEditor()
      @subscriptions.add atom.workspace.getActivePane().onDidChangeActive =>
        @handle_focus(minimapElement, editor)


  handle_focus: (minim_el, editor) ->
      if editor == atom.workspace.getActiveTextEditor()
        minim_el.classList.add('focus_pane')
      else
        minim_el.classList.remove('focus_pane')

  deactivatePlugin: ->
    return unless @active

    @active = false
    @minimapsSubscription.dispose()
    @subscriptions.dispose()