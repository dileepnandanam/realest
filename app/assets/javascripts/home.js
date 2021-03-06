var home_initiated = null
$(document).on('turbolinks:load', function() {

  load_bg('https://images.ctfassets.net/u0haasspfa6q/2sMNoIuT9uGQjKd7UQ2SMQ/1bb98e383745b240920678ea2daa32e5/sell_landscape_photography_online?w=640', '.banner')
  load_bg('https://www.architectureartdesigns.com/wp-content/uploads/2016/02/2-66.jpg', '.property-page')
  
  if(home_initiated == null) {
    homeInit()
    home_initiated = 1
  }
})

load_bg = function(img, sel) {
  $('<img/>').attr('src', img).on('load', function() {
    $(this).remove(); // prevent memory leaks as @benweet suggested
    $(sel).css('background-image', 'url(\'' + img + '\')');
  });
}



homeInit = function() {
  search = function() {
    $.ajax({
      url: '/properties/search',
      data: { q: $('input.search').val() },
      method: 'GET',
      success: function(data) {
        $('.properties').html(data)
      }
    })
    
  }

  suggestion = function() {
    $.ajax({
      url: '/properties/suggestions',
      data: {q: $('input.search').val()},
      success: function(data) {
        $('.suggestions.general').removeClass('d-none')
        $('.suggestions.general').html('')
        $.each(data.suggestions, function(i, value){
          $('.suggestions.general').append('<div class="suggestion" >' + value + '</div>')
        }) 
      }
    })
  }
  $(document).on('keyup', 'input.search', $.debounce(2000, search))
  $(document).on('keyup', 'input.search', $.debounce(1000, suggestion))

  $(document).on('click', '.general .suggestion', function(){
    $('.search').val(this.textContent)
    search()
  })

  $(document).on('ajax:success', '.contact-form', function(e) {
    $('.contact_us_form').html(e.detail[2].responseText)
  })
  $(document).on('ajax:error', '.contact-form', function(e) {
    $('.contact_us_form').html(e.detail[2].responseText)
  })

  $(document).on('ajax:success', '.home .property-category', function(e) {
    $('.property-page').html(e.detail[2].responseText)
  })


  $(document).on('click', '.subnav-item', function(e) {
    $('.subnav-item').removeClass('highlight')
    $(this).addClass('highlight')
  })
  
}