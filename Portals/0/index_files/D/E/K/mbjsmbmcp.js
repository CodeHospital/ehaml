function IsAllDefined(){for(var a=0;a<arguments.length;++a){if(typeof(arguments[a])=="undefined"){return false}}return true}function asNum(a){return parseInt(a,10)||0}function getStyleAsNum(d,b,e){var c="0";if(document.defaultView&&document.defaultView.getComputedStyle){c=asNum(document.defaultView.getComputedStyle(d,"").getPropertyValue(b))}else{if(d.currentStyle){c=asNum(d.currentStyle[e])}}return asNum(c)}function GetWinH(){var b=0;var a=0;if((!document.compatMode||document.compatMode=="CSS1Compat")&&document.documentElement){a=document.documentElement}else{if(document.body){a=document.body}}if(a&&a.clientHeight){b=a.clientHeight}else{if(IsAllDefined(window.innerWidth,window.innerHeight,document.width)){b=window.innerHeight;if(document.width>window.innerWidth){b=b-15}}}return b}function GetWinW(){var a=0;var b=0;if((!document.compatMode||document.compatMode=="CSS1Compat")&&document.documentElement){b=document.documentElement}else{if(document.body){b=document.body}}if(b&&b.clientWidth){a=b.clientWidth
}else{if(IsAllDefined(window.innerWidth,window.innerHeight,document.height)){a=window.innerWidth;if(document.height>window.innerHeight){a=a-15}}}return a}function GetObjectRect(e){var a=0;var g=0;var f=e;var c=false;while(e&&e!=null){if(e.style&&e.style.position=="fixed"){c=true}a+=asNum(isNS4?e.pageX:e.offsetLeft);g+=asNum(isNS4?e.pageY:e.offsetTop);if(isNS4){if(e.style&&(e.style.position=="absolute"||e.style.position=="relative")){break}}e=e.offsetParent}e=f;var b=0;var d=0;if(isOp&&!isOp7){b=e.style.pixelWidth}else{if(isNS4){b=e.clip.width}else{b=e.offsetWidth}}if(isOp&&!isOp7){d=e.style.pixelHeight}else{if(isNS4){d=e.clip.height}else{d=e.offsetHeight}}return{x:a,y:g,w:b,h:d,in_fixed:c}}function LoadSrcImage(b){var a=new Image();if(typeof isIE=="undefined"){GetBrowserInfo()}if(isIE&&window.location.protocol=="file:"){a.meSrc=b}else{a.src=b}return a}function GetBrowserInfo(){isDOM=document.getElementById;isMz=isDOM&&(navigator.appName=="Netscape");isOp=isDOM&&window.opera;isIE=document.all&&document.all.item&&!isOp;
isIE6orLess=false;isIE8orLess=false;if(isIE){var a=navigator.userAgent;var b=new RegExp("MSIE ([0-9]{1,}[.0-9]{0,})");if(b.exec(a)!=null){var c=parseFloat(RegExp.$1);isIE6orLess=(c<=6);isIE8orLess=(c<=8)}}isIE9=isIE&&document.documentMode>=9;isNS4=document.layers;isOp7=isOp&&document.readyState}function GetViewRect(){var c=0;var a=0;if(isNS4||isMz||isOp){a=window.pageXOffset;c=window.pageYOffset}else{var b=(document.compatMode=="CSS1Compat"&&!isMz)?document.documentElement:document.body;a=b.scrollLeft;c=b.scrollTop}return{x:a,y:c,w:GetWinW(),h:GetWinH()}}function SetElemOpacity(a,b){if(a&&a.style){if(b==1){a.style.opacity=((navigator.userAgent.indexOf("Gecko")>-1)&&!/Konqueror|Safari|KHTML/.test(navigator.userAgent))?0.999999:1;if(isIE&&!isIE9){if(a.style.filter){a.style.filter=a.style.filter.replace(/alpha\([^\)]*\)/gi,"")}}}else{if(b<0.00001){b=0}a.style.opacity=b;if(isIE&&!isIE9){a.style.filter=(a.style.filter?a.style.filter.replace(/alpha\([^\)]*\)/gi,""):"")+"alpha(opacity="+b*100+")"
}}}}function SetElementScale(d,m,l){if(d&&d.style){try{if(m>1){m=1}if(l>1){l=1}if(isIE&&!isIE9){if(m==1&&l==1){d.style.filter=d.style.filter.replace(/progid:DXImageTransform.Microsoft.Matrix\([^\)]*\);?/gi,"")}else{var c=0;var b=0;if(d.cbnDirectionX==-1&&d.cbnMenuRect){c=d.cbnMenuRect.w-d.cbnMenuRect.w*m}if(d.cbnDirectionY==-1&&d.cbnMenuRect){b=d.cbnMenuRect.h-d.cbnMenuRect.h*l}m=Math.round(m*100)/100;l=Math.round(l*100)/100;d.style.filter=(d.style.filter?d.style.filter.replace(/progid\:DXImageTransform\.Microsoft\.Matrix\([^\)]*\)/gi,""):"")+"progid:DXImageTransform.Microsoft.Matrix(sizingMethod='clip to original', M11="+m+", M12=0, M21=0, M22="+l+" Dx="+c+" Dy="+b+")"}}else{var k="0";var h="0";if(d.cbnDirectionX==-1){k="100%"}if(d.cbnDirectionY==-1){h="100%"}if(d.ebnStyleScaleProperty){a=d.ebnStyleScaleProperty}else{var a=null;var j=["transform","MozTransform","WebkitTransform","OTransform","msTransform"];for(var f=0;f<j.length;f++){if(d.style[j[f]]!=null){a=j[f];break}}d.ebnStyleScaleProperty=a
}if(a!=null){if(m==1&&l==1){d.style[a]=""}else{d.style[a]="scale("+m+","+l+")";d.style[a+"Origin"]=k+" "+h}}}}catch(g){}}}function ebmResetElementScale(a){SetElementScale(a,1,1)}function ebmProgressElementScale(b,a){if(b.ebmScaleEffect==1){SetElementScale(b,1,a)}else{if(b.ebmScaleEffect==2){SetElementScale(b,a,a)}else{if(b.ebmScaleEffect==3){SetElementScale(b,a,1)}}}}function ebmSetDivShadow(e,b,a){var f=null;var d=["boxShadow","MozBoxShadow","WebkitBoxShadow"];for(var c=0;c<d.length;c++){if(e.style[d[c]]!=null){f=d[c];break}}if(f==null){if(isIE){e.style.filter+="progid:DXImageTransform.Microsoft.DropShadow(OffX="+b+", OffY="+a+", Color='#80777777', Positive='true')";return true}else{return false}}return true}function ebmStartTimer(a){var b=setTimeout(function(){ebmRemoveSubmenu(a)},550);return b}function ebmTickerOn(b){var c;for(var a=b;a;a=a.openSubmenuDiv){c=a;if(!a.ticker){a.ticker=ebmStartTimer(c)}}}function ebmTickerOff(b){for(var a=b;a;a=a.upperTR?a.upperTR.menuDiv:0){if(a.ticker){clearTimeout(a.ticker);
a.ticker=0}}}function ebmMenuPosY(b,j,i,d,h,g,e){var a=5;var f=i;var k=h;var c=g;if(k>j-2*a&&j>0){f=a+b;k=j-2*a}else{if(c==-1){f=i+d-k+e}else{f=i}if(f<b+a){f=b+a;c=1}if(f+h>j+b-a&&j>0){f-=f+k-(j+b-a);c=-1}}return{y:f,direction:c,size:k}}function ebmMenuPosX(c,d,i,k,b,h,f){var a=5;var g=i;var j=b;var e=h;if(((e>=0)&&(i+k+b>d+c-a))||((e<0)&&(i-b<a))){if(i-c>d+c-(i+k)&&d>0){e=-1}else{e=1}}if(e>=0){g=i+k;if(d+c-a-g<j&&d>0){j=d+c-a-g}}else{g=i-j+f;if(g-c<a){g=c+a;j=i-(c+a)}}return{x:g,direction:e,size:j}}function ebmFade(b){if(b){var a=new Date().getTime();var d=a-b.cbnLastAnimTime;var c=d/200;if(c<0.05||b.cbnTransitionProgress==0){c=0.05}b.cbnTransitionProgress=c;if(b.cbnTransitionProgress>1){b.cbnTransitionProgress=1}if(b.ebmFadeEffect){var e=b.cbnTransitionProgress;if(b.cbnMenuAlpha&&e>b.cbnMenuAlpha){e=b.cbnMenuAlpha}SetElemOpacity(b,e)}if(b.ebmScaleEffect>0){ebmProgressElementScale(b,b.cbnTransitionProgress)}if(b.cbnTransitionProgress>=1){clearInterval(b.ebmFadeTimer);b.ebmFadeTimer=null
}}}function ebmHideSubmenus(){if(cbnOpenTopMenu){ebmRemoveSubmenu(cbnOpenTopMenu)}}function ebmDisplaySubmenu(h,c,f){var e=h;if(e&&e.style){if(e.style.display=="block"){ebmTickerOff(e);return}e.style.display="block";e.style.left="0px";e.style.top="0px";e.style.height="auto";e.style.width="auto";if(!e.depth&&(cbnOpenTopMenu!=e)){ebmRemoveSubmenu(cbnOpenTopMenu)}if(c&&c.menuDiv&&c.menuDiv.openSubmenuDiv&&c.menuDiv.openSubmenuDiv!=e){ebmRemoveSubmenu(c.menuDiv.openSubmenuDiv)}ebmTickerOff(e);if(e.depth>0){e.cbnDirectionX=e.upperTR.menuDiv.cbnDirectionX;e.cbnDirectionY=e.upperTR.menuDiv.cbnDirectionY}else{e.cbnDirectionX=e.cbnDefaultDirectionX;e.cbnDirectionY=1}e.style.overflow="visible";var b=c;if(b.tagName&&b.tagName.toLowerCase()=="a"){b=b.parentNode}var a=GetObjectRect(b);var i=0;var j=GetObjectRect(e);var g=GetViewRect();if(j.in_fixed){g.x=0;g.y=0}var d;if(f){d=ebmMenuPosY(g.y,g.h,a.y,a.h,j.h,e.cbnDirectionY,0)}else{d=ebmMenuPosX(g.y,g.h,a.y,a.h,j.h,e.cbnDirectionY,0);d.y=d.x}e.cbnDirectionY=d.direction;
e.style.top=d.y-j.y+"px";j=GetObjectRect(e);if(f){d=ebmMenuPosX(g.x,g.w,a.x,a.w,j.w,e.cbnDirectionX,i)}else{d=ebmMenuPosY(g.x,g.w,a.x,a.w,j.w,e.cbnDirectionX,i);d.x=d.y}e.cbnDirectionX=d.direction;if((d.size<j.w)&&(e.cbnDirectionX>0)){d.x=d.x-(j.w-d.size)}e.style.left=d.x-j.x+"px";e.cbnMenuRect={w:j.w,h:j.h,x:d.x-j.x,y:d.y-j.y};if(e.ebmFadeEffect||ebmScaleEffect>0){if(!e.ebmFadeTimer){if(e.ebmFadeEffect){SetElemOpacity(e,0.05)}if(e.ebmScaleEffect>0){ebmProgressElementScale(e,0.05)}e.cbnTransitionProgress=0;e.cbnLastAnimTime=new Date().getTime();e.ebmFadeTimer=setInterval(function(){ebmFade(e)},20)}}if(!e.depth){cbnOpenTopMenu=e}else{c.menuDiv.openSubmenuDiv=e}e.style.display="block"}}function ebmRemoveSubmenu(b){var a=b;if(a&&(a.style.display=="block")){if(a.openSubmenuDiv){ebmRemoveSubmenu(a.openSubmenuDiv)}if(a.upperTR&&a.upperTR.className){a.upperTR.makeNormal()}a.style.display="none";a.openSubmenuDiv=0;if(a.ticker){clearTimeout(a.ticker);a.ticker=null}if(a.ebmFadeEffect||a.ebmScaleEffect){if(a.ebmFadeEffect){SetElemOpacity(a,0)
}if(ebmScaleEffect>0){ebmResetElementScale(a)}if(a.ebmFadeTimer){clearTimeout(a.ebmFadeTimer);a.ebmFadeTimer=null}}}}function ebmAddRemoveClass(e,g,f,d){if(d){e.className=e.className.replace(" "+f,"")}else{if(e.className.indexOf(f)==-1){e.className+=" "+f}}for(var c=0;c<g.length;c++){var b=e.firstChild;while(g[c]&&b){if(b.nodeName.toLowerCase()==g[c]){ebmAddRemoveClass(b,g,f,d)}b=b.nextSibling}}}function ebmGenerateTree(menuUL,upperTR,depth,className,idName){var re=/^([a-zA-Z]*?\:\/\/)?[^\(\)\:]*?(\?.*)?$/;var rejs=/^(javascript\:)/;var li=menuUL.firstChild;while(li){if(li.nodeName.toLowerCase()=="li"){if(depth!=0){var itemLink=li.firstChild;while(itemLink){if(itemLink.nodeName.toLowerCase()=="a"){if(itemLink.href&&(!itemLink.target||itemLink.target.toLowerCase()=="_self")){itemLink.onclick=function(e){if(!e){var e=window.event}e.cancelBubble=true;if(e.stopPropagation){e.stopPropagation()}};if(itemLink.href.match(re)){li.rowClickLink=itemLink.href;li.onclick=function(){window.location.href=this.rowClickLink;
return false}}else{if(itemLink.href.match(rejs)){li.rowClickLink=itemLink.href;li.onclick=function(){eval(this.rowClickLink)}}}}else{if(!itemLink.href){li.onclick=function(){if(this.assocmenu){this.makeExpanded();ebmDisplaySubmenu(this.assocmenu,this,1)}}}}}itemLink=itemLink.nextSibling}}else{ebmAddRemoveClass(li,["a","div"],"topitem",false)}if(depth!=0){li.onmouseover=function(){ebmAddRemoveClass(this,["a"],"subitemhot",false);if(this.assocmenu){this.makeExpanded();ebmDisplaySubmenu(this.assocmenu,this,1)}};li.onmouseout=function(){ebmAddRemoveClass(this,["a"],"subitemhot",true);if(this.assocmenu){meDoMouseOut(this.assocmenu)}};li.makeExpanded=function(){ebmAddRemoveClass(this,["a"],"subexpanded",false)};li.makeNormal=function(){ebmAddRemoveClass(this,["a"],"subexpanded",true)}}else{var lia;var itemLink=li.firstChild;while(itemLink){if(itemLink.nodeName.toLowerCase()=="a"){lia=itemLink}itemLink=itemLink.nextSibling}if(lia){lia.parentli=li;var imgOver=false;var imgDown=false;var img=lia.firstChild;
while(img){if(img.nodeName.toLowerCase()=="img"){if(img.className=="normalbutton"){lia.imgNormal=img;lia.imgNormalSrc=img.src}if(img.className=="hoverbutton"){lia.imgOverSrc=img.src;imgOver=img}if(img.className=="downbutton"){lia.imgDownSrc=img.src;imgDown=img}}img=img.nextSibling}if(imgOver){lia.removeChild(imgOver)}if(imgDown){lia.removeChild(imgDown)}if(!lia.href){lia.onmouseover=function(){if(this.assocmenu){meDoShow(this.assocmenu,this.ebmMenuDirection,this)}}}lia.onmouseover=function(){ebmAddRemoveClass(this.parentli,["a","div"],"itemhot",false);if(this.imgNormal&&this.imgOverSrc){var link=this.imgOverSrc;if(isIE&&(window.location.protocol!="file:")){link+="#"}this.imgNormal.src=link}};lia.onmouseout=function(){ebmAddRemoveClass(this.parentli,["a","div"],"itemhot",true);ebmAddRemoveClass(this,["a","div"],"itemdown",true);if(this.imgNormal&&this.imgNormalSrc){this.imgNormal.src=this.imgNormalSrc}};lia.onmousedown=function(){ebmAddRemoveClass(this,["a","div"],"itemdown",false);if(this.imgNormal&&this.imgDownSrc){this.imgNormal.src=this.imgDownSrc
}};lia.onmouseup=function(){ebmAddRemoveClass(this,["a","div"],"itemdown",true);if(this.imgNormal&&this.imgOverSrc){this.imgNormal.src=this.imgOverSrc}else{if(this.imgNormal&&this.imgNormalSrc){this.imgNormal.src=this.imgNormalSrc}}}}li.onmouseover=function(){if(this.assocmenu){meDoShow(this.assocmenu,this.ebmMenuDirection,this)}};li.onmouseout=function(){if(this.imgNormal&&this.imgNormalSrc){this.imgNormal.src=this.imgNormalSrc}if(this.assocmenu){meDoMouseOut(this.assocmenu)}};li.makeExpanded=function(){ebmAddRemoveClass(this,["a","div"],"expanded",false)};li.makeNormal=function(){ebmAddRemoveClass(this,["a","div"],"expanded",true)}}li.menuDiv=menuUL;var ul=li.firstChild;while(ul){if(ul.nodeName.toLowerCase()=="ul"){ul.onmouseout=function(){meDoMouseOut(this)};ul.onmouseover=function(){meDoMouseOver(this)};ul.ebmFadeEffect=ebmFadeEffect;if(depth==0){ul.cbnMenuAlpha=cbnMenuAlpha}if(ebmFadeEffect){SetElemOpacity(ul,0)}else{if(cbnMenuAlpha){SetElemOpacity(ul,ul.cbnMenuAlpha)}}ul.ebmScaleEffect=ebmScaleEffect;
if(ebmScaleEffect>0){ebmResetElementScale(ul)}ul.cbnDefaultDirectionX=cbnDefaultDirectionX;ul.upperTR=li;ul.depth=depth;ul.openSubmenuDiv=0;li.assocmenu=ul;li.ebmMenuDirection=ebmMenuDirection;ebmGenerateTree(ul,li,depth+1,className,idName);break}ul=ul.nextSibling}}li=li.nextSibling}}function meDoShow(d,b,c){var a=d;if(a&&a.style){c.makeExpanded();ebmTickerOff(cbnOpenTopMenu);ebmDisplaySubmenu(a,c,b)}}function meDoMouseOut(a){if(a){ebmTickerOn(cbnOpenTopMenu)}}function meDoMouseOver(a){if(a){ebmTickerOff(a)}}function InitEasyMenu(){GetBrowserInfo();if(isMz&&!cbnMenuAlpha&&!ebmFadeEffect){cbnMenuAlpha=1}if(isIE8orLess){cbnMenuAlpha=0}var a=document.getElementsByTagName("ul");for(var b=0;b<a.length;b++){if(a[b].id&&a[b].id==ebmMenuName+"ebul_table"&&a[b].className.substr(0,ebmMenuName.length+13)==ebmMenuName+"ebul_menulist"){if(isIE6orLess){a[b].style.overflow="hidden"}ebmGenerateTree(a[b],0,0,ebmMenuName+"ebul_menulist","ebul_"+ebmMenuName+"_mdiv");a[b].className=a[b].className.replace("css_menu","")
}}}var cbnOpenTopMenu=0;var cbnMenuAlpha = 0;var ebmFadeEffect = true;var ebmScaleEffect = 0;var ebmMenuDirection = 1;var ebmMenuName = "mbmcp";var cbnDefaultDirectionX = -1;InitEasyMenu();