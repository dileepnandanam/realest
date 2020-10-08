$(document).on('turbolinks:load', function() {
  search_properties = function() {
    $.ajax({
      url: '/properties?' + $('.filter-form').serialize(),
      dataType: 'html',
      success: function(data) {
        $('.properties').html(data)
      }
    })
  }

  place_suggestion = function() {
    $.ajax({
      url: '/properties/suggest',
      data: {query: $('.place-filter-field').val()},
      success: function(data) {
        $('.suggestions.places').removeClass('d-none')
        $('.suggestions.places').html('')
        $.each(data.suggestions, function(i, value){
          $('.suggestions.places').append('<div class="suggestion" >' + value + '</div>')
        }) 
      }
    })
  }

  $('.property-filter-field').on('keyup', search_properties)
  $('.property-place-filter-field').on('change', $.debounce(1000, search_properties))
  $('.property-place-filter-field').on('keyup', $.debounce(100, place_suggestion))
  $('.property-place-filter-field').on('keyup', $.debounce(1000, search_properties))

  





  search_cars = function() {
    $.ajax({
      url: '/cars?' + $('.filter-form').serialize(),
      dataType: 'html',
      success: function(data) {
        $('.properties').html(data)
      }
    })
  }

  brand_suggestion = function() {
    $.ajax({
      url: '/cars/suggest_brand',
      data: {query: $('.place-filter-field').val()},
      success: function(data) {
        $('.suggestions.brands').removeClass('d-none')
        $('.suggestions.brands').html('')
        $.each(data.suggestions, function(i, value){
          $('.suggestions.brands').append('<div class="suggestion" >' + value + '</div>')
        }) 
      }
    })
  }

  model_suggestion = function() {
    $.ajax({
      url: '/cars/suggest_model',
      data: {query: $('.place-filter-field').val()},
      success: function(data) {
        $('.suggestions.models').removeClass('d-none')
        $('.suggestions.models').html('')
        $.each(data.suggestions, function(i, value){
          $('.suggestions.models').append('<div class="suggestion" >' + value + '</div>')
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





  $(document).on('ajax:success', '.property-action-link', function(e) {
    $(this).closest('.property-action').replaceWith(e.detail[2].responseText)
  })

  $(document).on('ajax:success', '.more-interests-link', function(e) {
    $('.more-interests-link').replaceWith(e.detail[2].responseText)
  })
})