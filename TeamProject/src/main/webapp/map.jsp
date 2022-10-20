<%@page import="membership.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" http-equiv="Content-Security-Policy" content="upgrade-insecure-requests">
<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
<link rel = "stylesheet" href="resource/css/NewFile.css">
<link rel="stylesheet" type="text/css" href="css/map.css" />
<title>Insert title here</title>
</head>
<body>
<jsp:include page="menu.jsp" />
<div class="map_wrap">
    <div id="map" style="width:100%;height:250%;position:relative;overflow:hidden; margin: auto;"></div>
    <ul class="" id="category">
        <li id="CS2" data-order="5" onclick="onClickCategory();"> 
            <span class="category_bg store" ></span>
            편의점
        </li>
        <li id="" data-order="4" >            
            키워드 검색
        </li>    
                        <div>
<form action="Map.map?Keyword=Keyword">
<input type="text" name=keyword>
<input type="submit" value="검색">
</form></div>    
    </ul>
</div>
<p><em>지도를 클릭해주세요!</em></p> 
<div id="clickLatlng"></div>

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=def47418c26c1b2e8383afc08b8370c5&libraries=services,clusterer"></script>
<script>
// 마커를 클릭했을 때 해당 장소의 상세정보를 보여줄 커스텀오버레이입니다
var placeOverlay = new kakao.maps.CustomOverlay({zIndex:1}), 
    contentNode = document.createElement('div'), // 커스텀 오버레이의 컨텐츠 엘리먼트 입니다 
    markers = [], // 마커를 담을 배열입니다
    currCategory = ''; // 현재 선택된 카테고리를 가지고 있을 변수입니다
 
var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
    mapOption = {
        center: new kakao.maps.LatLng(37.566826, 126.9786567), // 지도의 중심좌표
        level: 3 // 지도의 확대 레벨
    };  

// 지도를 생성합니다    
var map = new kakao.maps.Map(mapContainer, mapOption); 

// 마커 클러스터러를 생성합니다 
var clusterer = new kakao.maps.MarkerClusterer({
    map: map, // 마커들을 클러스터로 관리하고 표시할 지도 객체 
    averageCenter: true, // 클러스터에 포함된 마커들의 평균 위치를 클러스터 마커 위치로 설정 
    minLevel: 5 // 클러스터 할 최소 지도 레벨 
});

<%
String space = "''";
String keyword_ = "\""+request.getParameter("keyword")+"\"";
System.out.println(keyword_);
%>
var keyword = <%=request.getParameter("keyword")==null ? space : keyword_%>;
console.log(keyword);
//HTML5의 geolocation으로 사용할 수 있는지 확인합니다
if (navigator.geolocation && keyword == '') { 
	// GeoLocation을 이용해서 접속 위치를 얻어옵니다 
 navigator.geolocation.getCurrentPosition(function(position) {
 	console.log('지오로케이션');    
     var lat = position.coords.latitude, // 위도
         lon = position.coords.longitude; // 경도
     
     var locPosition = new kakao.maps.LatLng(lat, lon), // 마커가 표시될 위치를 geolocation으로 얻어온 좌표로 생성합니다
         message = '<div style="padding:5px;">현재 위치</div>'; // 인포윈도우에 표시될 내용입니다
     
     // 마커와 인포윈도우를 표시합니다
     displayMarker(locPosition, message);         
   }); 
}else { // HTML5의 GeoLocation을 사용할 수 없을때 마커 표시 위치와 인포윈도우 내용을 설정합니다
	console.log('지오로케이션 실패');    
/*  var locPosition = new kakao.maps.LatLng(33.450701, 126.570667),    
     message = 'geolocation을 사용할수 없어요, 키워드를 입력해주세요'
     
 displayMarker(locPosition, message);
  */
  function placesSearchCB(data, status, pagination) {
	    if (status === kakao.maps.services.Status.OK) {
	    	 var bounds = new kakao.maps.LatLngBounds();
	        // 정상적으로 검색이 완료됐으면 지도에 마커를 표출합니다
	        displayPlaces(data);
	        for (var i=0; i<data.length; i++) {
	        //    displayMarker(data[i]);    
	            bounds.extend(new kakao.maps.LatLng(data[i].y, data[i].x));
	        } 
	        // 검색된 장소 위치를 기준으로 지도 범위를 재설정합니다
	        map.setBounds(bounds);        
	    }
	}
}
 
