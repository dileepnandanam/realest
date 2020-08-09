initMasonry = function() {
  $('.users').imagesLoaded(function() {
    $('.users').masonry({
      itemSelector: '.user',
      gutter: 100
    })
  })
}

$(document).on('turbolinks:load', function() {
  initMasonry()
  $(document).on('ajax:success', '.new_response', function(e) {
    $(this).replaceWith(e.detail[2].responseText)
    initMasonry()
  })
  $(document).on('ajax:error', '.new_response', function(e) {
    $(this).replaceWith(e.detail[2].responseText)
    initMasonry()
  })

  $(document).on('ajax:success', '.user-action', function(e) {
    $(this).siblings('.response-content').html(e.detail[2].responseText)
    $(this).closest('.user-thumb').find('.user-action').remove()
    initMasonry()
  })

  search = function(gender) {
    query = $('.search').val()
    $.ajax({
      url: 'users',
      method: 'GET',
      data: {
        query: query,
        gender: gender
      }, success: function(data) {
        $('.users-container').html(data)
        initMasonry()
      }
    })
  }

  $('.search-male').click(function(e) {
    search('male')
    e.preventDefault()
  })
  $('.search-female').click(function(e) {
    search('female')
    e.preventDefault()
  })
  $('.search-others').click(function(e) {
    search('other')
    e.preventDefault()
  })

  $('.unsigned').click(function(e) {
    window.location.href = '/logins/new'
  })
  $(document).on('ajax:success', '.paginate', function(e) {
    $('.view-more').replaceWith(e.detail[2].responseText)
    initMasonry()
  })
})