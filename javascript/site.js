/* Twitter Parsing Functions */
String.prototype.parseUsername = function() {
	return this.replace(/[@]+[A-Za-z0-9-_]+/g, function(u) {
		var username = u.replace("@","")
		return u.link("http://twitter.com/"+username);
	});
};
String.prototype.parseHashtag = function() {
	return this.replace(/[#]+[A-Za-z0-9-_]+/g, function(t) {
		var tag = t.replace("#","%23")
		return t.link("http://search.twitter.com/search?q="+tag);
	});
};
String.prototype.parseURL = function() {
	return this.replace(/[A-Za-z]+:\/\/[A-Za-z0-9-_]+\.[A-Za-z0-9-_:%&~\?\/.=]+/g, function(url) {
		return url.link(url);
	});
};

/* Time Parsing */
function parse_date(date_str) {
	return Date.parse(date_str.replace(/^([a-z]{3})( [a-z]{3} \d\d?)(.*)( \d{4})$/i, '$1,$2$4$3'));
}
function extract_relative_time(date) {
	var toInt = function(val) { return parseInt(val, 10); };
	var relative_to = new Date();
	var delta = toInt((relative_to.getTime() - date) / 1000);
	if (delta < 1) delta = 0;
	return {
		days:    toInt(delta / 86400),
		hours:   toInt(delta / 3600),
		minutes: toInt(delta / 60),
		seconds: toInt(delta)
	};
}
function format_relative_time(time_ago) {
	if ( time_ago.days > 2 )     return ' ' + time_ago.days + ' days ago';
	if ( time_ago.hours > 24 )   return ' a day ago';
	if ( time_ago.hours > 2 )    return ' ' + time_ago.hours + ' hours ago';
	if ( time_ago.minutes > 45 ) return ' an hour ago';
	if ( time_ago.minutes > 2 )  return ' ' + time_ago.minutes + ' minutes ago';
	if ( time_ago.seconds > 1 )  return ' ' + time_ago.seconds + ' seconds ago';
	return 'just now';
}

$(function(){
	$(window).scroll(function(){
		if($(this).scrollTop() > 114){
			$('.navBar').addClass('stuck')
		} else {
			$('.navBar').removeClass('stuck')
		}
	})

	// recent tweets
	$.getJSON('/content/static/feeds/twitter.php', function(data) {
		$.each(data, function(i, tweet) {
			var time 	   = parse_date(tweet.created_at);
			var timeText   = format_relative_time(extract_relative_time(time));

			var tweet_html = '<li><div>'+tweet.text.parseURL().parseUsername().parseHashtag();
			tweet_html    += ' about';
			tweet_html    += '<a href="https://www.twitter.com/processingOrg/status/' + tweet.id_str + '">' + timeText + '<\/a>';
			tweet_html    += '<\/div><\/li>';

			$('.latest-tweets').append(tweet_html)
		})
	})

	// recent commits
	$.getJSON('/content/static/feeds/github.php', function(data) {
		$.each(data, function(i, commit) {
			if(i<=3){
				var time 	   = parse_date(commit.commit.committer.date);
				var timeText   = format_relative_time(extract_relative_time(time));

				var commit_html = '<li><img class="github-avatar" src="http://www.gravatar.com/avatar/' + commit.author.gravatar_id + '?s=20"/>';
				commit_html    += '<div><a href="' + commit.author.html_url + '">' + commit.author.login + '<\/a> commited';
				commit_html    += ' <a href="https://github.com/processing/processing/commit/' + commit.sha + '">"' + commit.commit.message + '"<\/a>';
				commit_html    += ' about ' + timeText + '<\/div>';

				$('.latest-commits').append(commit_html)
			}
		})
	})
  
});
