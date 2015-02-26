((root, factory) ->
  if typeof define is 'function' and define.amd
    define ['backbone.marionette'], (marionette) ->
      factory(root, marionette)
  else if typeof exports is 'object'
    Marionette = require 'backbone.marionette'
    module.exports = factory root, Marionette
  else
    factory(root, Backbone.Marionette)
) this, (Marionette) ->

  getFadeDuration = (region) ->
    @region.transitionDuration or 100

  class FadeTransitionRegion extends Marionette.Region

    attachHtml: (view) ->
      if @skipTransition?(view)
        super view
      else
        setTimeout =>
          duration = @transitionDuration or 100
          @$el.contents().detach()
          view.$el.hide()
          @el.appendChild(view.el)
          view.$el.fadeIn fadeDuration
        , duration

    _destroyView: ->
      if @skipTransition?(@currentView)
        super()
      else
        duration = @transitionDuration or 100
        view = @currentView
        view.$el.fadeOut duration, =>
          if view.destroy and not view.isDestroyed
            view.destroy()
          else
            view.remove()

          # appending isDestroyed to raw Backbone View allows regions
          # to throw a ViewDestroyedError for this view
          view.isDestroyed = true
