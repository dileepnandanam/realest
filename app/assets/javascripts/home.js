$(document).on('turbolinks:load', function() {
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
  $('input.search').on('keyup', $.debounce(2000, search))
  $('input.search').on('keyup', $.debounce(1000, suggestion))

  $(document).on('click', '.general .suggestion', function(){
    $('.search').val(this.textContent)
    search()
  })
})