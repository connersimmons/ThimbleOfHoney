// Use Parse.Cloud.define to define as many cloud functions as you want.

var xmlreader = require('cloud/xmlreader.js');
 
var url = "http://thimbleofhoney.com/rss";
 
function SavePost(title, link){
	var PostClass = Parse.Object.extend("Post");
	var post = new PostClass();
	post.set("title", title);
	post.set("link", link);
	post.save();
}
 
function SendPush(title, link){
	var query = new Parse.Query(Parse.Installation);
	Parse.Push.send({
		where: query,
		data: {
			url: link,
			alert: title,
			sound: "default"
			}
		}, {
			success: function() {
				SavePost(title, link);
				response.success("Push sent to everyone");
			},
			error: function(error) {
				response.error("Error sending push: "+error);
			}
		});
}
 
Parse.Cloud.job("fetchPosts", function(request, response) {
	Parse.Cloud.httpRequest({
		url: url,
		success: function(httpResponse) {
			xmlreader.read(httpResponse.text, function (err, res){
				var newPost = res.feed.entry.at(0);
				var title = newPost.title.text();
				var link = "";
				newPost.link.each(function (i, linkObj){
					if (linkObj.attributes().rel == "alternate"){
						link = linkObj.attributes().href;
					}
				});
				
				var PostClass = Parse.Object.extend("Post");
				var query = new Parse.Query(PostClass);
				query.equalTo("link", link);
				query.find({
					success: function(results) {
						console.log(results);
						if (results.length == 0){
							SendPush(title, link);
						} else {
							response.error("Post already pushed");
						}
					}
				});
			});
			
		},
		error: function(httpResponse) {
			console.error('Request failed with response code ' + httpResponse.status);
			response.error("Error fetching posts from feed");
		}
	});
});