//지도에 마커와 인포윈도우를 표시하는 함수입니다
function displayMarker(locPosition, message) {

    // 마커를 생성합니다
    var marker = new kakao.maps.Marker({  
        map: map, 
        position: locPosition
    }); 
    
    var iwContent = message, // 인포윈도우에 표시할 내용
        iwRemoveable = true;

    // 인포윈도우를 생성합니다
    var infowindow = new kakao.maps.InfoWindow({
        content : iwContent,
        removable : iwRemoveable
    });
    
    // 인포윈도우를 마커위에 표시합니다 
    infowindow.open(map, marker);
    
    // 지도 중심좌표를 접속위치로 변경합니다
    map.setCenter(locPosition);      
}    

// 장소 검색 객체를 생성합니다
var ps = new kakao.maps.services.Places(map); 

// 지도에 idle 이벤트를 등록합니다 ..> 이게 문제 였음, 키워드 화면 전환 에러
if(keyword == '') kakao.maps.event.addListener(map, 'idle', searchPlaces);

// 커스텀 오버레이의 컨텐츠 노드에 css class를 추가합니다 
contentNode.className = 'placeinfo_wrap';

// 커스텀 오버레이의 컨텐츠 노드에 mousedown, touchstart 이벤트가 발생했을때
// 지도 객체에 이벤트가 전달되지 않도록 이벤트 핸들러로 kakao.maps.event.preventMap 메소드를 등록합니다 
 addEventHandle(contentNode, 'mousedown', kakao.maps.event.preventMap);
addEventHandle(contentNode, 'touchstart', kakao.maps.event.preventMap);

// 커스텀 오버레이 컨텐츠를 설정합니다
placeOverlay.setContent(contentNode);  

// 각 카테고리에 클릭 이벤트를 등록합니다
addCategoryClickEvent();

// 엘리먼트에 이벤트 핸들러를 등록하는 함수입니다
 function addEventHandle(target, type, callback) {
    if (target.addEventListener) {
        target.addEventListener(type, callback);
    } else {
        target.attachEvent('on' + type, callback);
    }
} 

// 카테고리 검색을 요청하는 함수입니다
function searchPlaces() {
    if (!currCategory) {
        return;
    }
    
    // 커스텀 오버레이를 숨깁니다 
    placeOverlay.setMap(null);

    // 지도에 표시되고 있는 마커를 제거합니다
   removeMarker();
   
    ps.categorySearch(currCategory, placesSearchCB, {useMapBounds:true}); 
}
ps.keywordSearch(keyword, placesSearchCB); 
console.log(ps.keywordSearch);
// 장소검색이 완료됐을 때 호출되는 콜백함수 입니다
function placesSearchCB(data, status, pagination) {
    if (status === kakao.maps.services.Status.OK) {
    	 //var bounds = new kakao.maps.LatLngBounds();
        // 정상적으로 검색이 완료됐으면 지도에 마커를 표출합니다
        displayPlaces(data);
        for (var i=0; i<data.length; i++) {
        //    displayMarker(data[i]);    
          //  bounds.extend(new kakao.maps.LatLng(data[i].y, data[i].x));
        } 
        // 검색된 장소 위치를 기준으로 지도 범위를 재설정합니다
        //if(keyword !='') map.setBounds(bounds);        
    } else if (status === kakao.maps.services.Status.ZERO_RESULT) {
        // 검색결과가 없는경우 해야할 처리가 있다면 이곳에 작성해 주세요

    } else if (status === kakao.maps.services.Status.ERROR) {
        // 에러로 인해 검색결과가 나오지 않은 경우 해야할 처리가 있다면 이곳에 작성해 주세요
        
    }
}

