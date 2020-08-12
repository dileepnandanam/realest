$(document).on('turbolinks:load', function() {
  search = function() {
    $.ajax({
      url: '/properties?' + $('.filter-form').serialize(),
      dataType: 'html',
      success: function(data) {
        $('.properties').html(data)
      }
    })
  }

  suggestion = function() {
    $.ajax({
      url: '/properties/suggest',
      data: {query: $('.place-filter-field').val()},
      success: function(data) {
        $('.suggestions').removeClass('d-none')
        $('.suggestions').html('')
        $.each(data.suggestions, function(i, value){
          $('.suggestions').append('<div class="suggestion" >' + value + '</div>')
        }) 
      }
    })
  }
  $('body').click(function(e){
    if(e.target != $('.suggestions'))
      $('.suggestions').addClass('d-none')
  })
  
  $(document).on('click', '.suggestion', function(){
    $('.place-filter-field').val(this.textContent)
  })



  $('.filter-field').on('keyup', search)
  $('.place-filter-field').on('change', $.debounce(1000, search))
  $('.place-filter-field').on('keyup', $.debounce(100, suggestion))


  $(document).on('ajax:success', '.property-action-link', function(e) {
    $(this).closest('.property-action').replaceWith(e.detail[2].responseText)
  })

  $(document).on('ajax:success', '.more-interests-link', function(e) {
    $('.more-interests-link').replaceWith(e.detail[2].responseText)
  })
})