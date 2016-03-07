(function (mod) {
  if (typeof exports == "object" && typeof module == "object") // CommonJS
      module.exports = mod();
  else if (typeof define == "function" && define.amd) // AMD
      return define([], mod);
  else // Plain browser env
      this.DOMInterop = mod();
})(function () {
  "use strict";

  function DOMInterop() {
  }

  DOMInterop.hasCaretPositionFromPoint = function () {
    return !!document.caretPositionFromPoint;
  };

  DOMInterop.hasCaretRangeFromPoint = function () {
    return !!document.caretRangeFromPoint;
  };

  return DOMInterop;
});