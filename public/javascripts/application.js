// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function showme() {
	alert("Hey!");
}

// This function counts the number of characters typed into a textarea
// and displays how many are remaining as the user types.

function textarea_counter(message_textarea, counter_textbox, max_length) {
	if(message_textarea.value.length > max_length)
		message_textarea.value = message_textarea.value.substring(0, max_length);
	else
		counter_textbox.value = max_length - message_textarea.value.length;
}
