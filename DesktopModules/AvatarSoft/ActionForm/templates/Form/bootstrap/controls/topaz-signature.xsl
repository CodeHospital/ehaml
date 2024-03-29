﻿<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:utils="af:utils">

    <xsl:import href="attr-common.xsl"/>
    <xsl:import href="attr-container.xsl"/>
    <xsl:import href="label.xsl"/>
    <xsl:output method="html" indent="no" omit-xml-declaration="yes" />

    <xsl:template match="/Form/Fields/Field[InputType = 'topaz-signature']">
        <xsl:call-template name="ctl-topaz-signature" />
    </xsl:template>

    <xsl:template name="ctl-topaz-signature">
        <xsl:param name="addClass"></xsl:param>
        <!--<script src="://localhost:47289/SigGetScript/SigWeb.js"  type="text/javascript"></script>-->
        <script type="text/javascript">

            <![CDATA[

		baseUri = "http://localhost:47289/";
		var tmr;

      	$(document).ready( function(){

           // Get the canvas context
           var c = $('#cnvTopaz');
           var ct = c.get(0).getContext('2d');
           var container = $(c).parent();
           var formRoot = c.closest('.form-root');
           
           formRoot[0].onFormSubmit = formRoot[0].onFormSubmit || [];
           formRoot[0].onFormSubmit.push(function() { 
            	if (NumberOfTabletPoints() == 0) {
                   alert("Please sign before continuing");
               }
               else {
                   SetTabletState(0);
                   SetSigCompressionMode(1);
                   GetSigString();                    ]]>
            <xsl:text>var fieldName='</xsl:text>
            <xsl:value-of select="/Form/Settings/BaseId"/>
            <xsl:value-of select="Name" />
            <xsl:text>';</xsl:text>       <![CDATA[  
      				SetImagePenWidth(5);
      				SetImageXSize(c.width());
		      		SetImageYSize(c.height());

                   	GetSigImageB64(function(str) {
                      formRoot.find('[name='+fieldName+']').val(str);
                      formRoot[0].toUpload--;
                       if (formRoot[0].toUpload == 0)
                            formRoot[0].submitData(formRoot[0].$btn);
                      //angular.element(formRoot).scope().form.fields[fieldName].value = str;
                   });
               }
           });
           
           //Run function when browser resizes
           //  $(window).resize( respondCanvas );

           	function respondCanvas(){
	           c.attr('width', $(container).width() ); //max width
	           c.attr('height', $(container).height() ); //max height
	           SetDisplayXSize($(container).width());
	           SetDisplayYSize($(container).height());

	           //Call a function to redraw other content (texts, images etc)
           	}
        	respondCanvas();

       		//Initial call
         	ResetParameters();
       		onSignTopazSignature();

       }); // end document.ready


       function onSignTopazSignature() {
           SetJustifyMode(0);
           KeyPadClearHotSpotList();
           ClearSigWindow(1);
           ClearTablet();
           SetTabletState(1);

           var ctx = document.getElementById('cnvTopaz').getContext('2d');
           SigWebSetDisplayTarget(ctx);
           tmr = setInterval(SigWebRefresh, 50);
       }

       function onClearTopazSignature() {
	       ClearTablet();
	       if (sigObj.NumberOfTabletPoints() > 0)
	       		onClearTopazSignature();
       }




//var baseUri = "https://localhost:47289/";
//		var baseUri = "http://swdev2.lightautomation.com:47289/";

function SigWebcreateXHR() {
    try { return new XMLHttpRequest(); } catch (e) { }
    try { return new ActiveXObject("Msxml2.XMLHTTP.6.0"); } catch (e) { }
    try { return new ActiveXObject("Msxml2.XMLHTTP.3.0"); } catch (e) { }
    try { return new ActiveXObject("Msxml2.XMLHTTP"); } catch (e) { }
    try { return new ActiveXObject("Microsoft.XMLHTTP"); } catch (e) { }

    alert("XMLHttpRequest not supported");
    return null;
}

var Count = false;



function SigWebSetProperty(prop) {
    var xhr = SigWebcreateXHR();

    if (xhr) {
        xhr.open("POST", baseUri + prop, false);
        xhr.send(null);
        if (xhr.readyState == 4 && xhr.status == 200) {
            return xhr.responseText;
        }
    }
    return "";
}


function SigWebSetStreamProperty(prop, strm) {
    var xhr = SigWebcreateXHR();

    if (xhr) {
        xhr.open("POST", baseUri + prop, false);
        xhr.setRequestHeader("Content-Type", "text/plain");
        xhr.send(strm);
        if (xhr.readyState == 4 && xhr.status == 200) {
            return xhr.responseText;
        }
    }
    return "";
}

function SigWebSetImageStreamProperty(prop, strm) {
    var xhr = SigWebcreateXHR();

    if (xhr) {
        xhr.open("POST", baseUri + prop, false);
        xhr.setRequestHeader("Content-Type", "image/png");
        xhr.send(strm);
        if (xhr.readyState == 4 && xhr.status == 200) {
            return xhr.responseText;
        }
    }
    return "";
}

function SigWebSetImageBlobProperty(prop, strm) {
    var xhr = SigWebcreateXHR();

    //			var bb = new BlobBuilder();
    //			bb.append( strm );
    //			bb.append( "\0" );
    //			var blob = bb.getBlob( );

    if (xhr) {
        xhr.open("POST", baseUri + prop, false);
        xhr.setRequestHeader("Content-Type", "blob");
        xhr.send(strm);
        if (xhr.readyState == 4 && xhr.status == 200) {
            return xhr.responseText;
        }
    }
    return "";
}

