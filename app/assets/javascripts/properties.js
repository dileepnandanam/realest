var filter_initiated = null
$(document).on('turbolinks:load', function() {
  if(filter_initiated == null) {
    filterInit()
    filter_initiated = 1
  }
})

filterInit = function() {
  search_properties = function() {
    $.ajax({
      url: $('.filter-form').data('url') + '?' + $('.filter-form').serialize(),
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
        if(data.suggestions.length > 0)
          $('.suggestions.places').removeClass('d-none')
        $('.suggestions.places').html('')
        $.each(data.suggestions, function(i, value){
          $('.suggestions.places').append('<div class="suggestion" >' + value + '</div>')
        }) 
      }
    })
  }
  $(document).on('keyup', '.place-filter-field', $.debounce(500, place_suggestion))
  $(document).on('keyup', '.filter-field', $.debounce(1000, search_properties))
  $(document).on('change', '.place-filter-field', $.debounce(1000, search_properties))






  $(document).on('click', 'body', function(e){
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

  $(document).on('click', '.sub-nav-ico', function() {
    $('.breakdown').hide()
    $('.' + $(this).data('target')).fadeIn('fast')
  })



  $(document).on('ajax:success', '.new-property-asset-link', function(e) {
    $('.new-property-asset-form-container').html(e.detail[2].responseText)
  })
  $(document).on('ajax:success', '.new-property-asset-form', function(e) {
    $('.property-assets').append(e.detail[2].responseText)
    $('.new-property-asset-form').remove()
  })

  $(document).on('ajax:success', '.seen-link', function(e) {
    $(this).closest('.interest').addClass('seen')
    $(this).closest('.interest').removeClass('unseen')
  })
  $(document).on('ajax:success', '.unseen-link', function(e) {
    $(this).closest('.interest').removeClass('seen')
    $(this).closest('.interest').addClass('unseen')
  })
}