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
	
	// Tracker entry add, tracker select list change
	var $tracker_select = $('#tracker_select_list');
	$tracker_select.live('change', function(){
		if ($(this).val() != '') {
			$('#change_tracker').submit();
		}
	});
	
	//////////////////
	// Apply calendar
	//////////////////
		
	// Calendarify *eaten_at* inputs
	var $cals = $('input:[id*="eaten_at"]').datepicker();
	// todo: set only if it is empty
	$cals.datepicker('setDate', new Date());


	// Idea how to get this to work
	// Apply the click bind on #datepicker
	
	// todo: set max date
	var $dp = $("#datepicker").datepicker({
		// altFormat: "ddmmyy",
		// altField: "#date"
		showAnim: '',
		onSelect: function(date, inst) {
			//alert($("#datepicker").datepicker('option', 'dateFormat'));
			d = $.datepicker.parseDate($("#datepicker").datepicker('option', 'dateFormat'), date);
			$("#date").val($.datepicker.formatDate("ddmmyy", d));
			$("#dateform").submit();
		}
	});
	// add on select	
	
	//////////////////
	// Apply styling to elements
	//////////////////
	
	// Check jquery.bassistance.de/aristo-preview/demo.html for Aristo demos!
	
	// Buttons
	$("#add_product_button").button();
	$("#add_recipe_button").button();
	$("#product_submit").button();
	$("#food_entry_submit").button();
	
	// Date prev and next links
	// $("#date_nav #next_day a").text('').addClass('ui-icon ui-icon-carat-1-e').hover(
	// 	function() {
	// 		$(this).addClass('ui-state-hover');
	// 	},
	// 	function() {
	// 		$(this).removeClass('ui-state-hover');
	// 	});
	// 
	// $("#date_nav #prev_day a").text('').addClass('ui-icon ui-icon-carat-1-w').hover(
	// 	function() {
	// 		$(this).addClass('ui-state-hover');
	// 	},
	// 	function() {
	// 		$(this).removeClass('ui-state-hover');
	// 	});
	
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
	
	//////////////////
	// Uncategorized
	//////////////////
	
	// Default values for text fields
	$("#search").defaultValue({
		'value': 'Kirjoita tähän...'
	});
});