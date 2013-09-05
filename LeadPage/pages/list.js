pageHandlers["leadlist"] = function(param) 
{
//|
//| view initialization:
//|
  var $page = $(this);
  var $form = $page.find("form");
  
  $form.off(".leadlist");
  
  $form.formValue(storage.get("leadlist",{}));

//|
//| view operation:
//|
 
  function showList() {
  
    var data = $form.formValue();
    
    function ondone(listData) {
      storage.put("leadlist", data);  // save settings
      var c = { leads: listData };
      $page.find("table.output > tbody").html(kite("#lead-list",c));
    }
    
    $.get(data.url)
      .done(ondone)
      .fail(function(err,status) { alert("communication " + status); });    
  }
  
  $form.on("click.leadlist", "button[name=go]", showList );
  
};
