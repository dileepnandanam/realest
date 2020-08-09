$(document).on('turbolinks:load', function() {
  fill_map_link()
  $('.free').click(function(e) {
    locate_post()
    e.preventDefault()
  })

  $('.busy').click(function(e) {
    $(this).css('background-color', 'red')
    vanish_post_location()
    e.preventDefault()
  })
  
  $('.i-am-here').click(function(e) {
    $(this).css('background-color', 'red')
    var that = this
    setTimeout(function() {$(that).css('background-color', 'transparent')}, 1000)
    locate_me()
    e.preventDefault()
  })
})

fill_map_link = function() {
  $('.map-link').on('click', function() {
    if( (navigator.platform.indexOf("iPhone") != -1) 
      || (navigator.platform.indexOf("iPod") != -1)
      || (navigator.platform.indexOf("iPad") != -1))
        window.open("maps://maps.google.com/maps?daddr="+ $(this).data('addr') +"&amp;ll=");
    else
      window.open("http://maps.google.com/maps?daddr="+ $(this).data('addr') +"&amp;ll=");
  })
}

locate_me = function() {
  navigator.geolocation.getCurrentPosition(send_user_location);
}

locate_post = function() {
  $('.free').css('background-color','red')
  navigator.geolocation.getCurrentPosition(send_post_location);
}

send_post_location = function(position) {
  var id = $('.post').data('id')
  $.ajax({
    url: '/posts/' + id + '/locate',
    beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
    method: 'PUT',
    data: {
      lat: position.coords.latitude,
      lngt: position.coords.longitude
    },
    success: function() {
      $('.free').css('background-color','blue')
      $('.free').toggleClass('d-none')
      $('.busy').toggleClass('d-none')

    }
  })
}

vanish_post_location = function() {
  var id = $('.post').data('id')
  $.ajax({
    url: '/posts/' + id + '/vanish',
    beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
    method: 'PUT',
    success: function() {
      $('.busy').css('background-color','blue')
      $('.free').toggleClass('d-none')
      $('.busy').toggleClass('d-none')

    }
  })
}

send_user_location = function(position) {
  $.ajax({
    url: '/users/locate',
    beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
    method: 'PUT',
    data: {
      user: {
        lat: position.coords.latitude,
        lngt: position.coords.longitude
      }
    }
  })
}
