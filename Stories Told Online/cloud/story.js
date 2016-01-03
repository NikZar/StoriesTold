Parse.Cloud.define("toggleUserLovesStory", function(request, response) {
    // so we can leave posts ACL restricted to the creator
    Parse.Cloud.useMasterKey();
    var story;
    var storyId = request.params.storyId;
    var user = request.user;
    var query = new Parse.Query("Story");

    var relation = user.relation("loves");
    var storyQuery = relation.query();
    storyQuery.get(storyId, {
        success: function(story) {
            //already loves
            query.get(storyId).then(function(result) {
                story = result;
                story.increment("loveCount", -1);
                return story.save();
            }).then(function() {
                var relation = user.relation("loves");
                relation.remove(story);
                return user.save();
            }).then(function(result) {
                response.success(result);
            }, function(error) {
                response.error(error);
            });
        },
        error : function(story, error) {
            query.get(storyId).then(function(result) {
                story = result;
                story.increment("loveCount", 1);
                return story.save();
            }).then(function() {
                var relation = user.relation("loves");
                relation.add(story);
                return user.save();
            }).then(function(result) {
                response.success(result);
            }, function(error) {
                response.error(error);
            });
        }
    });
});
