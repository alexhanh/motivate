$(document).ready(function() {
  $("#products .pagination a").live("click", function() {
    $.getScript(this.href);
    return false;
  });
  $("#products_search input").keyup(function() {
    $.get($("#products_search").attr("action"), $("#products_search").serialize(), null, "script");
    return false;
  });
	// todo: make this better by removing the element only after the AJAX request has been executed
	// we could add a class to "destroy_me" and search for it in remove_ingredient.js.erb and then finally remove it
	// and display "loading" here instead
	$('a.remove_ingredient').live('click', function() {
		$(this).parent().remove();
		return false;
	});
	
	
	
	var $units_select = $('#new_product select[name*="[unit]"], #new_recipe select[name*="[unit]"], #new_serving_size select[name*="[unit]"], .edit_serving_size select[name*="[unit]"], .edit_recipe select[name*="[unit]"]').append('<option value="1" id="new_unit_name_option">Uusi yksikkö</option>');
	
	var $new_unit_name = $('input[name*="[custom_unit]"]').hide();
	
	if ($new_unit_name.val() != '' || $units_select.val() == '1') {
		$units_select.find("#new_unit_name_option").attr("selected", "true");
		$new_unit_name.show();
	}
	
	$units_select.change(function()
  {
    if ( $(this).val() == '1')
    {
      $new_unit_name.show().focus();
    }
    else
    {
			$new_unit_name.val('');
      $new_unit_name.hide();
    }
	});
	
	// Apply styling to elements
	
	// Buttons
	$("#add_product_button").button();
	$("#add_recipe_button").button();
	
	// Flash boxes
	//$("#flash_notice").addClass('ui-widget').find("div").addClass('ui-state-highlight ui-corner-all');
	
	//$("#serving_sizes").tabs();
	
	// Validations
	// $("#new_product").validate({
	// 	
	// });
	
	// Style forms and buttons with jQuery UI
	// $("form input:not(:submit)").addClass("ui-widget-content");
	// $(":submit").button();
});