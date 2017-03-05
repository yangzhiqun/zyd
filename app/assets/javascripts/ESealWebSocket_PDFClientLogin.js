/*--------------------------------------------------------------------------  
 *
 * BJCA Adaptive Javascript, Version 2.12
 * This script is compatible with XTXSvr XTXAppCOM BJCASecCOMV2 BJCASecCOM
 * Load COM order by XTXSvr XTXAppCOM BJCASecCOMV2 BJCASecCOM
 * call XTXSvr browser must supports webSocket
 * if browser supports webSocket and XTXSvr work well, call XTXSvr.
 * otherwise, call ActiveX COM XTXAppCOM BJCASecCOMV2 BJCASecCOM
 * Author:BJCA-zys
 *--------------------------------------------------------------------------*/
 
//gloal variant for clientSignByHash function 
//var jsonStr = null;
//var digestMessageArray = null; // 定义一个digestMessages数组
//var cur_Sign_index = 0;

var $_$WebSocketConnectState = false;
var $_$XTXAlert = null;     				// alert custom function
var $_$PDFClientLogin_AppObj = null;    	// PDFClientLogin class Object
var $_$PDFClientLogin_WebSocketObj = null; 	// WebSocket class Object
var $_$ClientSign_PDFClientLogin = null;   	// Current use class Object
	

/**
 * 调用客户端KEY对PDF签章服务器返回的内容进行签名，并返回签名处理后的数据（JSON格式）
 * @param json PDF签章服务器返回的包含哈希值的json
 * @param cur_cert_id 客户端KEY证书唯一标示
 * @param passwd 证书密码
 * @param retdata_ID 返回签章数据的元素ID
 * @callback cb callback(digestMessages)
 */
function clientSignByHash(json, cur_cert_id, passwd, retdata_ID, cb) {
	if(json == "" || cur_cert_id == "") {
		alert("input error!");
		return;
	}
	
	if (!$checkBrowserISIE()) {
		if(passwd == "") {	
			alert("input passwd!");
			return;
		}
	}
	
	var jsonStr = null;
	var jsonStr = json;
	var jsonObj = $.parseJSON(jsonStr); // parseJSON 将字符串转为json对象
	

	var digestMessageArray = null;
	digestMessageArray = new Array();
	var cur_Sign_index = 0;
	
	//var digestMessageArray = new Array(); // 定义一个digestMessages数组
	for(var i = 0; i < jsonObj.digestMessages.length; i++){
		var digestMessage = {}; // 定义digestMessage对象
		digestMessage.signUniqueId = jsonObj.digestMessages[i].signUniqueId;
		digestMessage.fileUniqueId = jsonObj.digestMessages[i].fileUniqueId;
		digestMessageArray[i] = digestMessage;
		ESeaL_SignHashData(cur_cert_id,  passwd, jsonObj.digestMessages[i].hashData,function(ret){
			if(ret.retVal == "") {
				alert("KEY密码错误");
				return;
			}
			digestMessageArray[cur_Sign_index].clientSignData = ret.retVal;
			cur_Sign_index++;
			if(cur_Sign_index == jsonObj.digestMessages.length) {
				// all sign ok;
				var digestMessages = {};
				digestMessages.digestMessages = digestMessageArray;
				if(retdata_ID) {
					$(retdata_ID).val($.toJSON(digestMessages));
				}
				
				if(cb) {
					cb($.toJSON(digestMessages));
				}
			}
		});					
	}
}

//export user signature cert
function ESeaL_GetUserCert(strCertID, cb) {
	ctx = null;
	
	if(!$checkBrowserISIE() && (!$_$WebSocketConnectState)) {
		alert("WebSocket connect error!");
		return;
	}
	
	if ($_$ClientSign_PDFClientLogin != null) {
		return $_$ClientSign_PDFClientLogin.ESeaL_GetUserCert(strCertID, cb, ctx);
	} else {
        return $myErrorRtnFunc("", cb, ctx);
	}
}

//export user stamp
function ESeaL_GetStampPic(strCertID, cb) {
	ctx = null;
	
	if(!$checkBrowserISIE() && (!$_$WebSocketConnectState)) {
		alert("WebSocket connect error!");
		return;
	}
	
	if ($_$ClientSign_PDFClientLogin != null) {
		return $_$ClientSign_PDFClientLogin.ESeaL_GetStampPic(strCertID, cb, ctx);
	} else {
        return $myErrorRtnFunc("", cb, ctx);
	}
}

//sign hash data
function ESeaL_SignHashData(strCertID, passwd, hashdata, cb) {
	ctx = null;
	
	if(!$checkBrowserISIE() && (!$_$WebSocketConnectState)) {
		alert("WebSocket connect error!");
		return;
	}
	
	if ($_$ClientSign_PDFClientLogin != null) {
		return $_$ClientSign_PDFClientLogin.ESeaL_SignHashData(strCertID,  passwd, hashdata, cb, ctx);
	} else {
        return $myErrorRtnFunc("", cb, ctx);
	}	
}


