<!doctype html>
<html>

<head>
	<meta http-equiv="content-type" content="text/html;charset=UTF-8" />
	<title>Processing.org Generator</title>

	<link rel="stylesheet" type="text/css" href="./css/generate.css" />
</head>

<body>
	<div class="wholepage">
		<header class="global-header">
			<h1 class="logo">Processing</h1>
		</header>

		<article class="main-content">
			<h2>Processing.org Generator</h2>

			<p>Select a preset, or choose what you&rsquo;re going to update.</p>
			
			<?php /* you can set a notice to "alert" or "warning" */ ?>
			<p class="notice alert hide">Hello, this is a notice!</p>

			<section class="generator">

				<div class="presets">
					<h3>Presets</h3>

					<p>
						<?php /* each data-preset is a JSON encoded array referring to the id of a checkbox further down the page. */ ?>

						<a href="#" class="preset-btn" data-presets='[ "git-pull", "exhibitions" ]'>Filip</a>
						<a href="#" class="preset-btn" data-presets='[ "git-pull", "tutorials" ]'>Dan</a>
						<a href="#" class="preset-btn" data-presets='[ "git-pull", "libraries", "tools", "contributions-2-x", "contributions-3-x" ]'>Elie</a>
						<!--<a href="#" class="preset-btn" data-presets='[ "git-pull", "cover", "environment", "examples", "static-pages", "reference" ]'>Scott</a>-->
						<!--<a href="#" class="preset-btn" data-presets='[ "git-pull", "foundation" ]'>Philip</a>-->
					</p>

					<p>
						<a href="#" class="preset-btn everything" data-presets='[ "git-pull", "cover", "reference", "exhibitions", "tutorials", "libraries", "tools", "static-pages", "examples", "environment", "contributions-3-x", "contributions-2-x" ]'>Everything</a>
						<a href="#" class="preset-btn everything" data-presets='[ "git-pull", "cover", "reference", "exhibitions", "tutorials", "libraries", "tools", "static-pages", "examples", "environment" ]'>Site</a>
						<a href="#" class="preset-btn everything" data-presets='[]'>Nothing</a>
					</p>
				</div>

				<div class="options">
					<h3>Options</h3>

					<?php /* each checkbox has a data-command attribute, which corresponds to a php file in the generate folder */ ?>
					<p class="highlight">
						<input type="checkbox" name="option" value="git-pull" id="git-pull" data-command="pull_latest">
						<label for="git-pull">Pull Latest Changes</label> (gets latest from 'processing-docs' repo)
					</p>

					<p>
						<input type="checkbox" name="option" value="cover" id="cover" data-command="cover">
						<label for="cover">Cover</label> (also updates Exhibition)
					</p>

					<p>
						<input type="checkbox" name="option" value="reference" id="reference" data-command="reference">
						<label for="reference">Reference</label> (pulls in latest changes to 'processing' and 'processing-sound' repos)
					</p>

					<p>
						<input type="checkbox" name="option" value="exhibitions" id="exhibitions" data-command="exhibition">
						<label for="exhibitions">Exhibition</label>
					</p>

					<p>
						<input type="checkbox" name="option" value="tutorials" id="tutorials" data-command="tutorials">
						<label for="tutorials">Tutorials</label>
					</p>


					<p>
						<input type="checkbox" name="option" value="libraries" id="libraries" data-command="libraries" data-command-args='{ "lang": "en" }'>
						<label for="libraries">Libraries</label>
					</p>

					<p>
						<input type="checkbox" name="option" value="tools" id="tools" data-command="tools",  data-command-args='{ "lang": "en" }'>
						<label for="tools">Tools</label>
					</p>

					<p>
						<input type="checkbox" name="option" value="static-pages" id="static-pages" data-command="staticpages">
						<label for="static-pages">Static Pages</label>
					</p>

					<p>
						<input type="checkbox" name="option" value="examples" id="examples" data-command="examples">
						<label for="examples">Examples</label>
					</p>

					<p>
						<input type="checkbox" name="option" value="environment" id="environment" data-command="environment">
						<label for="environment">Environment</label>
					</p>


					<!--
					<p>
						<input type="checkbox" name="option" value="foundation" id="foundation" data-command="foundation">
						<label for="foundation">Foundation</label>
					</p>
				    -->

					<p>
						<span class="highlight">Contributions</span>

						<input type="checkbox" name="option" value="contributions-2-x" id="contributions-2-x" data-command="contributions_data" data-command-args='{ "v": 2, "lang": "en" }'>
						<label for="contributions-2-x">2.x</label>

						<input type="checkbox" name="option" value="contributions-3-x" id="contributions-3-x" data-command="contributions_data" data-command-args='{ "v": 3, "lang": "en" }'>
						<label for="contributions-3-x">3.x</label>
					</p>

					<p>
						<a href="/contrib_generate/build.log" class="highlight">Contributions Log</a>

						<input type="checkbox" name="option" value="delete-log" id="delete-log" data-command="libraries_log_delete">
						<label for="delete-log">Delete</label>						
					</p>

					<input type="submit" value="Generate" class="submit-btn" />
				</div>
			</section>
		</article>
	</div>

	<article class="debug">
	</article>

	<script type="text/javascript" src="./javascript/reqwest.min.js"></script>
    <script type="text/javascript" src="./javascript/generate.js"></script>
</body>

</html>