// 지도에 마커를 표출하는 함수입니다
function displayPlaces(places) {
	 
    // 몇번째 카테고리가 선택되어 있는지 얻어옵니다
    // 이 순서는 스프라이트 이미지에서의 위치를 계산하는데 사용됩니다
    var order = document.getElementById(currCategory).getAttribute('data-order');    
    console.log(document.getElementById(currCategory));
	var markers =[];
    for ( var i=0; i<places.length; i++ ) {

            // 마커를 생성하고 지도에 표시합니다
            var marker = addMarker(new kakao.maps.LatLng(places[i].y, places[i].x), order);
			markers.push(marker);
            // 마커와 검색결과 항목을 클릭 했을 때
            // 장소정보를 표출하도록 클릭 이벤트를 등록합니다
            (function(marker, place) {
                kakao.maps.event.addListener(marker, 'click', function() {
                    displayPlaceInfo(place);
                });
            })(marker, places[i]);
    }

    //clusterer.removeMarkers( markers );
     clusterer.addMarkers(markers);    
    for(var i=0; i<clusterer._markers.length; i++){    	
    	for(var j=0; j<i; j++){
    		if(JSON.stringify(clusterer._markers[i].n) === JSON.stringify(clusterer._markers[j].n)){    			
        		//console.log(clusterer._markers[i].n);
        		clusterer.removeMarkers(markers);
        		break;
        	}
    	}
    }
}

// 마커를 생성하고 지도 위에 마커를 표시하는 함수입니다
function addMarker(position, order) {
	
    var imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/places_category.png', // 마커 이미지 url, 스프라이트 이미지를 씁니다
        imageSize = new kakao.maps.Size(27, 28),  // 마커 이미지의 크기
        imgOptions =  {
            spriteSize : new kakao.maps.Size(72, 208), // 스프라이트 이미지의 크기
            spriteOrigin : new kakao.maps.Point(46, (order*36)), // 스프라이트 이미지 중 사용할 영역의 좌상단 좌표
            offset: new kakao.maps.Point(11, 28) // 마커 좌표에 일치시킬 이미지 내에서의 좌표
        },
        markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imgOptions),
            marker = new kakao.maps.Marker({
            position: position, // 마커의 위치
            image: markerImage 
        });

    marker.setMap(map); // 지도 위에 마커를 표출합니다
    markers.push(marker);  // 배열에 생성된 마커를 추가합니다 
	    
    // 클러스터러에 마커들을 추가합니다
    //clusterer.addMarkers(markers);
    
    //console.log(markers);

    
    return marker;
}

// 지도 위에 표시되고 있는 마커를 모두 제거합니다
function removeMarker() {
    for ( var i = 0; i < markers.length; i++ ) {
        markers[i].setMap(null);
    }   
    markers = [];
    
}
function dpSubmit() {
	
}
// 클릭한 마커에 대한 장소 상세정보를 커스텀 오버레이로 표시하는 함수입니다
function displayPlaceInfo (place) {
    var content = '<div class="overlaybox">' +
                    '   <a class="boxtitle" href="' + place.place_url + '" target="_blank" title="' + place.place_name + '">' + place.place_name + '</a>';           
                 
	
    if (place.road_address_name) {
        content += '  <li class = "up" style="width : 95%;><span class="title" title="' + place.road_address_name + '">' + place.road_address_name + '</span>' +
                    '  <span class="jibun" title="' + place.address_name + '"></span></li>';
    }  else {
        content += '    <span title="' + place.address_name + '">' + place.address_name + '</span>';
    }                
	content += '<form action="Map.map?inputmap=inputmap" method="post" name="frm">'+                    
    '<input type="hidden" name="lat" value="'+place.y+'">'+'<input type="hidden" name="lon" value="'+place.x+'">'+
    '<input type="hidden" name="title" value="'+place.place_name+'">'+
    '<input class="form-control" placeholder="내용" type="text" style="margin: auto; width: 80%;" name ="memo">' + '<input class="btn btn-primary" type="submit" value ="전송">'+
    '</form>'+
    '<div>'+                   
    '<div>';   
    
    content += '    <li class ="up" style="width : 95%;"><span class="tel">' + place.phone + '</span></li>' + 
                '</div>' + 
                '<div class="after"></div>';

               
                
    contentNode.innerHTML = content;
    
    placeOverlay.setPosition(new kakao.maps.LatLng(place.y, place.x));
    placeOverlay.setMap(map);  
}