function $XTXAlert(strMsg) {
	if (typeof $_$XTXAlert == 'function') {
		$_$XTXAlert(strMsg);
	} else {
		alert(strMsg);
	}	
}

function $myOKRtnFunc(retVal, cb, ctx)
{
    if (typeof cb == 'function') {
        var retObj = {retVal:retVal, ctx:ctx};
        cb(retObj);
    } 
    return retVal;
}

//PDFClientLogin class
function CreateAppObject_PDFClientLogin() {	
	var bOK = $LoadControl("A9A51080-2FC6-40D0-9491-7E641F39C70D", "PDFClientLogin", null);
	if (!bOK) {
		return null;
	}	
	
	var o = new Object();
	
	//export user signature cert
	o.ESeaL_GetUserCert = function(strCertID, cb, ctx) {
		var ret;
		ret = PDFClientLogin.GetUserCert(strCertID);
		return $myOKRtnFunc(ret, cb, ctx);
	}
	
	//export user stamp
	o.ESeaL_GetStampPic  = function(strCertID, cb, ctx) {
		var ret;
		ret = PDFClientLogin.GetUserEseal(strCertID);
		return $myOKRtnFunc(ret, cb, ctx);
	}
	
	o.ESeaL_SignHashData  = function(strCertID,  passwd, hashdata, cb, ctx) {
		var ret;
		ret = PDFClientLogin.Sign(strCertID, hashdata);
		return $myOKRtnFunc(ret, cb, ctx);
	}
	
	return o;
}

//webSocket client class
function CreateWebSocketObject_PDFClient() {
	
	var o = new Object();
    
    o.ws_host = "ws://127.0.0.1:";
    o.ws_port_array = ["4114", "5114", "6114", "7114", "8114"]; 

    o.ws_port_use = 0;
    o.ws_obj = null;
    o.ws_heartbeat_id = 0;
    o.ws_queue_id = 0; // call_cmd_id
    o.ws_queue_list = {};  // call_cmd_id callback queue
    o.ws_queue_ctx = {};
    o.xtx_version = "";
    
    o.load_websocket = function() {
        if (o.ws_port_use > o.ws_port_array.length) {
            o.ws_port_use = 0;
            return false;
        }
        
        var ws_url = o.ws_host + o.ws_port_array[o.ws_port_use] + "/";
        try {
            o.ws_obj = new WebSocket(ws_url); 
        } catch (e) {
            console.log(e);
            return false;
        }
        
        
        o.ws_obj.onopen = function(evt) { 
            clearInterval(o.ws_heartbeat_id);
            o.callMethod("ESeaL_GetGetVersion", function(str){o.xtx_version = str.retVal;});
            o.ws_heartbeat_id = setInterval(function () {
                o.callMethod("ESeaL_GetGetVersion", function(str){});
            }, 10 * 1000);
			
			$_$WebSocketConnectState = true;
        }; 
        
        o.ws_obj.onclose = function(evt) { 
        
		}; 
        
        o.ws_obj.onmessage = function(evt) { 
            var res = JSON.parse(evt.data);  
            if (typeof(res['call_cmd_id']) != 'undefined' && typeof(o.ws_queue_list[res['call_cmd_id']]) == 'function') {
                var execFunc = o.ws_queue_list[res['call_cmd_id']];
                var ctx = o.ws_queue_ctx[res['call_cmd_id']];
                ctx = ctx || {returnType:"string"};
                var ret;
                if (typeof ctx.returnType == 'string') {
                    if (ctx.returnType == "bool") {
                        ret = res.retVal == "true" ? true : false;
                    } else if (ctx.returnType == "number") {
                        ret = Number(res.retVal);
                    } else {
                        ret = res.retVal;
                    }     
                } else {
                    ret = res.retVal;
                }
                var retObj = {retVal:ret, ctx:ctx};
                execFunc(retObj);
                if (res['call_cmd_id'] != "onUsbkeyChange") {
                    delete o.ws_queue_list[res['call_cmd_id']];
                }
                delete o.ws_queue_ctx[res['call_cmd_id']];
            }
        }; 
        
        o.ws_obj.onerror = function(evt) { 
            o.ws_port_use++;
			if(o.ws_port_use == 5) 
				return null;
			
            o.load_websocket();
        };
        
        return true;
	};
    
    o.sendMessage = function(sendMsg) {
        if (o.ws_obj.readyState == WebSocket.OPEN) {
            o.ws_obj.send(JSON.stringify(sendMsg));
        } else {
            console.log("Can't connect to WebSocket server!");
        }
    };
    
    o.callMethod = function(strMethodName, cb, ctx, returnType, argsArray) {
        o.ws_queue_id++;
        if (typeof(cb) == 'function'){
            o.ws_queue_list['i_' + o.ws_queue_id] = cb;
            ctx = ctx || {};
            ctx.returnType = returnType;           
            o.ws_queue_ctx['i_' + o.ws_queue_id] = ctx;
        }
        
        var sendArray = {};
        sendArray['xtx_func_name'] = strMethodName;
        sendArray['call_cmd_id'] = 'i_' + o.ws_queue_id ;
        /*
		if (o.xtx_version >= "2.14") {
            sendArray['URL'] = window.location.href;
        }
        */
        if (arguments.length > 4) {
            for (var i = 1; i <= argsArray.length; i++) {
                var strParam = "param_" + i;
                sendArray[strParam] = argsArray[i - 1];
            }
        }
        
        if (o.ws_obj.readyState == WebSocket.OPEN) {
            o.sendMessage(sendArray)
        } else if (o.ws_obj.readyState != WebSocket.OPEN && o.ws_obj.readyState != WebSocket.CONNECTING) {
            o.load_websocket();
            setTimeout(o.sendMessage(sendArray), 500);
        }
    };

	//export user signature cert
	o.ESeaL_GetUserCert = function(strCertID, cb, ctx) {
		var paramArray = [strCertID];
		ctx = null;
		returnType = null;
		o.callMethod('ESeaL_GetUserCert', cb, ctx, returnType, paramArray);
	}
	
	//export user stamp
	o.ESeaL_GetStampPic = function(strCertID, cb, ctx) {
		var paramArray = [strCertID];
		ctx = null;
		returnType = null;
		o.callMethod('ESeaL_GetStampPic', cb, ctx, returnType, paramArray);
	}
	
    o.ESeaL_SignHashData  = function(strCertID,  passwd, hashdata, cb, ctx) {
		var paramArray = [strCertID, passwd, hashdata];
		ctx = null;
		returnType = null;
		o.callMethod('ESeaL_SignHashData', cb, ctx, returnType, paramArray);
	}
	
    if (!o.load_websocket()) {
        return null;
    }
    
	return o;
}

