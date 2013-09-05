
var storage = function() {
  function store(name, data) {
    localStorage.removeItem(name); // needed due to the bug on iPAD OS v.3.2.1
    localStorage.setItem(name, data && JSON.emit(data));
    return data;
  }
  function remove(name) {
    localStorage.removeItem(name);
  }
  function fetch(name, defval) {
    var d = localStorage.getItem(name);
    return d ? JSON.parse(d) : defval;
  }
  function clear() {
    localStorage.clear();
  }
  
 return {
    put: store, // (name, data)
    get: fetch, // (name)
    remove: remove, // (name) - removes item from storage 
    clear: clear         //(), clears everything in storage  
  };  
  
}();
