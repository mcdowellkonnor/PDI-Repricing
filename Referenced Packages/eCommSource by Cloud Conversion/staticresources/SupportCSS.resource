@charset "UTF-8";
/* CSS Document */

/* general styles ================================================================================ */
body 								{ margin: 0px 0px 1px 0px; padding: 0px; height: 100%; background: url(http://www.cloudconversion.com/kb/images/hdr-bg.jpg) repeat-x; overflow-y: scroll; color: #999; } 
#container 							{ margin: 0px auto; height: auto; width: 960px; }
a 									{ outline: 0; }
div#returns-form					{ width: 615px; float: left; }
/* header content ================================================================================ */
#container .kb-head 				{ float: left; height: 80px; width: 960px; position: relative; }
#container .kb-top-nav 				{ float: left; height: 36px; width: 948px; background: #256797; padding-left: 12px; }
#container .kb-top-nav ul 			{ margin: 0px; padding: 0px; list-style: none; }
#container .kb-top-nav ul li 		{ float: left; }
#container .kb-top-nav ul li a 		{ display: block; padding: 8px; margin-right: 15px; font-family: "Helvetica Neue", Helvetica, Arial, sans-serif; color: #FFF; text-decoration: none; }
#container .kb-top-nav ul li a:hover { display: block; padding: 8px; margin-right: 15px; font-family: "Helvetica Neue", Helvetica, Arial, sans-serif; color: #fff; text-decoration: none; background: #44a1cf; }

/* top five ================================================================================ */
#container .kb-banner 				{ background: url(http://www.cloudconversion.com/kb/images/kb-banner.jpg) no-repeat; float: left; height: 95px; width: 960px; margin-top: 10px; }
#container .top-five 				{ background: url(http://www.cloudconversion.com/kb/images/top5-bg.jpg) no-repeat; padding: 10px; float: left; height: 200px; width: 650px; margin-right: 20px; }
#container .top-five ul 			{ margin: 0px; padding: 0px; list-style: none; }
#container .top-five ul li a 		{ display: block; padding-top: 7px; padding-bottom: 7px; text-decoration: none; color: #256797; padding-left: 165px; background: url(http://www.cloudconversion.com/kb/images/kb-rating5.png) no-repeat left center; border-bottom: 1px dotted #999; font: 16px "Helvetica Neue", Helvetica, Arial, sans-serif; }
#container .top-five ul li a:hover 		{ display: block; padding-top: 7px; padding-bottom: 7px; text-decoration: none; color: #22A5C4; padding-left: 165px; background: url(http://www.cloudconversion.com/kb/images/kb-rating5.png) no-repeat left center; border-bottom: 1px dotted #999; font: 16px "Helvetica Neue", Helvetica, Arial, sans-serif; }
#container .top-five ul .top-five-last a,#container .top-five ul .top-five-last a:hover { border-style: none; } { border-style: none; }
#container .top-five h3 			{ margin: 0px 0px 7px; padding: 0px; font: normal 18px "Helvetica Neue", Helvetica, Arial, sans-serif; color: #256797; }

/* kb right ================================================================================ */
#container .kb-right-links 			{ float: right; height: auto; width: 270px; margin-top: 10px; }
#container .kb-right-links ul 		{ margin: 0px; padding: 0px; list-style: none; }
#container .kb-right-links ul li a img { border-style: none; }
#container .kb-right-links ul li 	{ margin-bottom: 5px; }

/* right side gallery ================================================================================ */
#container .kb-right-links ul.gallery {
	width: 270px; /*--Adjust width according to your scenario--*/
	list-style: none;
	margin: 0; padding: 0;
}
#container .kb-right-links ul.gallery li { float: left; margin: 0px 0px 5px; padding: 0; text-align: center; display: inline; /*--Gimp Fix aka IE6 Fix - Fixes double margin bug--*/ }
#container .kb-right-links ul.gallery li a.thumb {
	width: 270px; /*--Width of image--*/
	height: 85px; /*--Height of image--*/
	cursor: pointer;
}
#container .kb-right-links ul.gallery li span { /*--Used to crop image--*/
	width: 270px;
	height: 85px;
	overflow: hidden;
	display: block;
}
#container .kb-right-links ul.gallery li a.thumb:hover {
	background: #333; /*--Hover effect for browser with js turned off--*/
}
#container .kb-right-links ul.gallery li h2 {
	font-size: 1em;
	font-weight: normal;
	text-transform: uppercase;
	margin: 0; padding: 00px;
	background: #f0f0f0;
	border-top: 1px solid #fff; /*--Subtle bevel effect--*/
}
#container .kb-right-links ul.gallery li a 							{text-decoration: none; color: #777; display: block;}
#container .kb-frame 												{ float: left; height: 515px; width: 670px; position: relative; }
#container #kb-review 												{ background: url(http://www.cloudconversion.com/kb/images/kb-review.jpg) no-repeat; float: left; height: 39px; width: 670px; margin-top: 10px; margin-bottom: 10px; position: absolute; left: 0px; top: 0px; }
#container .kb-wrap 												{ float: left; height: auto; width: 960px; }
#container .kb-wrap .kb-frame iframe 								{ margin-top: 13px; float: left; }
#container .kb-wrap .kb-content 									{ float: left; height: auto; width: 670px; margin-top: 10px; position: relative; }

