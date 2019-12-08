import * as enums from "@nativescript/core/ui/enums";

const AnimateIn = {
  inserted(el) {
    console.log('DIRECTIVE');
    el._nativeView.translateY = -50;

    el._nativeView.animate({
      translate: {x: 0, y: 0},
      duration: 200,
      curve: enums.AnimationCurve.cubicBezier(.41,.78,.17,1.19)
    });
  }
};

export default AnimateIn;
