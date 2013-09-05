pageHandlers["test"] = function(param) 
{
//|
//| view initialization:
//|
  var $page = $(this);
  var $form = $page.find("form");
  
  $form.off(".test");
  
  var testCases = storage.get("testcases1",{});
  var data;  
  var dataChanged = false;
  
  if(param) { data = testCases[param]; }
  if(!data) data = {
      leadData: {},
      caseName: "test #1",
      url: ""
    };
    
  function updateListOfCases() {
    var $list = $form.find("[name=caseName]").closest(".input-group").find(".dropdown-menu");
    $list.html("");
    for( var k in testCases )
      $list.append( "<li><a href='#test:{0}'>{0}</a></li>".printv(k) );
  }
    
  $form.formValue(data);
  updateListOfCases();

//|
//| view operation:
//|
 
  function storeData() {
    if (!dataChanged ) return false;
    data = $form.formValue();
    testCases[data.caseName] = data;  
    storage.put("testcases1",testCases);
    dataChanged = false;
    return true;
  }
 
  function submitData() {
    storeData();
    updateListOfCases();
    
    $.post(data.url, data.leadData).done(function() { alert("success"); })
                                   .fail(function() { alert("communication error"); });    
  }
  
  function showData() {
    var data = $form.formValue();
    alert(JSON.emit(data.leadData));
  }
  
  
  
  $form.on("click.test", "button[name=go]", submitData );
  $form.on("click.test", "button[name=test]", showData );
  $form.on("change.test", "*:input", function() { dataChanged = true; } );
 
  
};
