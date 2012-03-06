var proxy;
var BASE_URL = '';
var hashParam;
var swf;

// get App-key
function wbSetAppInfo()
{
	console.log('{JS} wbSetAppInfo(), WB2._config.appkey = ' + WB2._config.appkey);
	//alert('{JS} wbSetAppInfo(), WB2._config.appkey = ' + WB2._config.appkey);
	swf.setInfo(WB2._config.appkey, WB2._config.secret);
}

// login
function wbLogin()
{
	console.log('{js} >>> try to login weibo...');
	// method 1
	WB2.login(function()
	{
		console.log('{js} >>> weibo login ^_____^');
		wbGetAccounts();
	});
}

// get account-info
function wbGetAccounts()
{
	if (WB2.checkLogin())
	{
		WB2.anyWhere(function(W){
			W.parseCMD("/account/verify_credentials.json",
				function(sResult, bStatus)
				{
					if (bStatus)
					{
						console.log('{js} >>> onGetAccounts() ' + sResult);
						swf.onLoginComplete(sResult);
					}
				},
			{},
			{method:'GET'});
		});
	}
	else
	{
		console.log('{js} >>> weibo login err. -_-;');
		swf.onLoginErr();
	}
}

// get friend-list
function wbGetFriends()
{
	WB2.anyWhere(function(W){
		W.parseCMD("/statuses/friends.json",
			function(sResult, bStatus)
			{
				if (bStatus)
				{
					console.log('{js} wbGetFriends ^______^');
					console.log(sResult);
					swf.onGetFriendsComplete(sResult);
				}
			},
		{},
		{method:'GET'});
	});
}

// repost test
function wbSubmitPost(txt)
{
	console.log('{js} wbSubmitPost txt = ' + txt);
	WB2.anyWhere(function(W){
		W.parseCMD("/statuses/update.json",
			function(sResult, bStatus)
			{
				if (bStatus)
				{
					console.log('{js} wbSubmitPost ^______^');
					console.log(sResult);
					swf.onPostComplete(sResult);
				}
			},
		{status:txt},
		{method:'POST'});
	});
}

// ________________________________________________
//                                              swf

function initSWF()
{
	swf = document.getElementById('primary');
	console.log('{JS} initSWF | swf = ' + swf);
	//alert('{JS} initSWF | swf = ' + swf);
}