/* support center form ================================================================================ */

#support-center 													{ float: left; height: auto; width: 670px; margin-left: 15px; }
#support-center .sc-title 											{
	float: left;
	height: 55px;
	width: 633px;
	background: #FFF url(/form/http://www.cloudconversion.com/kb/images/support-title-bg.jpg) repeat-x bottom;
}
#support-center .sc-title h2 										{ font: 400 20px Arial, Helvetica, sans-serif; color: #79c700; border: none; }
#support-center .sc-title h2 span 									{ color: #0fb1dc; }
#support-center .sc-wrapper 										{ float: left; height: auto; width: 670px; min-height: 413px; }
#support-center .sc-wrapper .sc-top-text 							{ color: #686868; font: 12px Arial, Helvetica, sans-serif; float: left; height: auto; width: 633px; margin-bottom: 30px; margin-top: 5px; }
#support-center .sc-wrapper .sc-top-text p 							{ margin: 0px; }
#support-center .sc-wrapper .sc-top-list 							{ float: left; height: 210px; width: 320px; }
#support-center .sc-wrapper .sc-top-list ul li 						{ float: left; width: 290px; }
#support-center .sc-wrapper .sc-top-list ul li h3 					{ margin: 0px 0px 3px 0px; color: #0fb0db; font: normal 16px Arial, Helvetica, sans-serif; border: none; }
#support-center .sc-wrapper .sc-top-list ul li p 					{ margin: 0px; padding: 0px; color: #908f8f; font: 12px Arial, Helvetica, sans-serif; }
#support-center .sc-wrapper .sc-top-list ul 						{ margin: 0px; padding: 0px; list-style: none; }
#support-center .sc-wrapper .sc-top-list ul li 						{ display: block; padding-left: 30px; height: 63px; margin-bottom: 10px; }
#support-center .sc-wrapper .sc-top-list ul .sc1 					{ background: url(/form/http://www.cloudconversion.com/kb/images/sc-bullet1.jpg) no-repeat left center; }
#support-center .sc-wrapper .sc-top-list ul .sc2 					{ background: url(/form/http://www.cloudconversion.com/kb/images/sc-bullet2.jpg) no-repeat left center; }
#support-center .sc-wrapper .sc-top-list ul .sc3 					{ background: url(/form/http://www.cloudconversion.com/kb/images/sc-bullet3.jpg) no-repeat left center; }
#support-center .sc-wrapper #top-kb-link 							{ float: left; height: 210px; width: 235px; margin-left: 20px; background: url(/form/http://www.cloudconversion.com/kb/images/sc-div_03.png) no-repeat left; padding-left: 45px; }
#support-center .sc-wrapper #top-kb-link img 						{ margin-top: 10px; }
#support-center .sc-form 											{ float: left; height: auto; width: 670px; margin-top: 25px; margin-bottom: 30px; border-top: 1px solid #dfdfdf; padding-top: 15px; position: relative; }
#support-center .sc-wrapper .sc-form h3 							{ color: #79c700; font: normal 16px Arial, Helvetica, sans-serif; margin: 0px; border: none; }
#support-center .sc-wrapper .sc-form .sc-form-label 				{ font: 14px Arial, Helvetica, sans-serif; color: #0079a9; float: left; height: 31px; width: 120px; margin-bottom: 10px; }
#support-center .sc-wrapper .sc-form .sc-form-input 				{ font: 14px Arial, Helvetica, sans-serif; color: #333; float: left; min-height: 31px; height: auto; width: 498px; margin-left: 15px; margin-bottom: 10px; background: url(http://www.cloudconversion.com/kb/images/req.jpg) no-repeat 300px center; }
#support-center .sc-wrapper .sc-form form .sc-form-input input 		{ height: 29px; width: 278px; border: 1px solid #2cb9df; font-size: 14px; color: #666; padding: 3px; }
#support-center .sc-wrapper .sc-form form .sc-form-label label 		{ margin-top: 7px; float: right; }
#support-center .sc-wrapper .sc-form form .sc-h3 					{ float: left; width: 633px; margin-bottom: 15px; }
#support-center .sc-wrapper .sc-form form .sc-form-input select 	{ height: 29px; width: 225px; border: 1px solid #2cb9df; font-size: 14px; color: #666; padding: 3px; }
#support-center .sc-wrapper .sc-form form .sc-form-label span	  	{ float: right; margin-top: 6px; }

