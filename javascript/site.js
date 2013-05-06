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
  if ( time_ago.days > 2 )     return 'about ' + time_ago.days + ' days ago';
  if ( time_ago.hours > 24 )   return 'about a day ago';
  if ( time_ago.hours > 2 )    return 'about ' + time_ago.hours + ' hours ago';
  if ( time_ago.minutes > 45 ) return 'about an hour ago';
  if ( time_ago.minutes > 2 )  return 'about ' + time_ago.minutes + ' minutes ago';
  if ( time_ago.seconds > 1 )  return 'about ' + time_ago.seconds + ' seconds ago';
  return 'just now';
}

/* Commit Widget */
(function ($) {
    function widget(element, options, callback) {
        this.element = element;
        this.options = options;
        this.callback = $.isFunction(callback) ? callback : $.noop;
    }
 
    widget.prototype = (function() {

        function getCommits(user, repo, branch, callback) {
            $.ajax({
                url: "https://api.github.com/repos/" + user + "/" + repo + "/commits?sha=" + branch,
                dataType: 'jsonp',
                success: callback
            });
        }

        function _widgetRun(widget) {
            if (!widget.options) {
                widget.element.append('<span class="error">Options for widget are not set.</span>');
                return;
            }
            var callback = widget.callback;
            var element = widget.element;
            var user = widget.options.user;
            var repo = widget.options.repo;
            var branch = widget.options.branch;
            var avatarSize = widget.options.avatarSize || 20;
            var last = widget.options.last === undefined ? 0 : widget.options.last;
            var limitMessage = widget.options.limitMessageTo === undefined ? 0 : widget.options.limitMessageTo;

            element.append('<p>Loading commits...</p>');
            getCommits(user, repo, branch, function (data) {
                var commits = data.data;
                var totalCommits = (last < commits.length ? last : commits.length);

                element.empty();

                var list = $('<ul class="github-commits-list">').appendTo(element);
                for (var c = 0; c < totalCommits; c++) {
                    var commit = commits[c];
                    list.append(
                        '<li ' + itemClass(c, totalCommits) + ' >' +
                        ' ' + ((commit.author !== null) ? avatar(commit.author.gravatar_id, avatarSize) : '') +
                        ' ' + ((commit.author !== null) ? author(commit.author.login) : commit.commit.committer.name) +
                        ' committed ' + message(replaceHtmlTags(commit.commit.message), commit.sha) +
                        ' ' + when(commit.commit.committer.date) +
                        '</li>');
                }
                callback(element);

                function itemClass(current, totalCommits) {
                    if (current === 0) {
                        return 'class="first"';
                    } else if (current === totalCommits - 1) {
                        return 'class="last"';
                    }
                    return '';
                }

                function avatar(hash, size) {
                    return '<img class="github-avatar" src="http://www.gravatar.com/avatar/' + hash + '?s=' + size + '"/>';
                }

                function author(login) {
                    return '<div><a class="github-user" href="https://github.com/' + login + '">' + login + '</a>';
                }

                function message(commitMessage, sha) {
                    var originalCommitMessage = commitMessage;
                    if (limitMessage > 0 && commitMessage.length > limitMessage)
                    {
                        commitMessage = commitMessage.substr(0, limitMessage) + '...';
                    }
                    return '"' + '<a class="github-commit" title="' + originalCommitMessage + '" href="https://github.com/' + user + '/' + repo + '/commit/' + sha + '">' + commitMessage + '</a>"';
                }

                function replaceHtmlTags(message) {
                    return message.replace(/&/g, "&amp;")
                                    .replace(/>/g, "&gt;")
                                    .replace(/</g, "&lt;")
                                    .replace(/"/g, "&quot;");
                }

                function when(commitDate) {
                    var commitTime = new Date(commitDate).getTime();
                    var todayTime = new Date().getTime();

                    var differenceInDays = Math.floor(((todayTime - commitTime)/(24*3600*1000)));
                    if (differenceInDays === 0) {
                        var differenceInHours = Math.floor(((todayTime - commitTime)/(3600*1000)));
                        if (differenceInHours === 0) {
                            var differenceInMinutes = Math.floor(((todayTime - commitTime)/(600*1000)));
                            if (differenceInMinutes === 0) {

                                return 'just now';
                            }

                            return 'about ' + differenceInMinutes + ' minutes ago';
                        }

                        return 'about ' + differenceInHours + ' hours ago';
                    } else if (differenceInDays == 1) {
                        return 'yesterday';
                    }
                    return differenceInDays + ' days ago</div>';
                }
            });
        }

        return {
            run: function () {
                _widgetRun(this);
            }
        };

    })();

    $.fn.githubInfoWidget = function(options, callback) {
        this.each(function () {
            new widget($(this), options, callback)
                .run();
        });
        return this;
    };

})(jQuery);


$(function(){
	$(window).scroll(function(){
		if($(this).scrollTop() > 114){
			$('.navBar').addClass('stuck')
		} else {
			$('.navBar').removeClass('stuck')
		}
	})

	$.getJSON('/content/static/twitter/', function(data) {
		$.each(data, function(i, tweet) {
			var time 	   = parse_date(tweet.created_at);
			var timeText   = format_relative_time(extract_relative_time(time));

			var tweet_html = '<li><a class="perma" href="https://www.twitter.com/processingOrg/status/' + tweet.id_str + '">&infin;<\/a>';
			tweet_html 	  += '<div>'+tweet.text.parseURL().parseUsername().parseHashtag();
			tweet_html    += ' ';
			tweet_html    += timeText;
			tweet_html    += '<\/div><\/li>';

			$('.latest-tweets').append(tweet_html)
		})
	})

	$(".latest-commits").githubInfoWidget({ user: 'processing', repo: 'processing', branch: 'master', last: 4 });
  
});