// 각 카테고리에 클릭 이벤트를 등록합니다
 function addCategoryClickEvent() {
    var category = document.getElementById('category'),
        children = category.children;

    for (var i=0; i<children.length; i++) {
        children[i].onclick = onClickCategory;
    }
}

// 카테고리를 클릭했을 때 호출되는 함수입니다
function onClickCategory() {
    var id = this.id,
        className = this.className;

    placeOverlay.setMap(null);

     if (className === 'on') {
        currCategory = '';
        changeCategoryClass();
        removeMarker(); 
        
     } else { 
        currCategory = id;
        changeCategoryClass(this);
        searchPlaces();
     }
}
//setTimeout(onClickCategory,100);
//setTimeout(onClickCategory,1000);
// 클릭된 카테고리에만 클릭된 스타일을 적용하는 함수입니다
 function changeCategoryClass(el) {
 
    var category = document.getElementById('category'),
        children = category.children,
        i;

    for ( i=0; i<children.length; i++ ) {
        children[i].className = '';
    }
    /* var cat = document.getElementById('CS2');
	cat.className = 'on';
	searchPlaces();
	alert(cat.className); */
      if (el) { 
        el.className = 'on';
     }    
} 
/* changeCategoryClass(); */
//console.log(document.getElementById("CS2"));
document.getElementById("CS2").click();

//지도를 클릭한 위치에 표출할 마커입니다
var marker = new kakao.maps.Marker({ 
    // 지도 중심좌표에 마커를 생성합니다 
    position: 0 
}); 
// 지도에 마커를 표시합니다
marker.setMap(map);

// 지도에 클릭 이벤트를 등록합니다
// 지도를 클릭하면 마지막 파라미터로 넘어온 함수를 호출합니다
var infowindow;
kakao.maps.event.addListener(map, 'click', function(mouseEvent) {        
	if(infowindow != undefined)infowindow.close();
    // 클릭한 위도, 경도 정보를 가져옵니다 
    var latlng = mouseEvent.latLng; 
    
    // 마커 위치를 클릭한 위치로 옮깁니다
    marker.setPosition(latlng);
    var lat = latlng.getLat();
    var lon = latlng.getLng();
    
    var iwContent ='<form action="Map.map?inputmap=inputmap" method="post">'+
    	'<input class="form-control" placeholder="편의점명" type="text" name="title">'+
    	'<input class="form-control" placeholder="내용" type="text" name="memo">'+
    	'<input type="hidden" name="lat" value="'+lat+'">'+'<input type="hidden" name="lon" value="'+lon+'">'+
    	'<input class="btn btn-primary" type="submit" value ="전송">'+
    	'</form>'
    	, // 인포윈도우에 표출될 내용으로 HTML 문자열이나 document element가 가능합니다
    iwPosition = new kakao.maps.LatLng(lat, lon), //인포윈도우 표시 위치입니다
    iwRemoveable = true; // removeable 속성을 ture 로 설정하면 인포윈도우를 닫을 수 있는 x버튼이 표시됩니다
	
    function panTo() {
		var moveLatLon = latlng;
		
		map.panTo(moveLatLon);
	}
// 인포윈도우를 생성하고 지도에 표시합니다
		infowindow = new kakao.maps.InfoWindow({
    	map: map, // 인포윈도우가 표시될 지도
    	position : iwPosition, 
    	content : iwContent,
    	removable : iwRemoveable
    	
});
	    
		panTo();		
		
		
});
</script>

</body>
</html>