function SigWebGetProperty(prop) {
    var xhr = SigWebcreateXHR();

    if (xhr) {
        xhr.open("GET", baseUri + prop, false);
        xhr.send(null);
        if (xhr.readyState == 4 && xhr.status == 200) {
            return xhr.responseText;
        }
    }
    return "";
}



var SigImageB64;


function GetSigImageB64(callback) {
    var cvs = document.createElement('canvas');
    cvs.width = GetImageXSize();
    cvs.height = GetImageYSize();

    var xhr2 = new XMLHttpRequest();
    xhr2.open("GET", baseUri + "SigImage/1", true);
    xhr2.responseType = "blob";
    xhr2.send(null);
    xhr2.onload = function () {
        var cntx = cvs.getContext('2d');
        var img = new Image();
        img.src = window.URL.createObjectURL(xhr2.response);
        img.onload = function () {
            cntx.drawImage(img, 0, 0);
            var b64String = cvs.toDataURL("image/png");
            var loc = b64String.search("base64,");
            var retstring = b64String.slice(loc + 7, b64String.length);
            if (callback) {
                callback(retstring);
            }
        }
    }
}





function SigWebWaitForPenDown(callback) {
    var xhr = SigWebcreateXHR();

    if (xhr) {
        xhr.open("GET", baseUri + "WaitForPenDown");
        xhr.timeout = 10000;
        xhr.onreadystatechange = function () {
            if (xhr.readyState != 4)
                return;
            if (xhr.status == 200)
                callback();
        }
        xhr.send(null);
    }
}


var Ctx;
var EvStatus;
var onSigPenDown;
var onSigPenUp;

function SigWebSetDisplayTarget(obj) {
    Ctx = obj;
}


function SigWebRefresh() {
    var OldEvStatus = EvStatus;
    EvStatus = SigWebGetProperty("EventStatus");
    if ((OldEvStatus & 0x01) && (EvStatus & 0x02)) {
        if (onSigPenDown) {
            onSigPenDown();
        }
    }

    if ((OldEvStatus & 0x02) && (EvStatus & 0x01)) {
        if (onSigPenUp) {
            onSigPenUp();
        }
    }



    var xhr2 = new XMLHttpRequest();
    xhr2.open("GET", baseUri + "SigImage/0", true);
    xhr2.responseType = "blob"
    xhr2.send(null);
    xhr2.onload = function () {
        var img = new Image();
        img.src = window.URL.createObjectURL(xhr2.response);
        img.onload = function () {
            Ctx.drawImage(img, 0, 0);
        }
    }
}



var SigWebFontThreshold = 200;

function setSigWebFontThreshold(v) {
    SigWebFontThreshold = v;
}



function createLcdBitmapFromCanvas(ourCanvas, xp, yp, width, height) {
    var canvasCtx = ourCanvas.getContext('2d');
    var imgData = canvasCtx.getImageData(0, 0, width, height);
    var j = 0;
    var sVal = 0;
    var outData = "";
    var outIdx = 0;
    var data = imgData.data;

    for (var y = 0; y < height; y++)
        for (var x = 0; x < width; x++) {
            var tmp1 = data[j];
            var tmp2 = data[j + 1];
            var tmp3 = data[j + 2];
            var tmp4 = data[j + 3];

            //					sVal = tmp1 + (tmp2 << 8 ) + ( tmp3 << 16 ) + (tmp4 << 24 );
            j = j + 4;
            if (tmp1 < SigWebFontThreshold) {
                outData += "B";
            }
            else {
                outData += "W";
            }
        }

    return outData;
}


function toHex(NibVal) {
    switch (NibVal) {
        case 0:
            return "0";
        case 1:
            return "1";
        case 2:
            return "2";
        case 3:
            return "3";
        case 4:
            return "4";
        case 5:
            return "5";
        case 6:
            return "6";
        case 7:
            return "7";
        case 8:
            return "8";
        case 9:
            return "9";
        case 10:
            return "A";
        case 11:
            return "B";
        case 12:
            return "C";
        case 13:
            return "D";
        case 14:
            return "E";
        case 15:
            return "F";
    }
}

function ToHexString(ByteVal) {
    var Str = "";
    Str += toHex((ByteVal >> 4) & 0x0f);
    Str += toHex(ByteVal & 0x0F);
    return Str
}





function textToTablet(x, y, height, str, fnt) {
    var c = document.createElement('canvas');
    var cntx = c.getContext('2d');
    cntx.font = fnt;
    var txt = str;
    var xs = Math.round(cntx.measureText(txt).width);
    var ys = height;
    c.width = xs;
    c.height = ys;

    cntx.font = fnt;
    cntx.fillStyle = '#FFFFFF'
    cntx.rect(0, 0, xs, ys);
    cntx.fill();


    cntx.fillStyle = '#000000'
    cntx.textBaseline = "top";
    cntx.fillText(txt, 0, 0);

    cntx.drawImage(cntx.canvas, 0, 0, xs, ys);

    var Gstr = createLcdBitmapFromCanvas(c, 0, 0, xs, ys)

    LcdWriteImageStream(0, 2, x, y, xs, ys, Gstr);
}

