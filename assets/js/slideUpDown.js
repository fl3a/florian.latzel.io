$(document).ready(function() {  
  $("div.up-down").hide();
  $("div.up-down").addClass('collapsed');
  $("div.trigger").click(function() {
    var clicked = '#' + $(this).attr('id');
    var divId = '#' + $(this).attr('id') + '-div';
    if ($(divId).hasClass("collapsed")) {
      $(divId).slideDown();
      $(divId).removeClass('collapsed');      
      $(clicked).text('-');      
    }
    else {
      $(divId).slideUp();
      $(divId).addClass('collapsed');
      $(clicked).text('+');    
    }
    console.log(clicked);
    console.log(divId);
    
    
  });
});
