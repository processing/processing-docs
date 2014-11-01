var queue = [];
var isCommandRunning = false;

// show the debug window by pressing the "d" key
window.addEventListener("keyup", function(evt) {
	if(evt.keyCode == 68) {
		document.documentElement.classList.toggle("is-debug-mode");
	}
}, false);

// preset buttons
var presets = document.querySelectorAll(".preset-btn");
for(var i=0;i<presets.length;i++) {
	var preset = presets[i];
	preset.addEventListener("click", function(evt) {
		evt.preventDefault();

		// clear all checkboxes
		var checkboxes = document.querySelectorAll("input[type=checkbox]");
		for(var i=0;i<checkboxes.length;i++) {
			var checkbox = checkboxes[i];
			checkbox.checked = false;
		}

		// now toggle the ones we need.
		var options = JSON.parse(this.getAttribute("data-presets"));
		for(var i=0;i<options.length;i++) {
			var option = options[i];
			var checkbox = document.getElementById(option)

			checkbox.checked = true;
		}
	}, false);
}

// submit button
var submit = document.querySelector(".submit-btn");
submit.addEventListener("click", function(evt) {
	evt.preventDefault();

		var checkboxes = document.querySelectorAll("input[type=checkbox]:checked");
		for(var i=0;i<checkboxes.length;i++) {
			var checkbox = checkboxes[i];

			var command = {};
			command.instruction = checkbox.getAttribute("data-command");

			if(checkbox.hasAttribute("data-command-args")) {
				command.args = JSON.parse(checkbox.getAttribute("data-command-args"));
			}
			else {
				command.args = {};
			}

			queue.push(command);
		}

		if(!isCommandRunning) {
			runNextCommand();
		}
}, false);

function debug(str) {
	console.log(str)
	document.querySelector(".debug").innerHTML += "<p>" + str + "</p>";
}

function debugHR() {
	console.log("------------------------------------------");
	document.querySelector(".debug").innerHTML += "<hr />";	
}

// commands
function runNextCommand() {
	isCommandRunning = true;

	if(queue.length == 0) {
		isCommandRunning = false;
		debug("All commands are complete.");
		return;
	}

	var command = queue.shift();
	debug("Running command :: " + command.instruction);

	reqwest({
		url: "./" + command.instruction + ".php",
		method: "get",
		data: command.args,
		success: function(data) {
			debugHR();
			debug(data);
			debugHR();
			debug("Finished!");

			runNextCommand();
		}
	});
}