//load a control
function $LoadControl(CLSID, ctlName, testFuncName) 
{
	var pluginDiv = document.getElementById("pluginDiv" + ctlName);
	if (pluginDiv) {
		return true;
	}
	pluginDiv = document.createElement("div");
	pluginDiv.id = "pluginDiv" + ctlName;
	document.body.appendChild(pluginDiv);
	
	try {	
		if ($checkBrowserISIE()) {	// IE
			pluginDiv.innerHTML = '<object id="' + ctlName + '" classid="CLSID:' + CLSID + '" codebase="./scripts/PDFSeal.cab" style="HEIGHT:0px; WIDTH:0px"></object>';
			
		} else {
			// not use activeX control except ie browser.
			document.body.removeChild(pluginDiv);
			pluginDiv.innerHTML = "";
			pluginDiv = null;
			return false;
			/*
            var chromeVersion = window.navigator.userAgent.match(/Chrome\/(\d+)\./);
            if (chromeVersion && chromeVersion[1]) 
			{
                if (parseInt(chromeVersion[1], 10) >= 42) { // not support npapi return false
                    document.body.removeChild(pluginDiv);
                    pluginDiv.innerHTML = "";
                    pluginDiv = null;
                    return false;
                }
            }
			*/

			{
				pluginDiv.innerHTML = '<embed id=' + ctlName + ' type=application/x-xtx-axhost clsid={' + CLSID + '} width=0 height=0 />' ;
			}	
		}
		
		if (testFuncName != null && testFuncName != "" && eval(ctlName + "." + testFuncName) == undefined) {
            document.body.removeChild(pluginDiv);
            pluginDiv.innerHTML = "";
            pluginDiv = null;
            return false; 
		}
		return true;
	} catch (e) {
		document.body.removeChild(pluginDiv);
		pluginDiv.innerHTML = "";
		pluginDiv = null;
		return false;
	}
}

function $checkBrowserISIE() 
{
	return (!!window.ActiveXObject || 'ActiveXObject' in window) ? true : false;
}

(function() {
    $_$PDFClientLogin_AppObj = CreateAppObject_PDFClientLogin();
	if ($_$PDFClientLogin_AppObj != null) {
		$_$ClientSign_PDFClientLogin = $_$PDFClientLogin_AppObj;
		return;
	}
		
    $_$PDFClientLogin_WebSocketObj = CreateWebSocketObject_PDFClient();
    if ($_$PDFClientLogin_WebSocketObj != null) {
		$_$ClientSign_PDFClientLogin = $_$PDFClientLogin_WebSocketObj;
		return;
	}
    
    $_$ClientSign_PDFClientLogin = null;
	
	//$XTXAlert("检查签章核心服务出错!");
	alert("err");
	return;
})(); 
