var Goals = (function($) {
  var p = {};
  
  p.init = function() {
    $("#weight_goal").change(function() {
      if ($(this).val() == 'lose') {
        $("#weight_change_rate").show();
        update(0.5, 1, -1);
      }
      else if ($(this).val() == 'keep') {
        $("#weight_change_rate").hide();
        update(0.0, 0.0, 0);
      }
      else {
        $("#weight_change_rate").show();
        update(0.5, 1, 1);
      }
    });
  };
  
  function update(weight, weeks, goal) {
    $("#weight").val(weight);
    $("#weeks").val(weeks);
    $("#goal").val(goal);
  }
  
  return p;
}(jQuery));

// http://www.adequatelygood.com/2010/3/JavaScript-Module-Pattern-In-Depth
var CustomUnit = (function($) {
	var p = {};
	var selectNameAttr = '';
	var fieldNameAttr = '';
	
	p.init = function($select, $field) {
	  if ($select.length == 0 || $field.length == 0)
	    return;
	  
		$select.append('<option value="0" id="new_unit_name_option">Uusi yksikkö</option>');
		
		selectNameAttr = $select.attr('name');
		fieldNameAttr = $field.attr('name');
	
		if (isInt($field.val()) || ($field.val() == '' && $select.find("option").length > 1)) {
			$field.val('').hide();
			$field.removeAttr('name');
		} 
		else {
			$select.find("#new_unit_name_option").attr("selected", "true");
			$select.removeAttr('name');
		}
		
		$select.change(function() {
			if ($(this).val() == '0') {
				$select.removeAttr('name');
				$field.attr('name', fieldNameAttr);
				$field.show().focus();
			}
			else {
				$field.removeAttr('name');
				$select.attr('name', selectNameAttr);
				$field.val('').hide();
			}
		});
	};
	
	function isInt(s) {
		return s.match(/^\d+/);
	}
	
	return p;
}(jQuery));

$(document).ready(function() {
  Goals.init();
  
  // $("#products .pagination a").live("click", function() {
  //   $.getScript(this.href);
  //   return false;
  // });
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
	
	
	var $units_select = $('#new_product select[name*="[unit]"], #new_recipe select[name*="[unit]"], #new_food_unit select[name*="[unit]"], .edit_food_unit select[name*="[unit]"], .edit_recipe select[name*="[unit]"]');
	var $new_unit_name = $('input[name*="[unit]"]');
	CustomUnit.init($units_select, $new_unit_name);
	
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