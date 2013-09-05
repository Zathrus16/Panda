
$(function(){
  //function navigateTo(page, param) {
  //  
  //}
  function onhashchange() 
  {
    var hash = location.hash || "#about";
    
    var re = /#(\w+)(:.+)?/;
    var match = re.exec(hash);
    hash = match[1];
    var param = match[2];
    if( param ) param = param.substr(1);
    $(".nav li.active").removeClass("active");
    $(".nav li a[href=#"+hash+"]").closest("li").addClass("active");
    
    var ph = pageHandlers[hash];
    if( ph ) { 
      var $page = $("section#" + hash);
      if($page.length) ph.call($page[0],param);
    }
    
    $(document.body).attr("page",hash) ;
  };
  $(window).hashchange( onhashchange );
  $(window).hashchange();
});

var pageHandlers = {};




