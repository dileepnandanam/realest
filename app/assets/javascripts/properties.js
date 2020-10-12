$(document).on('turbolinks:load', function() {
  search_properties = function() {
    $.ajax({
      url: '/lands?' + $('.filter-form').serialize(),
      dataType: 'html',
      success: function(data) {
        $('.properties').html(data)
      }
    })
  }

  place_suggestion = function() {
    $.ajax({
      url: '/lands/suggest',
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
  $(document).on('keyup', '.place-filter-field', $.debounce(100, place_suggestion))




  $(document).on('keyup', '.property-filter-field', $.debounce(1000, search_properties))
  $(document).on('change', '.property-place-filter-field', $.debounce(1000, search_properties))
  $(document).on('keyup', '.property-place-filter-field', $.debounce(1000, search_properties))

  
  





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
      data: {query: $('.car-brand-filter-field').val()},
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
      data: {query: $('.car-model-filter-field').val()},
      success: function(data) {
        $('.suggestions.models').removeClass('d-none')
        $('.suggestions.models').html('')
        $.each(data.suggestions, function(i, value){
          $('.suggestions.models').append('<div class="suggestion" >' + value + '</div>')
        }) 
      }
    })
  }

  

  $(document).on('keyup', '.car-filter-field', $.debounce(100, search_cars))
  $(document).on('change', '.car-place-filter-field', $.debounce(1000, search_cars))
  $(document).on('keyup','.car-place-filter-field', $.debounce(1000, search_cars))
  $(document).on('keyup', '.car-brand-filter-field', $.debounce(100, brand_suggestion))
  $(document).on('keyup', '.car-model-filter-field', $.debounce(100, model_suggestion))
  $(document).on('change', '.car-brand-filter-field', $.debounce(100, search_cars))
  $(document).on('change', '.car-model-filter-field', $.debounce(100, search_cars))
  
  search_servents = function() {
    $.ajax({
      url: '/servents?' + $('.filter-form').serialize(),
      dataType: 'html',
      success: function(data) {
        $('.properties').html(data)
      }
    })
  }

  $(document).on('keyup', '.servent-filter-field', search_servents)
  $(document).on('change', '.servent-place-filter-field', $.debounce(1000, search_servents))
  $(document).on('keyup', '.servent-place-filter-field', $.debounce(1000, search_servents))

  




  search_house = function() {
    $.ajax({
      url: '/houses?' + $('.filter-form').serialize(),
      dataType: 'html',
      success: function(data) {
        $('.properties').html(data)
      }
    })
  }





  $(document).on('keyup', '.house-filter-field', search_house)
  $(document).on('change', '.house-place-filter-field', $.debounce(1000, search_house))
  $(document).on('keyup', '.house-place-filter-field', $.debounce(1000, search_house))




  search_office = function() {
    $.ajax({
      url: '/offices?' + $('.filter-form').serialize(),
      dataType: 'html',
      success: function(data) {
        $('.properties').html(data)
      }
    })
  }





  $(document).on('keyup', '.office-filter-field', search_office)
  $(document).on('change', '.office-place-filter-field', $.debounce(1000, search_office))
  $(document).on('keyup', '.office-place-filter-field', $.debounce(1000, search_office))













  $('body').click(function(e){
    if(e.target != $('.suggestions'))
      $('.suggestions').addClass('d-none')
  })
  
  $(document).on('click', '.places .suggestion', function(){
    $('.place-filter-field').val(this.textContent)
  })
  $(document).on('click', '.brands .suggestion', function(){
    $('.car-brand-filter-field').val(this.textContent)
  })
  $(document).on('click', '.models .suggestion', function(){
    $('.car-model-filter-field').val(this.textContent)
  })





  $(document).on('ajax:success', '.property-action-link', function(e) {
    $(this).closest('.property-action').replaceWith(e.detail[2].responseText)
  })

  $(document).on('ajax:success', '.more-interests-link', function(e) {
    $('.more-interests-link').replaceWith(e.detail[2].responseText)
  })


  $(document).on('ajax:success', '.state, .property-category', function(e) {
    $('.property-page').html(e.detail[2].responseText)
  })



  $(document).on('ajax:success', '.new-property-asset-link', function(e) {
    $('.new-property-asset-form-container').html(e.detail[2].responseText)
  })
  $(document).on('ajax:success', '.new-property-asset-form', function(e) {
    $('.property-assets').append(e.detail[2].responseText)
    $('.new-property-asset-form').remove()
  })
})