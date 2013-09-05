(function($,window){

  // clears the form
  $.fn.clearForm = function () {
    // iterate each matching form
    return this.each(function () {
      // iterate the elements within the form
      $(':input', this).each(function () {
        var type = this.type, tag = this.tagName.toLowerCase();
        if (type == 'text' || type == 'password' || tag == 'textarea')
          this.value = this.getAttribute('value') || '';
        else if (type == 'checkbox' || type == 'radio')
          this.checked = false;
        else if (tag == 'select') {
          this.selectedIndex = -1;
          var options = this.options;
          for (var n = 0; n < options.length; n++)
            if (options[n].getAttribute("selected")) {
              this.selectedIndex = n; 
              break; 
            }
        }
      });
    });
  };

  // sets input fileds of the form found in the val, clears others.
  $.fn.formValue = function (val) // [{name:"name1", value:"val1"},{name:"name2", value:"val2"}, ...]
  {
    function setValue(root, name, val) {
      if(!name) return;
      var names = name.split(".");
      var map = root;
      for(var i = 0; i < names.length - 1; ++i) {
        var n = names[i];
        var t = map[n];
        if( typeof t != "object" ) map = map[n] = {};
        else map = t;
      }
      map[names[names.length-1]] = val;
    }
    function getValue(root, name) {
      if(!name) return;
      var names = name.split(".");
      var map = root;
      for(var i = 0; i < names.length - 1; ++i) {
        var n = names[i];
        var t = map[n];
        if( typeof t != "object" ) return undefined;
        else map = t;
      }
      return map[names[names.length-1]];
    }
  
    function getValues(form) {
      var map = {};
      // iterate the elements within the form
      $(':input,.input', form).each(function () {
        var type = this.type, tag = this.tagName.toLowerCase();
        var name = this.id || this.getAttribute("name");
        if(!name) return;
        var $value = this.$value;
        if (typeof $value == "functon")
          setValue(map,name,$value.call(this));
        else if (type == 'text' || type == 'password' || tag == 'textarea')
          setValue(map,name,this.value);
        else if (type == 'checkbox' || type == 'radio') {
          var v = this.getAttribute("value");
          if (this.checked)
            setValue(map,name,v ? v : true);
        }
        else if (tag == 'select') {
          var n = this.selectedIndex;
          var options = this.options;
          if (n >= 0 && n < options.length)
            setValue(map,name,options[n].value || options[n].text);
        }
      });
      return map;
    }

    if (val == undefined)
      return getValues(this);

    var map = val;
    if (map instanceof Array) {
      map = {};
      for (var n = 0; n < val.length; ++n)
        map[val[n].name] = val[n].value;

    }
    function setValues(form) {
      // iterate the elements within the form
      $(':input,.input', form).each(function () {
        var type = this.type, tag = this.tagName.toLowerCase();
        var name = this.id || this.getAttribute("name");
        var nval = getValue(map,name);
        var $value = this.$value;
        if (typeof $value == "functon")
          $value.call(this, nval);
        if (type == 'text' || type == 'password' || tag == 'textarea')
          this.value = nval || '';
        else if (type == 'checkbox' || type == 'radio')
          this.checked = this.getAttribute("value") == nval;
        else if (tag == 'select') {
          this.selectedIndex = -1;
          var options = this.options;
          for (var n = 0; n < options.length; n++)
            if ((options[n].value || options[n].text) == nval) { this.selectedIndex = n; break; }
        }
      });
    }
    // iterate each matching form
    return this.each(function () { setValues(this); });
  };

})(jQuery,this);