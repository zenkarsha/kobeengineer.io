var clearInputFile,preview,submitting,updateGifUrl,uploadGif;window.UPLOADING=!1,window.IMG_API_URL="//api.kxg.io/api/v1/",submitting=function(){var e;return e=window.setInterval(function(){var e;return e=document.getElementById("wait"),e.innerHTML.length>3?e.innerHTML="":e.innerHTML+="."},100)},preview={default:function(){return $.ajax({type:"post",data:{app_param_text:encodeURIComponent($("#message").val()),app_param_color:$("#color").val(),app_param_font:$("#font").val()},url:window.IMG_API_URL+"/kobeengineer_img",success:function(e){return $("#preview-image").html(e)}})},itdog:function(){return $.ajax({type:"post",data:{message:encodeURIComponent($("#message").val()),app_param_text:encodeURIComponent($("#message").val())},url:"/i/dog",url:window.IMG_API_URL+"/itdog_img",success:function(e){return $("#preview-image").html(e)}})},gif:function(){return $.ajax({type:"post",data:{app_param_text:encodeURIComponent($("#message").val()),app_param_color:$("#color").val(),app_param_font:$("#font").val()},url:window.IMG_API_URL+"/kobeengineergif_img",success:function(e){if($("#preview-image").html(e),$("#preview-image").hasClass("click-to-refresh"))return $("#preview-image").removeClass("click-to-refresh")}})}},uploadGif=function(e){var a;return a=window.location.protocol+"//"+window.location.hostname+"/i"+e,$.ajax({headers:null,type:"post",data:{api_key:"dc6zaTOxFJmzC",source_image_url:a},url:"//upload.giphy.com/v1/gifs",success:function(a){return a.data.id?updateGifUrl(e,a.data.id):headerTo(e)}})},updateGifUrl=function(e,a){return $.ajax({type:"post",data:{url:a},url:"/updategifurl"+e,success:function(a){return"success"===a.state?headerTo(e):headerTo(e)}})},clearInputFile=function(e){var a,t,i;if(e.value){try{e.value=""}catch(e){a=e}if(e.value)return t=document.createElement("form"),i=e.nextSibling,t.appendChild(e),t.reset(),i.parentNode.insertBefore(e,i)}},$(function(){return $.get(window.API_URL+"/status",function(e){if(e.success)return $("#success_rate").text(e.statistics.success_rate),$("#today_count").text(e.statistics.today_count),$("#yesterday_count").text(e.statistics.yesterday_count)}),$("body").delegate('[name="mode"]',"change",function(){var e;if(e=$(this).val(),"3"===e&&(preview.default(),$(".preview-block").removeClass("hidden"),$(".text-image-options-block").removeClass("hidden")),"6"===e&&(preview.itdog(),$(".preview-block").removeClass("hidden")),"7"===e&&(preview.gif(),$(".preview-block").removeClass("hidden"),$(".text-image-options-block").removeClass("hidden")),"3"!==e&&"6"!==e&&"7"!==e&&$(".preview-block").hasClass("hidden")===!1&&($(".preview-block").addClass("hidden"),$(".text-image-options-block").addClass("hidden")),"1"===e){if($(".image-block").hasClass("hidden")===!0)return $(".image-block").removeClass("hidden")}else if($(".image-block").hasClass("hidden")===!1)return $(".image-block").addClass("hidden")}),$("body").delegate("#color, #font","change",function(){var e;if(e=$('[name="mode"]:checked').val(),"3"===e&&preview.default(),"7"===e&&$("#preview-image").hasClass("click-to-refresh")===!1)return $("#preview-image").addClass("click-to-refresh")}),$("body").delegate("#message","blur",function(){var e;if(e=$('[name="mode"]:checked').val(),"3"===e&&preview.default(),"6"===e&&preview.itdog(),"7"===e&&$("#preview-image").hasClass("click-to-refresh")===!1)return $("#preview-image").addClass("click-to-refresh")}),$("body").delegate("#preview-image","click",function(){var e;if(e=$('[name="mode"]:checked').val(),"7"===e)return preview.gif()}),$("body").delegate("#message","keydown",function(){var e;if(e=$('[name="mode"]:checked').val(),"3"===e||"6"===e)return window.COUNTDOWN=Date.now()}),$("body").delegate("#message","keyup",function(){var e;return e=$('[name="mode"]:checked').val(),"3"===e||"6"===e?setTimeout(function(){if(Date.now()-window.COUNTDOWN>=240&&("3"===e&&preview.default(),"6"===e))return preview.itdog()},250):"7"===e&&$("#preview-image").hasClass("click-to-refresh")===!1?$("#preview-image").addClass("click-to-refresh"):void 0}),$("#image-upload-button").click(function(){return $("#image").trigger("click")}),$("body").delegate("#submit","click",function(){var e,a,t,i,n,r;return n=$("#message").val(),i=$("#image-url").val(),r=$('[name="mode"]:checked').val(),e=$("#color").val(),t=$("#font").val(),n.length>max_length&&(n=n.substring(0,max_length)),""===n&&""===image?(alert(alert_content_empty),void $("#message").focus()):$("#accept-license").prop("checked")===!1?void alert(alert_accept_license):($("#submit").replaceWith('<button type="button" class="btn btn-warning btn-lg btn-block" disabled="disabled" id="processing">'+processing+'<span id="wait"></span></button>'),a={message:encodeURIComponent(n),mode:r,image_url:i,color:e,font:t},submitting(),$.ajax({type:"post",dataType:"json",cache:!1,data:a,url:window.API_URL+"/submit",error:function(e){return xx(e)},success:function(e){return e.success?headerTo(e.redirct_url):headerTo("/")}}))})});