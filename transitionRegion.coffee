((factory) ->
  if typeof define is 'function' and define.amd
    define ['backbone.marionette'], (marionette) ->
      factory marionette
  else if typeof exports is 'object'
    module.exports = factory require('backbone.marionette')
  else
    factory Backbone.Marionette
) (Marionette) ->

  delay = (duration, callback) ->
    setTimeout callback, duration

  getFadeDuration = (region) ->
    region.transitionDuration or 100

  class FadeTransitionRegion extends Marionette.Region

    constructor: (options = {}) ->
      @skipTransition = options.skipTransition
      super options

    attachHtml: (view) ->
      if @skipTransition?(view)
        super view
      else
        fadeDuration = getFadeDuration @
        delay fadeDuration, =>
          @$el.contents().detach()
          view.$el.hide()
          @el.appendChild(view.el)
          view.$el.fadeIn fadeDuration

    _destroyView: ->
      if @skipTransition?(@currentView)
        super()
      else
        fadeDuration = getFadeDuration @
        view = @currentView
        view.$el.fadeOut fadeDuration, =>
          if view.destroy and not view.isDestroyed
            view.destroy()
          else
            view.remove()

          # appending isDestroyed to raw Backbone View allows regions
          # to throw a ViewDestroyedError for this view
          view.isDestroyed = true
