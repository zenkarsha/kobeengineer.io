#==========================================
# Variables
#==========================================
window.UPLOADING = false
window.IMG_API_URL = '//api.kxg.io/api/v1/'

#==========================================
# Functions
#==========================================
submitting = ->
  dots = window.setInterval((->
    wait = document.getElementById('wait')
    if wait.innerHTML.length > 3
      wait.innerHTML = ''
    else
      wait.innerHTML += '.'
  ), 100)

preview =
  default: ->
    $.ajax
      type: 'post'
      data:
        app_param_text: encodeURIComponent $('#message').val()
        app_param_color: $('#color').val()
        app_param_font: $('#font').val()
      url: window.IMG_API_URL + '/kobeengineer_img'
      success: (response) ->
        $('#preview-image').html response
  itdog: ->
    $.ajax
      type: 'post'
      data:
        message: encodeURIComponent $('#message').val()
        app_param_text: encodeURIComponent $('#message').val()
      url: '/i/dog'
      url: window.IMG_API_URL + '/itdog_img'
      success: (response) ->
        $('#preview-image').html response
  gif: ->
    $.ajax
      type: 'post'
      data:
        app_param_text: encodeURIComponent $('#message').val()
        app_param_color: $('#color').val()
        app_param_font: $('#font').val()
      url: window.IMG_API_URL + '/kobeengineergif_img'
      success: (response) ->
        $('#preview-image').html response
        if $('#preview-image').hasClass 'click-to-refresh'
          $('#preview-image').removeClass 'click-to-refresh'

uploadGif = (key) ->
  url = window.location.protocol + '//' + window.location.hostname + '/i' + key
  $.ajax
    headers: null
    type: 'post'
    data:
      api_key: 'dc6zaTOxFJmzC'
      source_image_url: url
    url: '//upload.giphy.com/v1/gifs'
    success: (r) ->
      if r.data.id
        updateGifUrl key, r.data.id
      else
        headerTo key

updateGifUrl = (key, url) ->
  $.ajax
    type: 'post'
    data:
      url: url
    url: '/updategifurl' + key
    success: (r) ->
      if r.state is 'success'
        headerTo key
      else
        headerTo key

clearInputFile = (f) ->
  if f.value
    try
      f.value = ''
    catch err
    if f.value
      form = document.createElement('form')
      ref = f.nextSibling
      form.appendChild f
      form.reset()
      ref.parentNode.insertBefore f, ref


#==========================================
# Events
#==========================================
$ ->
  $.get window.API_URL + '/status', (response) ->
    if response.success
      $('#success_rate').text response.statistics.success_rate
      $('#today_count').text response.statistics.today_count
      $('#yesterday_count').text response.statistics.yesterday_count

  $('body').delegate '[name="mode"]', 'change', ->
    mode = $(this).val()
    if mode is '3'
      preview.default()
      $('.preview-block').removeClass 'hidden'
      $('.text-image-options-block').removeClass 'hidden'

    if mode is '6'
      preview.itdog()
      $('.preview-block').removeClass 'hidden'

    if mode is '7'
      preview.gif()
      $('.preview-block').removeClass 'hidden'
      $('.text-image-options-block').removeClass 'hidden'

    if mode isnt '3' and mode isnt '6' and mode isnt '7' and $('.preview-block').hasClass('hidden') is false
      $('.preview-block').addClass 'hidden'
      $('.text-image-options-block').addClass 'hidden'

    if mode is '1'
      if $('.image-block').hasClass('hidden') is true
        $('.image-block').removeClass 'hidden'
    else
      if $('.image-block').hasClass('hidden') is false
        $('.image-block').addClass 'hidden'


  $('body').delegate '#color, #font', 'change', ->
    mode = $('[name="mode"]:checked').val()
    if mode is '3' then preview.default()
    if mode is '7' and $('#preview-image').hasClass('click-to-refresh') is false then $('#preview-image').addClass 'click-to-refresh'

  $('body').delegate '#message', 'blur', ->
    mode = $('[name="mode"]:checked').val()
    if mode is '3' then preview.default()
    if mode is '6' then preview.itdog()
    if mode is '7' and $('#preview-image').hasClass('click-to-refresh') is false then $('#preview-image').addClass 'click-to-refresh'

  $('body').delegate '#preview-image', 'click', ->
    mode = $('[name="mode"]:checked').val()
    if mode is '7' then preview.gif()

  $('body').delegate '#message', 'keydown', ->
    mode = $('[name="mode"]:checked').val()
    if mode is '3' or mode is '6' then window.COUNTDOWN = Date.now()

  $('body').delegate '#message', 'keyup', ->
    mode = $('[name="mode"]:checked').val()
    if mode is '3' or mode is '6'
      setTimeout (->
        if Date.now() - window.COUNTDOWN >= 240
          if mode is '3' then preview.default()
          if mode is '6' then preview.itdog()
      ), 250
    else if mode is '7' and $('#preview-image').hasClass('click-to-refresh') is false
      $('#preview-image').addClass 'click-to-refresh'

  $('#image-upload-button').click ->
    $('#image').trigger 'click'

  $('body').delegate '#submit', 'click', ->
    message = $('#message').val()
    image_url = $('#image-url').val()
    mode = $('[name="mode"]:checked').val()
    color = $('#color').val()
    font = $('#font').val()

    if message.length > max_length
      message = message.substring(0, max_length)

    if message is '' and image is ''
      alert alert_content_empty
      $('#message').focus()
      return

    if $('#accept-license').prop('checked') is false
      alert alert_accept_license
      return

    $('#submit').replaceWith '<button type="button" class="btn btn-warning btn-lg btn-block" disabled="disabled" id="processing">' + processing + '<span id="wait"></span></button>'
    data =
      message: encodeURIComponent message
      mode: mode
      image_url: image_url
      color: color
      font: font

    submitting()

    $.ajax
      type: 'post'
      dataType: 'json'
      cache: false
      data: data
      url: window.API_URL + '/submit'
      error: (response) ->
        xx response
      success: (response) ->
        if response.success
          headerTo response.redirct_url
        else
          headerTo '/'
