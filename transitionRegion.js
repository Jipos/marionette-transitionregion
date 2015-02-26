var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

(function(factory) {
  var Marionette;
  if (typeof define === 'function' && define.amd) {
    return define(['backbone.marionette'], function(marionette) {
      return factory(marionette);
    });
  } else if (typeof exports === 'object') {
    Marionette = require('backbone.marionette');
    return module.exports = factory(Marionette);
  } else {
    return factory(Backbone.Marionette);
  }
})(function(Marionette) {
  var FadeTransitionRegion, delay, getFadeDuration;
  delay = function(duration, callback) {
    return setTimeout(callback, duration);
  };
  getFadeDuration = function(region) {
    return this.region.transitionDuration || 100;
  };
  return FadeTransitionRegion = (function(superClass) {
    extend(FadeTransitionRegion, superClass);

    function FadeTransitionRegion() {
      return FadeTransitionRegion.__super__.constructor.apply(this, arguments);
    }

    FadeTransitionRegion.prototype.attachHtml = function(view) {
      if (typeof this.skipTransition === "function" ? this.skipTransition(view) : void 0) {
        return FadeTransitionRegion.__super__.attachHtml.call(this, view);
      } else {
        return delay(duration, (function(_this) {
          return function() {
            var duration;
            duration = _this.transitionDuration || 100;
            _this.$el.contents().detach();
            view.$el.hide();
            _this.el.appendChild(view.el);
            return view.$el.fadeIn(fadeDuration);
          };
        })(this));
      }
    };

    FadeTransitionRegion.prototype._destroyView = function() {
      var duration, view;
      if (typeof this.skipTransition === "function" ? this.skipTransition(this.currentView) : void 0) {
        return FadeTransitionRegion.__super__._destroyView.call(this);
      } else {
        duration = this.transitionDuration || 100;
        view = this.currentView;
        return view.$el.fadeOut(duration, (function(_this) {
          return function() {
            if (view.destroy && !view.isDestroyed) {
              view.destroy();
            } else {
              view.remove();
            }
            return view.isDestroyed = true;
          };
        })(this));
      }
    };

    return FadeTransitionRegion;

  })(Marionette.Region);
});
