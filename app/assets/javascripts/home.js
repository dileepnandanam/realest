var home_initiated = null
$(document).on('turbolinks:load', function() {
  if(home_initiated == null) {
    homeInit()
    home_initiated = 1
  }
})

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
    $('.contact_us.form').html(e.detail[2].responseText)
  })
  $(document).on('ajax:error', '.contact-form', function(e) {
    $('.contact_us.form').html(e.detail[2].responseText)
  })

  $(document).on('ajax:success', '.home .property-category', function(e) {
    $('.property-page').html(e.detail[2].responseText)
  })
}