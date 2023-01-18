import 'package:inmans/a1/instagramAccounts/broadcast_server.dart';
import 'package:inmans/a1/instagramAccounts/server/ig_tv_server.dart';
import 'package:inmans/a1/instagramAccounts/server/interaction_server.dart';
import 'package:inmans/a1/instagramAccounts/server/post_share_server.dart';
import 'package:inmans/a1/instagramAccounts/server/reels_server.dart';
import 'package:inmans/a1/instagramAccounts/server/spam_server.dart';
import 'package:inmans/a1/instagramAccounts/server/story_server.dart';
import 'package:inmans/a1/instagramAccounts/video_share_server.dart';
/*

usersToFollow
postLikes
postComments
postSaves
multiUserDMs
singleUserDMs
commentLikes
reelsLikes
reelsComments
igTVLikes
igTVComments
liveBroadCastLikes
liveBroadCastComments
postShares
videoShares
storyShares
spams
suicideSpams
liveWatches

*/
Map interactionTypesData = {
  "usersToFollow": {
    "idCode": "accountID",
    "functionParam": 2,
    "function": InteractionServer.follow,
    "localTimeStampKey": "lastOperationTimeStamp_follow",
    "operationCountKey": "operationCount_follow",
    "limit": 200,
    "resultData": {
      "type": "follow",
      "timeStamp": "[TIMESTAMP]",
      "ghost": "[GHOST]",
      "operationData": {"accountID": "[FOLLOWEDUSERID]"}
    }
  },
  "postLikes": {
    "idCode": "mediaID",
    "functionParam": 2,
    "function": InteractionServer.like,
    "localTimeStampKey": "lastOperationTimeStamp_post_like",
    "operationCountKey": "operationCount_post_like",
    "limit": 4000,
    "resultData": {
      "type": "postLike",
      "timeStamp": "[TIMESTAMP]",
      "ghost": "[GHOST]",
      "operationData": {"mediaID": "[MEDIAID]"}
    }
  },
  "postComments": {
    "idCode": "mediaID",
    "function": InteractionServer.comment,
    "functionParam": 3,
    "textData": "commentsToMake",
    "localTimeStampKey": "lastOperationTimeStamp_post_comment",
    "operationCountKey": "operationCount_post_comment",
    "limit": 300,
    "resultData": {
      "type": "postComment",
      "timeStamp": "[TIMESTAMP]",
      "ghost": "[GHOST]",
      "operationData": {"mediaID": "[MEDIAID]", "text": "[COMMENTTEXT]"}
    }
  },
  "postSaves": {
    "idCode": "mediaID",
    "functionParam": 2,
    "function": InteractionServer.savePost,
    "localTimeStampKey": "lastOperationTimeStamp_post_save",
    "operationCountKey": "operationCount_post_save",
    "limit": 100,
    "resultData": {
      "type": "postSave",
      "timeStamp": "[TIMESTAMP]",
      "ghost": "[GHOST]",
      "operationData": {"mediaID": "[MEDIAID]"}
    }
  },
  "multiUserDMs": {
    "idCode": "accountID",
    "functionParam": 3,
    "textData": "texts",
    "accountData": "accountsToSend",
    "function": InteractionServer.DM,
    "localTimeStampKey": "lastOperationTimeStamp_multiUser_dm",
    "operationCountKey": "operationCount_multiUser_dm",
    "limit": 100,
    "resultData": {
      "type": "multiUserDM",
      "timeStamp": "[TIMESTAMP]",
      "ghost": "[GHOST]",
      "operationData": {"accountID": "[ACCOUNTID]", "text": "[DMTEXT]"}
    }
  },
  "singleUserDMs": {
    "idCode": "accountID",
    "functionParam": 3,
    "textData": "texts",
    "function": InteractionServer.DM,
    "localTimeStampKey": "lastOperationTimeStamp_singleUser_dm",
    "operationCountKey": "operationCount_singleUser_dm",
    "limit": 4000,
    "resultData": {
      "type": "singleUserDM",
      "timeStamp": "[TIMESTAMP]",
      "ghost": "[GHOST]",
      "operationData": {"accountID": "[ACCOUNTID]", "text": "[DMTEXT]"}
    }
  },
  "commentLikes": {
    "idCode": "commentID",
    "function": InteractionServer.likeComment,
    "functionParam": 2,
    "localTimeStampKey": "lastOperationTimeStamp_comment_like",
    "operationCountKey": "operationCount_comment_like",
    "limit": 4000,
    "resultData": {
      "type": "commentLike",
      "timeStamp": "[TIMESTAMP]",
      "ghost": "[GHOST]",
      "operationData": {"commentID": "[COMMENTID]"}
    }
  },
  "reelsLikes": {
    "idCode": "mediaID",
    "function": ReelsServer.reelsLike,
    "functionParam": 2,
    "localTimeStampKey": "lastOperationTimeStamp_reels_like",
    "operationCountKey": "operationCount_reels_like",
    "limit": 4000,
    "resultData": {
      "type": "reelsLike",
      "timeStamp": "[TIMESTAMP]",
      "ghost": "[GHOST]",
      "operationData": {"mediaID": "[MEDIAID]"}
    }
  },
  "reelsComments": {
    "idCode": "mediaID",
    "function": ReelsServer.reelsComment,
    "textData": "commentsToMake",
    "functionParam": 3,
    "localTimeStampKey": "lastOperationTimeStamp_reels_comment",
    "operationCountKey": "operationCount_reels_comment",
    "limit": 300,
    "resultData": {
      "type": "reelsComment",
      "timeStamp": "[TIMESTAMP]",
      "ghost": "[GHOST]",
      "operationData": {"mediaID": "[MEDIAID]", "text": "[COMMENTTEXT]"}
    }
  },
  "igTVLikes": {
    "idCode": "mediaID",
    "function": IGTVServer.igTVLike,
    "functionParam": 2,
    "localTimeStampKey": "lastOperationTimeStamp_igtv_like",
    "operationCountKey": "operationCount_igtv_like",
    "limit": 4000,
    "resultData": {
      "type": "igtvLike",
      "timeStamp": "[TIMESTAMP]",
      "ghost": "[GHOST]",
      "operationData": {"mediaID": "[MEDIAID]"}
    }
  },
  "igTVComments": {
    "idCode": "mediaID",
    "function": IGTVServer.igTVComment,
    "textData": "commentsToMake",
    "functionParam": 3,
    "localTimeStampKey": "lastOperationTimeStamp_igtv_comment",
    "operationCountKey": "operationCount_igtv_comment",
    "limit": 300,
    "resultData": {
      "type": "igtvComment",
      "timeStamp": "[TIMESTAMP]",
      "ghost": "[GHOST]",
      "operationData": {"mediaID": "[MEDIAID]", "text": "[COMMENTTEXT]"}
    }
  },
  "liveBroadCastLikes": {
    "idCode": "accountID",
    "functionParam": 2,
    "function": LiveBroadCastServer.like,
    "localTimeStampKey": "lastOperationTimeStamp_live_like",
    "operationCountKey": "operationCount_live_like",
    "limit": 4000,
    "resultData": {
      "type": "liveLike",
      "timeStamp": "[TIMESTAMP]",
      "ghost": "[GHOST]",
      "operationData": {"accountID": "[LIVEID]"}
    }
  },
  "liveBroadCastComments": {
    "idCode": "accountID",
    "functionParam": 3,
    "textData": "commentsToMake",
    "function": LiveBroadCastServer.comment,
    "localTimeStampKey": "lastOperationTimeStamp_live_comment",
    "operationCountKey": "operationCount_live_comment",
    "limit": 300,
    "resultData": {
      "type": "liveComment",
      "timeStamp": "[TIMESTAMP]",
      "ghost": "[GHOST]",
      "operationData": {"accountID": "[LIVEID]", "text": "[COMMENTTEXT]"}
    }
  },
  "postShares": {
    "idCode": "link",
    "textData": "caption",
    "function": ShareImagePostServer.sharePost,
    "functionParam": 3,
    "localTimeStampKey": "lastOperationTimeStamp_post_share",
    "operationCountKey": "operationCount_post_share",
    "limit": 5,
    "resultData": {
      "type": "postShare",
      "timeStamp": "[TIMESTAMP]",
      "ghost": "[GHOST]",
      "operationData": {
        "link": "[POSTLINK]",
        "text": "",
      }
    }
  },
  "videoShares": {
    "idCode": "link",
    "textData": "caption",
    "function": VideoShareServer.shareVideo,
    "functionParam": 3,
    "localTimeStampKey": "lastOperationTimeStamp_video_share",
    "operationCountKey": "operationCount_video_share",
    "limit": 5,
    "resultData": {
      "type": "videoShare",
      "timeStamp": "[TIMESTAMP]",
      "ghost": "[GHOST]",
      "operationData": {
        "link": "[POSTLINK]",
        "text": "",
      }
    }
  },
  "storyShares": {
    "idCode": "link",
    "textData": "caption",
    "function": StoryServer.uploadStoryVideo,
    "functionParam": 3,
    "localTimeStampKey": "lastOperationTimeStamp_story_share",
    "operationCountKey": "operationCount_story_share",
    "limit": 20,
    "resultData": {
      "type": "storyShare",
      "timeStamp": "[TIMESTAMP]",
      "ghost": "[GHOST]",
      "operationData": {
        "link": "[POSTLINK]",
        "text": "",
      }
    }
  },
  "spams": {
    "idCode": "accountID",
    "functionParam": 2,
    "function": SpamServer.spam,
    "localTimeStampKey": "lastOperationTimeStamp_spam",
    "operationCountKey": "operationCount_spam",
    "limit": 250,
    "resultData": {
      "type": "spam",
      "timeStamp": "[TIMESTAMP]",
      "ghost": "[GHOST]",
      "operationData": {"accountID": "[SPAMMEDUSERID]"}
    }
  },
  "suicideSpams": {
    "idCode": "accountID",
    "functionParam": 2,
    "function": SpamServer.suicideSpam,
    "localTimeStampKey": "lastOperationTimeStamp_suicideSpam",
    "operationCountKey": "operationCount_suicideSpam",
    "limit": 250,
    "resultData": {
      "type": "suicideSpam",
      "timeStamp": "[TIMESTAMP]",
      "ghost": "[GHOST]",
      "operationData": {"accountID": "[SPAMMEDUSERID]"}
    }
  },
  "liveWatches": {
    "idCode": "liveID",
    "functionParam": 2,
    "function": LiveBroadCastServer.watch,
    "localTimeStampKey": "lastOperationTimeStamp_liveWatch",
    "operationCountKey": "operationCount_liveWatch",
    "limit": 200,
    "resultData": {
      "type": "liveWatch",
      "timeStamp": "[TIMESTAMP]",
      "ghost": "[GHOST]",
      "operationData": {"liveID": "[WATCHEDLIVEID]"}
    }
  },
};