#support-center .sc-wrapper .sc-form form .sc-form-input textarea 	{ height: 129px; width: 278px; border: 1px solid #2cb9df; font-size: 14px; color: #666; padding: 3px; }
#support-center .sc-wrapper .sc-form form .sc-submit 			  	{ float: left; height: auto; width: 490px; padding-left: 135px; }
#support-center .sc-wrapper .sc-form form .sc-submit input 		  	{ font: 14px Arial, Helvetica, sans-serif; color: #FFF; background: #0079aa; display: block; float: left; height: 29px; width: 176px; border-style: none; }
#support-center .sc-wrapper .sc-form form .sc-opts 					{ float: left; height: auto; width: 633px; }
#load { display: none; margin: 300px auto 0px auto; background: #FFF url(http://www.cloudconversion.com/kb/images/ajax-loader.gif); width: 220px; height: 19px; text-indent: -9999em; position: absolute; left: 250px; top: 100px; z-index: 999999; }#container .kb-wrap .kb-head p { color: #0079A9; font: 18px "Helvetica Neue", Helvetica, Arial, sans-serif; float: right; margin: 0px; padding: 0px; position: absolute; top: 35px; right: 0px; }
#container .kb-wrap .kb-head a { float: left; }

/* support videos ================================================================================ */

#support-center .sc-wrapper .vid-hdr 								{ float: left; height: 72px; width: 617px; margin-top: 15px; background-image: url(http://www.cloudconversion.com/kb/images/video-support-hdr.jpg); background-repeat: no-repeat; }
#support-center .sc-wrapper .vid-sel 								{ float: left; height: auto; width: 617px; margin-top: 30px; }
#support-center .sc-wrapper .vid-sel h2 							{ font-family: "Helvetica Neue", Helvetica, Arial, sans-serif; font-weight: normal; font-size: 24px; color: #96bad2; display: block; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #e1ebed; padding: 0px 0px 5px 0px; margin: 0px 0px 10px 0px; }
#support-center .sc-wrapper .vid-sel ul 							{ margin: 0px; padding: 0px; list-style-type: none; }
#support-center .sc-wrapper .vid-sel ul li 							{ font-family: "Helvetica Neue", Helvetica, Arial, sans-serif; font-size: 14px; color: #96bad2; float: left; display: block; width: 300px; padding-top: 10px; padding-bottom: 12px; background-image: url(http://www.cloudconversion.com/kb/images/video-play.jpg); background-repeat: no-repeat; background-position: left center; margin-right: 8px; }
#support-center .sc-wrapper .vid-sel ul li a.video 					{ font-family: "Helvetica Neue", Helvetica, Arial, sans-serif; font-size: 14px; color: #96bad2; text-decoration: none; margin-left: 35px; }
#support-center .sc-wrapper .vid-sel ul li a:hover.video 			{ font-family: "Helvetica Neue", Helvetica, Arial, sans-serif; font-size: 14px; color: #b0d77a; text-decoration: none; margin-left: 35px; }

#validEmail
		{
			margin-top: 4px;
			margin-left: 9px;
			position: absolute;
			width: 16px;
			height: 16px;
		}
