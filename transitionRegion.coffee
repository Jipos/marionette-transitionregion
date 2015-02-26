((factory) ->
  if typeof define is 'function' and define.amd
    define ['backbone.marionette'], (marionette) ->
      factory marionette
  else if typeof exports is 'object'
    Marionette = require 'backbone.marionette'
    module.exports = factory Marionette
  else
    factory Backbone.Marionette
) (Marionette) ->

  delay = (duration, callback) ->
    setTimeout callback, duration

  getFadeDuration = (region) ->
    @region.transitionDuration or 100

  class FadeTransitionRegion extends Marionette.Region

    attachHtml: (view) ->
      if @skipTransition?(view)
        super view
      else
        delay duration, =>
          duration = @transitionDuration or 100
          @$el.contents().detach()
          view.$el.hide()
          @el.appendChild(view.el)
          view.$el.fadeIn fadeDuration

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
