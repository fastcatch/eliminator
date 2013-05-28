
$(document).ready(function(){

  // Default options for in-place editor
  // Reload page on success because the whole branch-to-root may have changed on submit
  $.fn.editable.defaults.ajaxOptions = {
    type: 'put',
    dataType: 'json',
    success: function(){ window.location.reload() }
  };
  // Activate in-place editor
  $('.js-x-editable').tooltip({
    title: 'Click to edit'
  }).editable({
    showbuttons: false,
    mode: 'inline',
    onblur: 'cancel'
  })

  // Create tooltips
  //  and popover on .js-editable items
  $('.js-editable').tooltip({
    title: 'Click to edit'
  }).on('click', function(e){
    e.preventDefault();
    $(this).tooltip('hide');
    var container = $(this).nextAll('.js-edit-form-container'),
        content = $(container).html();
    $(this).popover({
      html: true,
      content: content,
      placement: 'bottom'
    }).popover('show');
    // Initialize datetime pickers
    $(this).next().find("input.datetimepicker").each(function(){
      $(this).val( $(this).val().substr(0, 16) )
      $(this).datetimepicker({format: 'yyyy-mm-dd hh:ii'});
    });
  });

  // Convert titles to tooltips
  $('[title]').tooltip();
});

// Action for popover form Cancel button
$(document).on('click', 'button.js-dismiss-popover', function(e){
  e.preventDefault();
  $(this).parents('.popover').prev().popover('destroy');
});

// Highlight winning branch
$(document).on('mouseenter mouseleave', '.match.played', function(e){
  var node=$(this).closest('li');
  toggleHighlightFrom(node)
});

function toggleHighlightFrom(node) {
  if (!node || node.length == 0)
    return;
  var winner_branch = $(node).children('ul').first().children('li.winner_branch');
  $(winner_branch).children('a').find('.valuebox').toggleClass('highlight');
  toggleHighlightFrom(winner_branch);
}

