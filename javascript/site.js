/* jQuery Twitter */
(function($) {
	/*
		jquery.twitter.js v1.6
		Last updated: 16 October 2012

		Created by Damien du Toit
		http://coda.co.za/content/projects/jquery.twitter/

		Licensed under a Creative Commons Attribution-Non-Commercial 3.0 Unported License
		http://creativecommons.org/licenses/by-nc/3.0/
	*/

	$.fn.getTwitter = function(options) {

		$.fn.getTwitter.defaults = {
			userName: null,
			numTweets: 5,
			loaderText: "Loading tweets...",
			slideIn: true,
			slideDuration: 750,
			showHeading: true,
			headingText: "Latest Tweets",
			showProfileLink: true,
			showProfileImg: true,
			showTimestamp: true,
			includeRetweets: false,
			excludeReplies: true
		};

		var o = $.extend({}, $.fn.getTwitter.defaults, options);

		return this.each(function() {
			var c = $(this);

			// hide container element, remove alternative content, and add class
			c.hide().empty().addClass("twitted");

			// add heading to container element
			if (o.showHeading) {
				c.append("<h2>"+o.headingText+"</h2>");
			}

			// add twitter list to container element
			var twitterListHTML = "<ul id=\"twitter_update_list\"></ul>";
			c.append(twitterListHTML);

			var tl = $("#twitter_update_list");

			// hide twitter list
			tl.hide();

			// add preLoader to container element
			var preLoaderHTML = $("<p class=\"preLoader\">"+o.loaderText+"</p>");
			c.append(preLoaderHTML);

			// add Twitter profile link to container element
			if (o.showProfileLink) {
				var profileLinkHTML = "<p class=\"profileLink\"><a href=\"https://twitter.com/"+o.userName+"\">https://twitter.com/"+o.userName+"</a></p>";
				c.append(profileLinkHTML);
			}

			// if(o.showProfileImg){
			// 	var profileImgHTML = "<img"
			// }

			// show container element
			c.show();

			// request (o.numTweets + 20) to avoid not having enough tweets if includeRetweets = false and/or excludeReplies = true
			window.jsonTwitterFeed = "https://api.twitter.com/1/statuses/user_timeline.json?include_rts="+o.includeRetweets+"&excludeReplies="+o.excludeReplies+"&screen_name="+o.userName+"&count="+(o.numTweets + 20);

			$.ajax({
				url: jsonTwitterFeed,
				data: {},
				dataType: "jsonp",
				callbackParameter: "callback",
				timeout: 50000,
				success: function(data) {
					window.count = 0;

					$.each(data, function(key, val) {

						var tweetHTML = "<li><span>" + replaceURLWithHTMLLinks(val.text) + "</span>";



						if (o.showTimestamp) tweetHTML += " <a style=\"font-size:85%\" href=\"https://twitter.com/" + o.userName + "/statuses/" + val.id_str + "\">" + relative_time(val.created_at) + "</a>";
					
						tweetHTML += "</li>";

						$("#twitter_update_list").append(tweetHTML);

						count++;

						if (count == o.numTweets) {
							// remove preLoader from container element
							$(preLoaderHTML).remove();

							// show twitter list
							if (o.slideIn) {
								// a fix for the jQuery slide effect
								// Hat-tip: http://blog.pengoworks.com/index.cfm/2009/4/21/Fixing-jQuerys-slideDown-effect-ie-Jumpy-Animation
								var tlHeight = tl.data("originalHeight");
				
								// get the original height
								if (!tlHeight) {
									tlHeight = tl.show().height();
									tl.data("originalHeight", tlHeight);
									tl.hide().css({height: 0});
								}

								tl.show().animate({height: tlHeight}, o.slideDuration);
							}
							else {
								tl.show();
							}
				
							// add unique class to first list item
							tl.find("li:first").addClass("firstTweet");
				
							// add unique class to last list item
							tl.find("li:last").addClass("lastTweet");

							return false;
						}
					});
				},
				error: function(XHR, textStatus, errorThrown) {
					//alert("Error: " + textStatus);
					//alert("Error: " + errorThrown);
				}
			});
		});

		function replaceURLWithHTMLLinks(text) {
			var exp = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig;
			return text.replace(exp, "<a href=\"$1\">$1</a>");
		}

		// sourced from https://twitter.com/javascripts/blogger.js
		function relative_time(time_value) {
			var values = time_value.split(" ");
			time_value = values[1] + " " + values[2] + ", " + values[5] + " " + values[3];
			var parsed_date = Date.parse(time_value);
			var relative_to = (arguments.length > 1) ? arguments[1] : new Date();
			var delta = parseInt((relative_to.getTime() - parsed_date) / 1000);
			delta = delta + (relative_to.getTimezoneOffset() * 60);
			
			if (delta < 60) {
				return "less than a minute ago";
			}
			else if (delta < 120) {
				return "about a minute ago";
			}
			else if (delta < (60*60)) {
				return (parseInt(delta / 60)).toString() + " minutes ago";
			}
			else if (delta < (120*60)) {
				return "about an hour ago";
			}
			else if (delta < (24*60*60)) {
				return "about " + (parseInt(delta / 3600)).toString() + " hours ago";
			}
			else if (delta < (48*60*60)) {
				return "1 day ago";
			}
			else {
				return (parseInt(delta / 86400)).toString() + " days ago";
			}
		}
	};
})(jQuery);

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
                    return '<a class="github-user" href="https://github.com/' + login + '">' + login + '</a>';
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
                    return differenceInDays + ' days ago';
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

	// $(".latest-tweets").getTwitter({
	// 	userName: "processingOrg",
	// 	numTweets: 3,
	// 	loaderText: "Loading tweets...",
	// 	slideIn: false,
	// 	showHeading: false,
	// 	headingText: "Latest Tweets",
	// 	showProfileLink: false,
	// 	showTimestamp: true,
	// 	includeRetweets: false,
	// 	excludeReplies: true
	// });

	// $(".latest-commits").githubInfoWidget({ user: 'processing', repo: 'processing', branch: 'master', last: 5 });
  
});
