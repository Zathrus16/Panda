
String.prototype.printf = function (obj) {
  function subst1(a, b)
  {
    var r = obj[b];
    return typeof r == 'string' || typeof r == 'number' ? r : a;
  }
  return this.replace(/{([^{}]*)}/g, subst1);
};

String.prototype.printv = function(/*,...*/) {
  var argv = arguments;
  function subst(a, b) {
    var n = parseInt(b);
    return n >= 0 && n < argv.length ? argv[n] : a;
  }
  return this.replace(/{([^{}]*)}/g, subst);
}

String.prototype.trim = function () {
  return this.replace(/^\s+|\s+$/g, '');
}