function LcdWriteImage(Dst, Mode, Xp, Yp, Url) {
    var Prop = "LcdWriteImage/";
    var NewUrl = Url.replace(/\//g, "_");

    Prop = Prop + Dst + "," + Mode + "," + Xp + "," + Yp + "," + NewUrl;
    SigWebSetProperty(Prop);
}

function LcdWriteLocalImage(Dst, Mode, Xp, Yp, Url) {
    var Prop = "LcdWriteImage/";

    Prop = Prop + Dst + "," + Mode + "," + Xp + "," + Yp + "," + Url;
    SigWebSetProperty(Prop);
}

function LcdWriteImageStream(Dst, Mode, Xp, Yp, Xs, Ys, Url) {
    var Prop = "LcdWriteImageStream/";

    Prop = Prop + Dst + "," + Mode + "," + Xp + "," + Yp + "," + Xs + "," + Ys;
    SigWebSetImageStreamProperty(Prop, Url);
}

function LcdWriteImageBlob(Dst, Mode, Xp, Yp, Xs, Ys, Url) {
    var Prop = "LcdWriteImageStream/";

    Prop = Prop + Dst + "," + Mode + "," + Xp + "," + Yp + "," + Xs + "," + Ys;
    SigWebSetImageBlobProperty(Prop, Url);
}



function measureText(pText, pFontSize, pStyle) {
    var lDiv = document.createElement('lDiv');

    document.body.appendChild(lDiv);

    if (pStyle != null) {
        lDiv.style = pStyle;
    }
    lDiv.style.fontSize = "" + pFontSize + "px";
    lDiv.style.position = "absolute";
    lDiv.style.left = -1000;
    lDiv.style.top = -1000;

    lDiv.innerHTML = pText;

    var lResult =
        {
            width: lDiv.clientWidth,
            height: lDiv.clientHeight
        };

    document.body.removeChild(lDiv);
    lDiv = null;

    return lResult;
}

//
//
//
//
//
//
//			Start of dll method wrappers
//
//
//			SigPlusNET.cs
//
function GetVersionString() {
    var Prop = "Version";

    Prop = Prop;
    var Str = SigWebGetProperty(Prop);
    var trimStr = Str.slice(1, Str.length - 2);
    return trimStr;
}


function IsPenDown() {
    return EvStatus & 0x01;
}


//
//			SigPlusNETSig.cs
//
function ClearTablet() {
    var Prop = "ClearSignature";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function NumberOfTabletPoints() {
    var Prop = "TotalPoints";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

//		function  ExportSigFile(  FileName ) {}
//		function  ImportSigFile(  FileName ) {}

function SetSigString(sigStr) {
    var Prop = "SigString";

    Prop = Prop;
    SigWebSetStreamProperty(Prop, sigStr);
}



function GetSigString() {
    var Prop = "SigString";

    Prop = Prop;
    var Str = SigWebGetProperty(Prop);

    return Str.slice(1, Str.length - 1);
}



function SetSigCompressionMode(v) {
    var Prop = "CompressionMode/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}


function GetSigCompressionMode() {
    var Prop = "CompressionMode";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}


function SetEncryptionMode(v) {
    var Prop = "EncryptionMode/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}


function GetEncryptionMode() {
    var Prop = "EncryptionMode";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

//		function  SetKey( Keydata ) {}
//		function  GetKey( ) {}

function SetKeyString(keyString) {
    var Prop = "KeyString";

    Prop = Prop;
    SigWebSetStreamProperty(Prop, keyString);
}


function GetKeyString() {
    var Prop = "KeyString";

    Prop = Prop;
    var Str = SigWebGetProperty(Prop);

    return Str.slice(1, Str.length - 1);
}



function AutoKeyStart() {
    var Prop = "AutoKeyStart";

    Prop = Prop;
    SigWebSetProperty(Prop);
}


function AutoKeyFinish() {
    var Prop = "AutoKeyFinish";

    Prop = Prop;
    SigWebSetProperty(Prop);
}

function SetAutoKeyData(keyData) {
    var Prop = "SetAutoKeyData";

    Prop = Prop;
    SigWebSetStreamProperty(Prop, keyData);
}


function AutoKeyAddData(keyData) {
    var Prop = "AutoKeyAddData";

    Prop = Prop;
    SigWebSetStreamProperty(Prop, keyData);
}

//		function  GetKeyReceipt( ) {}

function GetKeyReceiptAscii() {
    var Prop = "KeyReceiptAscii";

    Prop = Prop;
    var Str = SigWebGetProperty(Prop);

    return Str.slice(1, Str.length - 1);
}


//		function  GetSigReceipt( ) {}

function GetSigReceiptAscii() {
    var Prop = "SigReceiptAscii";

    Prop = Prop;
    var Str = SigWebGetProperty(Prop);

    return Str.slice(1, Str.length - 1);
}


function SetTimeStamp(timeStamp) {
    var Prop = "TimeStamp";

    Prop = Prop;
    SigWebSetStreamProperty(Prop, timeStamp);
}

function GetTimeStamp() {
    var Prop = "TimeStamp";

    Prop = Prop;
    var Str = SigWebGetProperty(Prop);

    return Str.slice(1, Str.length - 1);
}

function SetAnnotate(annotate) {
    var Prop = "Annotate";

    Prop = Prop;
    SigWebSetStreamProperty(Prop, annotate);
}


function GetAnnotate() {
    var Prop = "Annotate";

    Prop = Prop;
    var Str = SigWebGetProperty(Prop);

    return Str.slice(1, Str.length - 1);
}


function SetSaveSigInfo(v) {
    var Prop = "SaveSigInfo/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function GetSaveSigInfo() {
    var Prop = "SaveSigInfo";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function SetSavePressureData(v) {
    var Prop = "SavePressureData/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function GetSavePressureData() {
    var Prop = "SavePressureData";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function SetSaveTimeData(v) {
    var Prop = "SaveTimeData/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function GetSaveTimeData() {
    var Prop = "SaveTimeData";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function SetAntiAliasSpotSize(v) {
    var Prop = "AntiAliasSpotSize/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function GetAntiAliasSpotSize() {
    var Prop = "AntiAliasSpotSize";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function SetAntiAliasLineScale(v) {
    var Prop = "AntiAliasLineScale/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function GetAntiAliasLineScale() {
    var Prop = "AntiAliasLineScale";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function GetNumberOfStrokes() {
    var Prop = "NumberOfStrokes";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function GetNumPointsForStroke(v) {
    var Prop = "NumberOfPointsInStroke/";

    Prop = Prop + v;
    return SigWebGetProperty(Prop);
}

function GetPointXValue(v1, v2) {
    var Prop = "PointXValue/";

    Prop = Prop + v1 + "/" + v2;
    return SigWebGetProperty(Prop);
}

function GetPointYValue(v1, v2) {
    var Prop = "PointYValue/";

    Prop = Prop + v1 + "/" + v2;
    return SigWebGetProperty(Prop);
}


function SetAntiAliasEnable(v) {
    var Prop = "AntiAliasEnable/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function GetAntiAliasEnable() {
    var Prop = "AntiAliasEnable";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function SetUseAmbientColors(v) {
    var Prop = "UseAmbientColors/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

//
//		SigPlusNETDisplay.cs
//
function SetDisplayXSize(v) {
    var Prop = "DisplayXSize/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function GetDisplayXSize() {
    var Prop = "DisplayXSize";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function SetDisplayYSize(v) {
    var Prop = "DisplayYSize/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function GetDisplayYSize() {
    var Prop = "DisplayYSize";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}
function SetDisplayPenWidth(v) {
    var Prop = "DisplayPenWidth/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}


function GetDisplayPenWidth() {
    var Prop = "DisplayPenWidth";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function SetDisplayTimeStamp(v) {
    var Prop = "DisplayTimeStamp/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function GetDisplayTimeStamp() {
    var Prop = "DisplayTimeStamp";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function SetDisplayTimeStampPosX(v) {
    var Prop = "DisplayTimeStampPosX/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function GetDisplayTimeStampPosX() {
    var Prop = "DisplayTimeStampPosX";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function SetDisplayTimeStampPosY(v) {
    var Prop = "DisplayTimeStampPosY/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function GetDisplayTimeStampPosY() {
    var Prop = "DisplayTimeStampPosY";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function SetDisplayTimeStampSize(v) {
    var Prop = "DisplayTimeStampSize/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function GetDisplayTimeStampSize() {
    var Prop = "DisplayTimeStampSize";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function SetDisplayAnnotate(v) {
    var Prop = "DisplayAnnotate/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function GetDisplayAnnotate() {
    var Prop = "DisplayAnnotate";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function SetDisplayAnnotatePosX(v) {
    var Prop = "DisplayAnnotatePosX/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function GetDisplayAnnotatePosX() {
    var Prop = "DisplayAnnotatePosX";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function SetDisplayAnnotatePosY(v) {
    var Prop = "DisplayAnnotatePosY/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function GetDisplayAnnotatePosY() {
    var Prop = "DisplayAnnotatePosY";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function SetDisplayAnnotateSize(v) {
    var Prop = "DisplayAnnotateSize/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function GetDisplayAnnotateSize() {
    var Prop = "DisplayAnnotateSize";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

//
//		SigPlusNETImage.cs
//
//		function  GetSigImageB64( )  
//			{
//			var xhr2 = new XMLHttpRequest();
//			xhr2.open("GET", baseUri + "SigImage/1", false );
//			xhr2.responseType = "blob"
//			xhr2.send(null);
//			if (xhr2.readyState == 4 && xhr.status == 200)
//				{
//				return window.URL.createObjectURL(xhr2.response);
//				}
//			return null;
//			}

function SetImageXSize(v) {
    var Prop = "ImageXSize/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function GetImageXSize() {
    var Prop = "ImageXSize";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function SetImageYSize(v) {
    var Prop = "ImageYSize/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function GetImageYSize() {
    var Prop = "ImageYSize";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function SetImagePenWidth(v) {
    var Prop = "ImagePenWidth/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function GetImagePenWidth() {
    var Prop = "ImagePenWidth";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function SetImageTimeStamp(v) {
    var Prop = "ImageTimeStamp/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function GetImageTimeStamp() {
    var Prop = "ImageTimeStamp";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function SetImageTimeStampPosX(v) {
    var Prop = "ImageTimeStampPosX/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function GetImageTimeStampPosX() {
    var Prop = "ImageTimeStampPosX";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function SetImageTimeStampPosY(v) {
    var Prop = "ImageTimeStampPosY/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function GetImageTimeStampPosY() {
    var Prop = "ImageTimeStampPosY";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function SetImageTimeStampSize(v) {
    var Prop = "ImageTimeStampSize/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function GetImageTimeStampSize() {
    var Prop = "ImageTimeStampSize";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function SetImageAnnotate(v) {
    var Prop = "ImageAnnotate/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function GetImageAnnotate() {
    var Prop = "ImageAnnotate";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function SetImageAnnotatePosX(v) {
    var Prop = "ImageAnnotatePosX/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function GetImageAnnotatePosX() {
    var Prop = "ImageAnnotatePosX";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function SetImageAnnotatePosY(v) {
    var Prop = "ImageAnnotatePosY/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function GetImageAnnotatePosY() {
    var Prop = "ImageAnnotatePosY";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function SetImageAnnotateSize(v) {
    var Prop = "ImageAnnotateSize/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function GetImageAnnotateSize() {
    var Prop = "ImageAnnotateSize";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function SetJustifyX(v) {
    var Prop = "JustifyX(/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function GetJustifyX() {
    var Prop = "JustifyX(";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function SetJustifyY(v) {
    var Prop = "JustifyY/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function GetJustifyY() {
    var Prop = "JustifyY";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function SetJustifyMode(v) {
    var Prop = "JustifyMode/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function GetJustifyMode() {
    var Prop = "JustifyMode";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

//
//		SigPlusNETKeyPad.cs
//
function KeyPadAddHotSpot(key, coord, xp, yp, xs, ys) {
    var Prop = "KeyPadAddHotSpot/";
    Prop = Prop + key + "," + coord + "," + xp + "," + yp + "," + xs + "," + ys;
    SigWebSetProperty(Prop);
}

function KeyPadMarkHotSpot(key, coord, xp, yp, xs, ys) {
    LCDWriteString(0, 2, xp, yp, "16pt sans-serif", 32, "+")
    LCDWriteString(0, 2, xp + xs, yp, "16pt sans-serif", 32, "+")
    LCDWriteString(0, 2, xp, yp + ys, "16pt sans-serif", 32, "+")
    LCDWriteString(0, 2, xp + xs, yp + ys, "16pt sans-serif", 32, "+")
}

function KeyPadQueryHotSpot(key) {
    var Prop = "KeyPadQueryHotSpot/";
    Prop = Prop + key;
    return SigWebGetProperty(Prop);
}

function KeyPadClearHotSpotList() {
    var Prop = "KeyPadClearHotSpotList";
    SigWebSetProperty(Prop);
}


function SetSigWindow(coords, xp, yp, xs, ys) {
    var Prop = "SigWindow/";
    Prop = Prop + coords + "," + xp + "," + yp + "," + xs + "," + ys;
    SigWebSetProperty(Prop);
}

function ClearSigWindow(inside) {
    var Prop = "ClearSigWindow/";
    Prop = Prop + inside;
    SigWebSetProperty(Prop);
}
//
//		SigPlusNETLCD.cs
//
function SetLCDCaptureMode(v) {
    var Prop = "CaptureMode/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}


function GetLCDCaptureMode() {
    var Prop = "CaptureMode";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}


function LCDSetWindow(xP, yP, xS, yS) {
    var Prop = "LCDSetWindow/";
    Prop = Prop + xP + "," + yP + "," + xS + "," + yS;
    SigWebSetProperty(Prop);
}


function LCDWriteString(dest, mode, x, y, fnt, size, str) {
    var c = document.createElement('canvas');
    var cntx = c.getContext('2d');
    cntx.font = fnt;
    var txt = str;
    var xs = Math.round(cntx.measureText(txt).width);
    var ys = size;
    c.width = xs;
    c.height = ys;

    cntx.font = fnt;
    cntx.fillStyle = '#FFFFFF'
    cntx.rect(0, 0, xs, ys);
    cntx.fill();


    cntx.fillStyle = '#000000'
    cntx.textBaseline = "top";
    cntx.fillText(txt, 0, 0);

    cntx.drawImage(cntx.canvas, 0, 0, xs, ys);

    var Gstr = createLcdBitmapFromCanvas(c, x, y, xs, ys);

    LcdWriteImageBlob(dest, mode, x, y, xs, ys, Gstr);
}


function LCDDrawRectangle(dest, mode, x, y, xs, ys, fill) {
    var c = document.createElement('canvas');
    var cntx = c.getContext('2d');

    c.width = xs;
    c.height = ys;


    cntx.fillStyle = fill
    cntx.rect(0, 0, xs, ys);
    cntx.fill();

    cntx.drawImage(cntx.canvas, 0, 0, xs, ys);
    var Gstr = createLcdBitmapFromCanvas(c, x, y, xs, ys);
    LcdWriteImageBlob(dest, mode, x, y, xs, ys, Gstr);
}


function LCDDrawButton(dest, mode, x, y, xs, ys, strys, fill, fnt, str) {
    var c = document.createElement('canvas');
    var cntx = c.getContext('2d');
    cntx.font = fnt;
    var txt = str;
    var sxs = Math.round(cntx.measureText(txt).width);
    var sys = strys;
    c.width = xs;
    c.height = ys;

    cntx.font = fnt;
    cntx.fillStyle = fill
    cntx.rect(0, 0, xs, ys);
    cntx.fill();


    cntx.fillStyle = '#FFFFFF'
    cntx.textBaseline = "top";
    cntx.fillText(txt, ((xs - sxs) / 2), ((ys - sys) / 2));

    cntx.drawImage(cntx.canvas, 0, 0, xs, ys);

    var Gstr = createLcdBitmapFromCanvas(c, x, y, xs, ys);

    LcdWriteImageBlob(dest, mode, x, y, xs, ys, Gstr);
}



function LCDWriteStringWindow(dest, mode, x, y, fnt, xsize, ysize, str) {
    var c = document.createElement('canvas');
    var cntx = c.getContext('2d');
    cntx.font = fnt;
    var txt = str;
    var xs = xsize;
    var ys = ysize;
    c.width = xs;
    c.height = ys;

    cntx.font = fnt;
    cntx.fillStyle = '#FFFFFF'
    cntx.rect(0, 0, xs, ys);
    cntx.fill();


    cntx.fillStyle = '#000000'
    cntx.textBaseline = "top";
    cntx.fillText(txt, 0, 0);

    cntx.drawImage(cntx.canvas, 0, 0, xs, ys);

    var Gstr = createLcdBitmapFromCanvas(c, x, y, xs, ys);

    LcdWriteImageBlob(dest, mode, x, y, xs, ys, Gstr);
}


function LCDStringWidth(fnt, str) {
    var c = document.createElement('canvas');
    var cntx = c.getContext('2d');
    cntx.font = fnt;
    var txt = str;
    var xs = Math.round(cntx.measureText(txt).width);

    return xs;
}


function LCDStringHeight(fnt, str) {
    return 16;
}

function LcdRefresh(Mode, Xp, Yp, Xs, Ys) {
    var Prop = "LcdRefresh/";

    Prop = Prop + Mode + "," + Xp + "," + Yp + "," + Xs + "," + Ys;
    SigWebSetProperty(Prop);
}

function LCDSendCmdString(CmdStr, ReturnCount, Result, TimeOut) {
    var Prop = "LcdSendCmdString/";

    Prop = Prop + ReturnCount + "," + TimeOut;
    Result = SigWebSetStreamProperty(Prop, CmdStr);
}

function LCDSendCmdData(CmdStr, ReturnCount, Result, TimeOut) {
    var Prop = "LcdSendCmdData/";

    Prop = Prop + ReturnCount + "," + TimeOut;
    Result = SigWebSetStreamProperty(Prop, CmdStr);
}


function LCDSendGraphicCanvas(dest, mode, x, y, canvas) {
    var Gstr = createLcdBitmapFromCanvas(canvas, 0, 0, xs, ys)
    LcdWriteImageStream(dest, mode, x, y, canvas.width, canvas.height, Gstr);
}


//		function  LCDSendWindowedGraphicCanvas(  dest, mode,  x,  y, canvas )
//			 {
//			 }


//		function  LCDSendWindowedGraphicCanvas(  dest, mode,  x,  y,  xs,  ys, canvas ) 
//			{
//			var Gstr = createLcdBitmapFromCanvas( canvas, 0, 0, xs, ys)
//			LcdWriteImageStream( dest, mode, x, y, xs, ys, Gstr );
//			}


function LCDSendWindowedGraphicCanvas(dest, mode, x, y, xs, ys, c, xps, yps) {
    var Gstr = createLcdBitmapFromCanvas(canvas, xps, yps, xs, ys)
    LcdWriteImageStream(dest, mode, x, y, xs, ys, Gstr);
}



function LCDSendGraphicUrl(dest, mode, x, y, url) {
    LcdWriteImage(dest, mode, x, y, url)
}

//		function  LCDSendWindowedGraphicUrl(  dest, mode,  X,  Y, url ) 
//			{
//			}

//		function  LCDSendWindowedGraphicUrl(  dest, mode,  x,  y,  xs,  ys, url ) 
//			{
//			LcdWriteImageStream(dest, mode, x, y, xs, ys, url);
//			}

function LCDSendWindowedGraphicUrl(dest, mode, x, y, xse, yse, url, xps, yps) {
    LcdWriteImageStream(dest, mode, x, y, xs, ys, url);
}


//		function  LCDSendGraphic(  Dest,  Mode,  XPos,  YPos,  ImageFileName ) {}
//		function  LCDSendGraphicURL(  Dest,  Mode,  XPos,  YPos,  URL ) {}

function LCDClear() {
    var Prop = "LcdClear";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function LCDSetTabletMap(LCDType, LCDXSize, LCDYSize, LCDXStart, LCDYStart, LCDXStop, LCDYStop) {
}


function LCDSetPixelDepth(v) {
    var Prop = "LcdSetPixelDepth/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function LCDGetLCDSize() {
    var Prop = "LcdGetLcdSize";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function LCDSetCompressionMode(NewMode) {
    var Prop = "LcdCompressionMode/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}


function LCDGetCompressionMode() {
    var Prop = "LcdCompressionMode";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function LCDSetZCompressionMode(NewMode) {
    var Prop = "LcdZCompressionMode/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}


function LCDGetZCompressionMode() {
    var Prop = "LcdZCompressionMode";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}
//
//		SigPlusNETLCD.cs
//


function SetTabletState(v) {
    var Prop = "TabletState/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function GetTabletState() {
    var Prop = "TabletState";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}



function SetTabletLogicalXSize(v) {
    var Prop = "TabletLogicalXSize/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function GetTabletLogicalXSize() {
    var Prop = "TabletLogicalXSize";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function GetTabletLogicalYSize() {
    var Prop = "TabletLogicalYSize";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function SetTabletLogicalYSize(v) {
    var Prop = "TabletLogicalYSize/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function SetTabletXStart(v) {
    var Prop = "TabletXStart/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function GetTabletXStart() {
    var Prop = "TabletXStart";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function SetTabletYStart(v) {
    var Prop = "TabletYStart/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function GetTabletYStart() {
    var Prop = "TabletYStart";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function SetTabletXStop(v) {
    var Prop = "TabletXStop/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function GetTabletXStop() {
    var Prop = "TabletXStop";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function SetTabletYStop(v) {
    var Prop = "TabletYStop/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function GetTabletYStop() {
    var Prop = "TabletYStop";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function SetTabletFilterPoints(v) {
    var Prop = "TabletFilterPoints/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function GetTabletFilterPoints() {
    var Prop = "TabletFilterPoints";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function SetTabletTimingAdvance(v) {
    var Prop = "TabletTimingAdvance/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function GetTabletTimingAdvance() {
    var Prop = "TabletTimingAdvance";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function SetTabletComPort(v) {
    var Prop = "TabletComPort/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function GetTabletComPort() {
    var Prop = "TabletComPort";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function SetTabletBaudRate(v) {
    var Prop = "TabletBaudRate/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function GetTabletBaudRate() {
    var Prop = "TabletBaudRate";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function SetTabletRotation(v) {
    var Prop = "TabletRotation/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function GetTabletRotation() {
    var Prop = "TabletRotation";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function SetTabletType(v) {
    var Prop = "TabletType/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}


function GetTabletType() {
    var Prop = "TabletType";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function SetServerTabletType(v) {
    var Prop = "ServerTabletType/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function GetServerTabletType() {
    var Prop = "ServerTabletType";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function SetTabletComTest(v) {
    var Prop = "TabletComTest/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function GetTabletComTest() {
    var Prop = "TabletComTest";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function SetTabletResolution(v) {
    var Prop = "TabletResolution/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function GetTabletResolution() {
    var Prop = "TabletResolution";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function TabletConnectQuery() {
    var Prop = "TabletConnectQuery";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function TabletModelNumber() {
    var Prop = "TabletModelNumber";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function TabletSerialNumber() {
    var Prop = "TabletSerialNumber";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function SetTabletPortPath(v) {
    var Prop = "TabletPortPath/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function SetTabletLocalIniFilePath(v) {
    var Prop = "TabletLocalIniFilePath/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function SetTabletModel(v) {
    var Prop = "TabletModel/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function SetSerialPortCloseDelay(v) {
    var Prop = "SerialPortCloseDelay/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function GetSerialPortCloseDelay() {
    var Prop = "SerialPortCloseDelay";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function EnableTabletEncryption() {
    var Prop = "EnableTabletEncryption";

    Prop = Prop;
    SigWebSetProperty(Prop);
}

function SetTabletEncryptionMode(hmode, tmode) {
    var Prop = "TabletEncryptionMode/";

    Prop = Prop + hmode + "," + tmode;
    SigWebSetProperty(Prop);
}

function SetMaxLogFileSize(v) {
    var Prop = "MaxLogFileSize/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function GetSigSockServerPath() {
    var Prop = "SigSockServerPath";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function GetSigSockClientName() {
    var Prop = "SigSockClientName";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function GetSigSockPortNumber() {
    var Prop = "SigSockPortNumber";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}

function SetSigSockServerPath(v) {
    var Prop = "SigSockServerPath/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function SetSigSockClientName(v) {
    var Prop = "SigSockClientName/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function SetPortNumber(v) {
    var Prop = "PortNumber/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function SetSigSockPortNumber(v) {
    var Prop = "SigSockPortNumber/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function GetFirmwareRevision() {
    var Prop = "FirmwareRevision";

    Prop = Prop;
    return SigWebGetProperty(Prop);
}


function SetTabletData(sigStr) {
    var Prop = "TabletData";

    Prop = Prop;
    SigWebSetStreamProperty(Prop, sigStr);
}



function GetTabletData() {
    var Prop = "TabletData";

    Prop = Prop;
    var Str = SigWebGetProperty(Prop);

    return Str.slice(1, Str.length - 1);
}


function OpenTablet(v) {
    var Prop = "OpenTablet/";

    Prop = Prop + v;
    SigWebSetProperty(Prop);
}

function CloseTablet() {
    var Prop = "CloseTablet";

    Prop = Prop;
    SigWebSetProperty(Prop);
}


function ResetParameters() {
    var Prop = "ResetParameters";

    Prop = Prop;
    SigWebSetProperty(Prop);
}


function testRawData() {
    OpenTablet(1);
    var Str1 = GetTabletData();
    CloseTablet();
}


]]>

        </script>
        <!--<div>
        
         -->
        <!--<xsl:if test="ShowLabel = 'True'">
                <xsl:call-template name="ctl-label">
                    <xsl:with-param name="for"><xsl:value-of select="/Form/Settings/BaseId"/><xsl:value-of select="Name"/></xsl:with-param>
                </xsl:call-template>
            </xsl:if>-->
        <!--

                   <canvas id="cnv"></canvas>
               <p>
               <input id="SignBtn" name="SignBtn" type="button" value="Sign"  onclick="javascript:onSign()"/>
               <input id="button1" name="ClearBtn" type="button" value="Clear" onclick="javascript:onClear()"/>

               <input id="button2" name="DoneBtn" type="button" value="Done" onclick="javascript:onDone()"/>

               <INPUT TYPE="HIDDEN" NAME="BioSigData"></INPUT>
             </p>
        </div>-->



        <!--If label is a column, render it here-->
        <xsl:if test="/Form/Settings/LabelAlign != 'inside' and /Form/Settings/LabelAlign != 'top'">
            <xsl:call-template name="ctl-label" />
        </xsl:if>

        <div>
            <xsl:call-template name="ctl-attr-container" />

            <!--If label is top, render it here-->
            <xsl:if test="/Form/Settings/LabelAlign = 'top'">
                <xsl:call-template name="ctl-label" />
            </xsl:if>
            <div class="row">
                <!--<xsl:attribute name="class">
                        <xsl:choose>
                            <xsl:when test="OneLine = 'True'">col-sm-6</xsl:when>
                            <xsl:otherwise>col-sm-12</xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>-->

                <!--<xsl:if test="ShortDesc != '' and /Form/Settings/LabelAlign = 'inside'">
                        <xsl:attribute name="title">
                            <xsl:value-of select="ShortDesc"/>
                        </xsl:attribute>
                    </xsl:if>-->
                <div>


                    <canvas id="cnvTopaz" class="delay-submit"></canvas>

                </div>
                <!--          <img>
                        <xsl:attribute name="src">
                            <xsl:value-of select="Data/ImageUrl"/>
                        </xsl:attribute>
                        <xsl:call-template name="ctl-attr-common">
                            <xsl:with-param name="cssclass">
                                <xsl:text>imgcode </xsl:text>
                            </xsl:with-param>
                        </xsl:call-template>
                        <xsl:attribute name="style">
                            <xsl:text>margin: 0px 4px 2px 0; width: 100%;</xsl:text>
                            <xsl:if test="OneLine = 'True'"> height: 33px;</xsl:if>
                        </xsl:attribute>
                    </img> -->

                <p>
                    <!--<input id="SignBtn" name="SignBtn" type="button" value="Sign"  onclick="javascript:onSignTopazSignature()"/>-->
                    <input id="button1" name="ClearBtn" type="button" value="Clear" onclick="javascript:onClearTopazSignature()"/>

                    <!--<input id="button2" name="DoneBtn" type="button" value="Done" onclick="javascript:onDoneTopazSignature()"/>-->

                    <INPUT TYPE="HIDDEN" NAME="BioSigData"></INPUT>
                </p>



                <input type="hidden">
                    <xsl:attribute name="name">
                        <xsl:value-of select="/Form/Settings/BaseId"/>
                        <xsl:value-of select="Name" />
                    </xsl:attribute>

                    <xsl:attribute name="data-fieldid">
                        <xsl:value-of select="Id"/>
                    </xsl:attribute>
                    <xsl:attribute name="data-af-field">
                        <xsl:value-of select="Name"/>
                    </xsl:attribute>


                    <xsl:attribute name="value">
                        <xsl:value-of select="Value" />
                    </xsl:attribute>

                    <xsl:attribute name="data-ng-model">
                        <xsl:text>form.fields.</xsl:text>
                        <xsl:value-of select="Name"/>
                        <xsl:text>.value</xsl:text>
                    </xsl:attribute>

                    <xsl:if test="BindValue != ''">
                        <xsl:attribute name="data-af-bindvalue">
                            <xsl:value-of select="utils:parseAngularJs(BindValue, 'true')" />
                        </xsl:attribute>
                    </xsl:if>

                    <xsl:attribute name="data-val">
                        <xsl:text>{{ form.fields.</xsl:text>
                        <xsl:value-of select="Name"/>
                        <xsl:text>.value }}</xsl:text>
                    </xsl:attribute>

                </input>




                <!--<input type="hidden">
                    <xsl:attribute name="name">
                        <xsl:value-of select="/Form/Settings/BaseId"/>
                        <xsl:value-of select="Name"/>
                        <xsl:text>captchaenc</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="value">
                        <xsl:value-of select="Data/CaptchaEncrypted" />
                    </xsl:attribute>
                </input>-->
                <div>
                    <!--<xsl:attribute name="class">
                        <xsl:choose>
                            <xsl:when test="OneLine = 'True'">col-sm-6</xsl:when>
                            <xsl:otherwise>col-sm-12</xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>-->
                    <!--<input type="text">
                        <xsl:call-template name="ctl-attr-common">
                            <xsl:with-param name="cssclass">
                                <xsl:text>form-control inpcode </xsl:text>
                                <xsl:if test="/Form/Settings/ClientSideValidation ='True' and IsRequired='True' and CanValidate = 'True'"> required</xsl:if>
                            </xsl:with-param>
                            <xsl:with-param name="hasId">yes</xsl:with-param>
                            <xsl:with-param name="hasName">yes</xsl:with-param>
                        </xsl:call-template>

                        <xsl:call-template name="ctl-attr-placeholder" />

                        <xsl:attribute name="value">
                            <xsl:value-of select="Value"/>
                        </xsl:attribute>
                    </input>-->
                </div>
            </div>
        </div>



    </xsl:template>

</xsl:stylesheet>
